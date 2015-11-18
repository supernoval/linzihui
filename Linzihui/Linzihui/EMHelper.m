//
//  EMHelper.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/10.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//



#import "EMHelper.h"

@implementation EMHelper

static EMHelper *_helper;

+(EMHelper*)getHelper
{
    static dispatch_once_t onece;
    
    dispatch_once(&onece, ^{
       
        _helper = [[EMHelper alloc]init];
        
        [_helper registerEaseMobNotification];
        
    });
    
    return _helper;
    
}
#pragma mark - registerEaseMobNotification
- (void)registerEaseMobNotification{
    [self unRegisterEaseMobNotification];
    // 将self 添加到SDK回调中，以便本类可以收到SDK回调
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

- (void)unRegisterEaseMobNotification{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}


#pragma mark - IChatManagerDelegate

#pragma mark - EMChatManagerBuddyDelegate

// 好友申请回调
- (void)didReceiveBuddyRequest:(NSString *)username
                       message:(NSString *)message
{
    if (!username) {
        return;
    }
    
    if (!message) {
        message = [NSString stringWithFormat:@"%@请求加你好友", username];
    }
   
    BmobQuery *query = [BmobQuery queryForUser];
    [query whereKey:@"username" equalTo:username];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
       
      
         ApplyEntity *entity = [[ApplyEntity alloc]init];
         entity.applicantUsername = username;
         entity.reason = message;
         entity.style = ApplyStyleFriend;
         
        if (!error && array.count > 0) {
            
            BmobObject *ob = [array firstObject];
            
            NSString *nick = [ob objectForKey:@"nick"];
            NSString *avatar = [ob objectForKey:@"avatar"];
            
            entity.applicantNick = nick;
            entity.avatar = avatar;
            
            
        }
        
          [self addNewApply:entity];
    }];
    
    
    
}


- (void)addNewApply:(ApplyEntity *)entity
{
    if (entity) {
    
            
            NSString *loginUsername = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
            [[InvitationManager sharedInstance] addInvitation:entity loginUser:loginUsername];
            
        
    }
}

#pragma mark - 发送好友请求
+(void)sendFriendRequestWithBuddyName:(NSString *)buddyName Mesage:(NSString *)message
{
    EMError *error;
    [[EaseMob sharedInstance].chatManager addBuddy:buddyName message:message error:&error];
    
    if (error) {
        
        [CommonMethods showDefaultErrorString:@"发送好友请求失败，请重试"];
    }
    else
    {
        [CommonMethods showDefaultErrorString:@"好友请求已发送"];
        
        
    }
}

#pragma mark - 接受好友请求
-(BOOL)accepBuddyRequestWithUserName:(NSString*)username error:(EMError**)error
{
    
     return [[EaseMob sharedInstance ].chatManager acceptBuddyRequest:username error:error];
    
}

#pragma mark  - 检查是否为好友
+(BOOL)isBuddyWithUsername:(NSString*)userName
{
    NSArray *buddyList = [[EaseMob sharedInstance].chatManager buddyList];
    
    for (EMBuddy *buddy in buddyList) {
        
        if ([buddy.username isEqualToString:userName]) {
            
            
            return YES;
        }
    }
    
    return NO;
    
}

#pragma mark - 创建群组
+ (void)createGroupWithinitTitle:(NSString*)title description:(NSString*)description invitees:(NSArray*)invitees welcomeMsg:(NSString*)welcomeMsg
{
    
    [MyProgressHUD showProgress];
    
    
    EMGroupStyleSetting *setting = [[EMGroupStyleSetting alloc]init];
    setting.groupStyle = eGroupStyle_PrivateMemberCanInvite;
    
    [[EaseMob sharedInstance].chatManager asyncCreateGroupWithSubject:title description:description invitees:invitees initialWelcomeMessage:welcomeMsg styleSetting:setting completion:^(EMGroup *group, EMError *error) {
        
        if (!error && group) {
            
            
            BmobObject *_groupOb = [[BmobObject alloc]initWithClassName:kChatGroupTableName];
            
            [_groupOb setObject:group.groupId forKey:@"groupId"];
            
            [_groupOb setObject:group.owner forKey:@"owner_username"];
            
            [_groupOb setObject:group.groupSubject forKey:@"subTitle"];
            [_groupOb setObject:group.description forKey:@"description"];
            [_groupOb setObject:group.members forKey:@"members"];
            
            
         [_groupOb saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            
             [MyProgressHUD dismiss];
             
             if (isSuccessful) {
                 
                 
                  [[NSNotificationCenter defaultCenter ] postNotificationName:kCreategroupSuccessNoti object:group userInfo:@{@"groupid":group.groupId}];
             }
             else
             {
                 NSLog(@"saveGroupError:%@",error);
                 
                 
             }
             
         }];
            
            
          
            
            
            
            
        }
        else
        {
            
            NSLog(@"%s,error:%@",__func__,error);
            
                 [MyProgressHUD dismiss];
            [CommonMethods showDefaultErrorString:@"创建群组失败，请重试"];
            
            
        }
        
        
        
    } onQueue:nil];
    
    
    
}

@end
