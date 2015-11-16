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
#import "EaseMob.h"
#import "EMHelper.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

@interface AppDelegate ()<WXApiDelegate>
{
   
    
}
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
    
    //环信注册
    [[EaseMob sharedInstance] registerSDKWithAppKey:kEseamobAppKey apnsCertName:nil];
    
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    [[EaseMob sharedInstance].chatManager setIsAutoFetchBuddyList:YES];
    
    //初始化下环信 监听
    [EMHelper getHelper];
    
    //注册微信
    [WXApi registerApp:kWeiChatAppID];
    
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >=8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
    }
    
    
    
  
    
  
    
    return YES;
}

#ifdef __IPHONE_8_0

-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
    
}

-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
{
    
}
#endif


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    
    NSString *dToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    
    dToken = [dToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"STR:%@",dToken);
    
    
    if (dToken)
    {
        
        
    }
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    NSLog(@"url host:%@",url.host);
    
    if ([url.host isEqualToString:@"platformId=wechat"]) {
        
          return [WXApi handleOpenURL:url delegate:self];
    }
    else if([url.host isEqualToString:@"response_from_qq"])
    {
        
        return  [TencentOAuth HandleOpenURL:url];
        
    }
    
  
    return NO;
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
   
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  
     [[EaseMob sharedInstance] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
   
     [[EaseMob sharedInstance] applicationWillEnterForeground:application];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
     [[EaseMob sharedInstance] applicationWillTerminate:application];
}

#pragma mark - WXApiDelegate
-(void)onReq:(BaseReq *)req
{
    NSLog(@"req:%@",req);
    
}

-(void)onResp:(BaseResp *)resp
{
    NSLog(@"resp:%@",resp);
    NSLog(@"errorCode:%d,errorStr:%@",resp.errCode,resp.errStr);
}


@end
