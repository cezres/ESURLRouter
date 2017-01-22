//
//  ESURLRouter.m
//  ESURLRouter
//
//  Created by 翟泉 on 2016/11/23.
//  Copyright © 2016年 翟泉. All rights reserved.
//

#import "ESURLRouter.h"


@interface ESURLRoute : NSObject

@property (strong, nonatomic) NSString *pattern;
@property (strong, nonatomic) ESURLRouterCanOpen canOpen;
@property (strong, nonatomic) ESURLRouterHandler handler;

@end

@implementation ESURLRoute

@end


@implementation ESURLRouterParameters

+ (instancetype)paramsWithURL:(NSString *)URL withUserInfo:(NSDictionary *)userInfo completion:(ESURLRouterCompletion)completion
{
    ESURLRouterParameters *parameters = [[ESURLRouterParameters alloc] init];
    parameters.URL = URL;
    parameters.userInfo = userInfo;
    parameters.completion = completion;
    return parameters;
}

@end

@interface ESURLRouter ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, ESURLRoute *> *routes;

@end

@implementation ESURLRouter

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        _routes = [NSMutableDictionary dictionary];
    }
    return self;
}


#pragma mark Register 注册
+ (void)registerPattern:(NSString *)pattern toHandler:(ESURLRouterHandler)handler
{
    [self registerKey:pattern canOpenURL:^BOOL(ESURLRouterParameters * _Nonnull routerParameters) {
        NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:NULL];
        return [expression firstMatchInString:routerParameters.URL options:kNilOptions range:NSMakeRange(0, routerParameters.URL.length)];
    } toHandler:handler];
}
+ (void)registerClass:(Class<ESURLRouterProtocol>)cls
{
    [self registerKey:NSStringFromClass(cls) canOpenURL:^BOOL(ESURLRouterParameters * _Nonnull routerParameters) {
        return [cls canOpen:routerParameters];
    } toHandler:^(ESURLRouterParameters * _Nonnull routerParameters) {
        [cls openURL:routerParameters];
    }];
}
+ (void)registerKey:(NSString *)key canOpenURL:(ESURLRouterCanOpen _Nonnull)canOpen toHandler:(ESURLRouterHandler _Nonnull)handler
{
    ESURLRoute *route = [[ESURLRoute alloc] init];
    route.pattern = key;
    route.canOpen = canOpen;
    route.handler = handler;
    
    [[ESURLRouter sharedInstance].routes setObject:route forKey:key];
}

#pragma mark UnRegister 注销
+ (void)unregisterPattern:(NSString * _Nonnull)pattern
{
    [[ESURLRouter sharedInstance].routes removeObjectForKey:pattern];
}
+ (void)unregisterClass:(Class<ESURLRouterProtocol> _Nonnull)cls
{
    [[ESURLRouter sharedInstance].routes removeObjectForKey:NSStringFromClass(cls)];
}
+ (void)unregisterKey:(NSString * _Nonnull)key
{
    [[ESURLRouter sharedInstance].routes removeObjectForKey:key];
}

#pragma mark OpenURL 打开URL
+ (BOOL)openURL:(NSString * _Nonnull)URL
{
    return [self openURL:URL withUserInfo:NULL completion:NULL];
}
+ (BOOL)openURL:(NSString * _Nonnull)URL withUserInfo:(NSDictionary * _Nonnull)userInfo
{
    return [self openURL:URL withUserInfo:userInfo completion:NULL];
}
+ (BOOL)openURL:(NSString * _Nonnull)URL completion:(ESURLRouterCompletion _Nonnull)completion
{
    return [self openURL:URL withUserInfo:NULL completion:completion];
}
+ (BOOL)openURL:(NSString * _Nonnull)URL withUserInfo:(NSDictionary * _Nullable)userInfo completion:(ESURLRouterCompletion _Nullable)completion
{
    ESURLRouterParameters *routerParameters = [ESURLRouterParameters paramsWithURL:URL withUserInfo:userInfo completion:completion];
    
    for (ESURLRoute *route in [ESURLRouter sharedInstance].routes.allValues) {
        if (route.canOpen(routerParameters)) {
            route.handler(routerParameters);
            return YES;
        }
    }
    
    return NO;
}

+ (id)objectForURL:(NSString *)URL
{
    return [self objectForURL:URL withUserInfo:NULL];
}
+ (id)objectForURL:(NSString *)URL withUserInfo:(NSDictionary *)userInfo
{
    __block id resultObject;
    ESURLRouterParameters *routerParameters = [ESURLRouterParameters paramsWithURL:URL withUserInfo:userInfo completion:^(id  _Nullable result) {
        resultObject = result;
    }];
    for (ESURLRoute *route in [ESURLRouter sharedInstance].routes.allValues) {
        if (route.canOpen(routerParameters)) {
            route.handler(routerParameters);
            return resultObject;
        }
    }
    return NULL;
}

@end


