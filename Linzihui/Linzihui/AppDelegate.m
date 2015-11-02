//
//  AppDelegate.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/10/31.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "AppDelegate.h"
#import <BmobSDK/Bmob.h>
#import "Constants.h"
#import <SMS_SDK/SMSSDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [Bmob registerWithAppKey:kBmobApplicationID];
    
    //设置navigationbar
    [[UINavigationBar appearance] setTintColor:kNavigationTintColor];
    [[UINavigationBar appearance ] setBarTintColor:kNavigationBarColor];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [[UITabBar appearance] setTintColor:kNavigationBarColor];
    [[UITabBar appearance]setBarTintColor:[UIColor whiteColor]];
    
    //sharesdk sms 注册
    [SMSSDK registerApp:kShareSMSAppKey withSecret:kShareSMSAppSecret];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
