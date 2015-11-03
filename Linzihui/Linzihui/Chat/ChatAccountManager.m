//
//  ChatAccountManager.m
//  Taling
//
//  Created by ZhuHaikun on 15/10/17.
//  Copyright © 2015年 ZhuHaikun. All rights reserved.
//

#import "ChatAccountManager.h"
#import "NSUserDefaultKeys.h"
#import "ConstantsHeaders.h"

static NSString *password = @"123456";
static ChatAccountManager *manager;

@implementation ChatAccountManager

+(ChatAccountManager*)shareChatAccountManager
{
    
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
       
        manager = [[ChatAccountManager alloc]init];
        
    });
    
    return manager;
    
    
}

-(void)loginWithAccount:(NSString *)account successBlock:(void (^)(BOOL))isSuccess
{
   
    //异步登陆账号
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:account
                                                        password:password
                                                      completion:
     ^(NSDictionary *loginInfo, EMError *error) {
         
         if (loginInfo && !error) {
             //设置是否自动登录
             [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
             
           
             //获取数据库中数据
             [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
             
             //获取群组列表
             [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsList];
             
             if (isSuccess) {
                 
                 isSuccess(YES);
             }
            
             [[NSUserDefaults standardUserDefaults ] setBool:YES forKey:kEasyMobHadLogin];
             [[NSUserDefaults standardUserDefaults ] synchronize];
             
             
   
             
   
         }
         else
         {
             switch (error.errorCode)
             {
                 case EMErrorNotFound:
                 {
                    
                     [self registWithAccount:account successBlock:isSuccess];
                     
//                     [CommonMethods showDefaultErrorString:@"未找到该账户注册信息"];
                     
                 }
                     break;
                 case EMErrorNetworkNotConnected:
                 {
                     
                 }
                
                     break;
                 case EMErrorServerNotReachable:
                 {
//                     [CommonMethods showDefaultErrorString:@"登陆失败,请稍后再试"];
                     
                 }
                
                     break;
                 case EMErrorServerAuthenticationFailure:
                 {
//                     [CommonMethods showDefaultErrorString:@"登陆失败"];
                     
                 }
                    
                     break;
                 case EMErrorServerTimeout:
                 {
//                     [CommonMethods showDefaultErrorString:@"登陆失败"];
                 }
             
                     break;
                 default:
                    
                     break;
             }
         }
     } onQueue:nil];

}

-(void)registWithAccount:(NSString*)account  successBlock:(void(^)(BOOL))isSuccess
{
    //异步注册账号
    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:account
                                                         password:password
                                                   withCompletion:
     ^(NSString *username, NSString *password, EMError *error) {
        
         
         if (!error) {
             
             [self loginWithAccount:account successBlock:isSuccess];
             
        
         }else{
             switch (error.errorCode) {
                 case EMErrorServerNotReachable:
                 {
                     
                 }
               
                     break;
                 case EMErrorServerDuplicatedAccount:
                 {
                    [self loginWithAccount:account successBlock:isSuccess];
                 }
             
                     break;
                 case EMErrorNetworkNotConnected:
                 {
                     
                 }
                
                     break;
                 case EMErrorServerTimeout:
                 {
                     
                 }
                     break;
                 default:
                 {
                     
                 }
                    
                     break;
             }
         }
     } onQueue:nil];
}



@end
