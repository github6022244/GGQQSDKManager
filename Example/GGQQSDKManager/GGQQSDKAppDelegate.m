//
//  GGQQSDKAppDelegate.m
//  GGQQSDKManager
//
//  Created by github6022244 on 05/27/2026.
//  Copyright (c) 2026 github6022244. All rights reserved.
//

#import "GGQQSDKAppDelegate.h"
#import "GGQQSDKManager.h"

@implementation GGQQSDKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [GGQQSDKManager setUserAgreedAuthorization:YES];
    
    [[GGQQSDKManager sharedManager] setupWithAppID:@"YOUR_APP_ID" 
                                     universalLink:@"YOUR_UNIVERSAL_LINK"
                                enableUniversalLink:YES];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - URL Scheme & Universal Link Handling

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return [self handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [self handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        NSURL *url = userActivity.webpageURL;
        if (url) {
            return [self handleUniversalLink:url];
        }
    }
    return YES;
}

/**
 * 链式处理 URL Scheme
 * 按顺序尝试各个 SDK，返回第一个能处理的结果
 */
- (BOOL)handleOpenURL:(NSURL *)url {
    // 1. 尝试 QQ SDK
    if ([GGQQSDKManager canHandleURL:url]) {
        if ([[GGQQSDKManager sharedManager] handleOpenURL:url]) {
            return YES;
        }
    }
    
    // 2. 尝试 微信 SDK (示例，需引入微信SDK)
    // if ([WXApi handleOpenURL:url delegate:self.wxDelegate]) {
    //     return YES;
    // }
    
    // 3. 尝试 新浪微博 SDK (示例，需引入微博SDK)
    // if ([WeiboSDK handleOpenURL:url delegate:self.weiboDelegate]) {
    //     return YES;
    // }
    
    // 4. 其他自定义URL处理
    // ...
    
    return NO;
}

/**
 * 链式处理 Universal Link
 * 按顺序尝试各个 SDK，返回第一个能处理的结果
 */
- (BOOL)handleUniversalLink:(NSURL *)url {
    // 1. 尝试 QQ SDK
    if ([GGQQSDKManager canHandleUniversalLink:url]) {
        if ([[GGQQSDKManager sharedManager] handleUniversalLink:url]) {
            return YES;
        }
    }
    
    // 2. 尝试 微信 SDK (示例，需引入微信SDK)
    // if ([WXApi handleUniversalLink:url delegate:self.wxDelegate]) {
    //     return YES;
    // }
    
    // 3. 尝试 新浪微博 SDK (示例，需引入微博SDK)
    // ...
    
    // 4. 其他自定义Universal Link处理
    // ...
    
    return NO;
}

@end
