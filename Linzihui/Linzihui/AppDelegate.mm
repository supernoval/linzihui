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
#import <CoreLocation/CoreLocation.h>
@interface AppDelegate ()<WXApiDelegate,CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
    
    
}

@property (nonatomic) Reachability *internetReachability;

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
    
    
    //定位
    _locationManager = [[CLLocationManager alloc]init];
    
    _locationManager.delegate = self;
    
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >=8.0)
    {
        [_locationManager requestWhenInUseAuthorization];
        
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
    }
    else
    {
        
        [_locationManager startUpdatingLocation];
        
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
    }
    
    

    
    //创建等级
    [BmobHelper saveLevelRecord];
    
    
    
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:kBaiduMapKey generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    
    
    //网络状态监测
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    
    
    [self.internetReachability startNotifier];
    
    NSInteger status = [self.internetReachability currentReachabilityStatus];
    
    if (status  == NotReachable) {
        
        [CommonMethods showDefaultErrorString:@"世界上最远的距离是没有网络"];
        
        
    }
    
    
    return YES;
}

#pragma mark -网络监测

- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
  
    NSInteger status = [curReach currentReachabilityStatus];
    
    
    if (status  == NotReachable) {
        
        
        [CommonMethods showDefaultErrorString:@"世界上最远的距离是没有网络"];
        
        
        
    }
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



#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways ) {
        
        
        [_locationManager startUpdatingLocation];
        
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    
    
    CLLocation *_location = [locations lastObject];
    
    if (_location.coordinate.latitude > 0 && _location.coordinate.longitude > 0) {
        
        [_locationManager stopUpdatingLocation];
        
        [[NSUserDefaults standardUserDefaults ] setFloat:_location.coordinate.latitude forKey:kCurrentLatitude];
        
        [[NSUserDefaults standardUserDefaults] setFloat:_location.coordinate.longitude forKey:kCurrentLongitude];
        
        [[NSUserDefaults standardUserDefaults]  synchronize];
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:kHadLogin]) {
            
            BmobUser *currentUser = [BmobUser getCurrentUser];
            
            BmobGeoPoint *point = [[BmobGeoPoint alloc]initWithLongitude:_location.coordinate.longitude WithLatitude:_location.coordinate.latitude];
            
            [currentUser setObject:point forKey:@"location"];
            
            
            [currentUser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
               
                if (isSuccessful) {
                    
                    NSLog(@"地理坐标保存成功");
                    
                }
                else
                {
                    NSLog(@"地理位置保存失败 ：%@",error);
                    
                    
                }
            }];
        }
        
    }
}



@end
