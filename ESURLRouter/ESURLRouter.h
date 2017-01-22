//
//  ESURLRouter.h
//  ESURLRouter
//
//  Created by 翟泉 on 2016/11/23.
//  Copyright © 2016年 翟泉. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for ESURLRouter.
FOUNDATION_EXPORT double ESURLRouterVersionNumber;

//! Project version string for ESURLRouter.
FOUNDATION_EXPORT const unsigned char ESURLRouterVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <ESURLRouter/PublicHeader.h>


@class ESURLRouterParameters;


typedef void (^ESURLRouterCompletion)(id _Nullable result);
typedef BOOL (^ESURLRouterCanOpen)(ESURLRouterParameters * _Nonnull routerParameters);
typedef void (^ESURLRouterHandler)(ESURLRouterParameters * _Nonnull routerParameters);


@protocol ESURLRouterProtocol <NSObject>

+ (BOOL)canOpen:(ESURLRouterParameters * _Nonnull)parameters;
+ (void)openURL:(ESURLRouterParameters * _Nonnull)parameters;

@end


@interface ESURLRouterParameters : NSObject

@property (copy, nonatomic, nonnull) NSString *URL;
@property (copy, nonatomic, nullable) NSDictionary *urlParams;

@property (copy, nonatomic, nullable) NSDictionary *userInfo;
@property (copy, nonatomic, nullable) ESURLRouterCompletion completion;

@end


@interface ESURLRouter : NSObject


#pragma mark Register 注册

+ (void)registerPattern:(NSString * _Nonnull)Pattern toHandler:(ESURLRouterHandler _Nonnull)handler;
+ (void)registerClass:(Class<ESURLRouterProtocol> _Nonnull)cls;
+ (void)registerKey:(NSString * _Nonnull)key canOpenURL:(ESURLRouterCanOpen _Nonnull)canOpen toHandler:(ESURLRouterHandler _Nonnull)handler;

#pragma mark UnRegister 注销

+ (void)unregisterPattern:(NSString * _Nonnull)URLPattern;
+ (void)unregisterClass:(Class<ESURLRouterProtocol> _Nonnull)cls;
+ (void)unregisterKey:(NSString * _Nonnull)key;

#pragma mark OpenURL 打开URL

+ (BOOL)openURL:(NSString * _Nonnull)URL;
+ (BOOL)openURL:(NSString * _Nonnull)URL withUserInfo:(NSDictionary * _Nonnull)userInfo;
+ (BOOL)openURL:(NSString * _Nonnull)URL completion:(ESURLRouterCompletion _Nonnull)completion;
+ (BOOL)openURL:(NSString * _Nonnull)URL withUserInfo:(NSDictionary * _Nullable)userInfo completion:(ESURLRouterCompletion _Nullable)completion;


+ (id _Nullable)objectForURL:(NSString * _Nonnull)URL;
+ (id _Nullable)objectForURL:(NSString * _Nonnull)URL withUserInfo:(NSDictionary * _Nullable)userInfo;

@end


