//
//  ViewController.m
//  ESURLRouterDemo
//
//  Created by 翟泉 on 2017/1/17.
//  Copyright © 2017年 翟泉. All rights reserved.
//

#import "ViewController.h"
#import "ESURLRouter.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    ESURLRouterHandler productHandler = ^(ESURLRouterParameters * _Nonnull routerParameters) {
        NSLog(@"商品详情");
        !routerParameters.completion ?: routerParameters.completion(@1008611);
    };
    
    [ESURLRouter registerPattern:@"^http.*\\.d2cmall\\.com(?<!/auction)/product/(\\d+)" toHandler:productHandler];
//    [ESURLRouter registerPattern:@"^/product/(\\d+)$" toHandler:productHandler];
    [ESURLRouter registerPattern:@"^d2cmall://product/(\\d+)$" toHandler:productHandler];
    
    [ESURLRouter openURL:@"http://www.d2cmall.com/product/142937"];
    [ESURLRouter openURL:@"/product/142937"];
    [ESURLRouter openURL:@"d2cmall://product/142937"];
    [ESURLRouter openURL:@"xxxx/product/142937"];
    
    
    
    [ESURLRouter registerKey:@"商品详情" canOpenURL:^BOOL(ESURLRouterParameters * _Nonnull routerParameters) {
        NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:@"^/product/(\\d+)$" options:NSRegularExpressionCaseInsensitive error:NULL];
        NSTextCheckingResult *result = [expression firstMatchInString:routerParameters.URL options:kNilOptions range:NSMakeRange(0, routerParameters.URL.length)];
        if (result) {
            routerParameters.urlParams = @{@"id": @(routerParameters.URL.lastPathComponent.integerValue)};
        }
        return result;
    } toHandler:^(ESURLRouterParameters * _Nonnull routerParameters) {
        routerParameters.completion([routerParameters.urlParams objectForKey:@"id"]);
    }];
    
    
    NSLog(@"%@", [ESURLRouter objectForURL:@"/product/142937"]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
