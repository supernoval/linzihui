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

-(void)didConnectionChanged:(EMConnectionType)connectionType fromConnectionType:(EMConnectionType)fromConnectionType
{
    if (connectionType == eConnectionType_None) {
        
        
    }
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
+ (void)createGroupWithinitTitle:(NSString*)title description:(NSString*)description invitees:(NSArray*)invitees welcomeMsg:(NSString*)welcomeMsg friends:(NSArray*)friends result:(void(^)(BOOL success,EMGroup*group))result
{
    
    [MyProgressHUD showProgress];
    
    
    EMGroupStyleSetting *setting = [[EMGroupStyleSetting alloc]init];
    setting.groupStyle = eGroupStyle_PublicJoinNeedApproval;
    
    [[EaseMob sharedInstance].chatManager asyncCreateGroupWithSubject:title description:description invitees:invitees initialWelcomeMessage:welcomeMsg styleSetting:setting completion:^(EMGroup *group, EMError *error) {
        
        if (!error && group) {
            
            BmobUser *currentUser = [BmobUser getCurrentUser];
            
            
            BmobObject *_groupOb = [[BmobObject alloc]initWithClassName:kChatGroupTableName];
            
            [_groupOb setObject:group.groupId forKey:@"groupId"];
            
            [_groupOb setObject:group.owner forKey:@"owner_username"];
            
            [_groupOb setObject:currentUser forKey:@"owner"];
            
            [_groupOb setObject:group.groupSubject forKey:@"subTitle"];
            [_groupOb setObject:group.description forKey:@"description"];
            [_groupOb setObject:group.members forKey:@"members"];
            
            NSMutableArray *muArray = [[NSMutableArray alloc]init];
            
            for (UserModel *model in friends) {
                
                NSDictionary *dic = [model toDictionary];
                
                [muArray addObject:dic];
                
                
                
            }
            
            [_groupOb setObject:muArray forKey:@"members"];
            
            
            CGFloat latitude = [[NSUserDefaults standardUserDefaults] floatForKey:kCurrentLatitude];
            CGFloat longitude = [[NSUserDefaults standardUserDefaults] floatForKey:kCurrentLongitude];
            
            BmobGeoPoint *point = [[BmobGeoPoint alloc]init];
            
            point.latitude = latitude;
            
            point.longitude = longitude;
            
            [_groupOb setObject:point forKey:@"location"];
            
            
         [_groupOb saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            
             [MyProgressHUD dismiss];
             
             if (isSuccessful) {
                 
                 if (result) {
                     
                     result(YES,group);
                 }
                 
                
             }
             else
             {
                 
                 if (result) {
                     
                     result(NO,nil);
                 }
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

#pragma mark - 添加群
+(void)joinGroup:(NSString*)groupId username:(NSString*)username result:(void(^)(BOOL success,EMGroup*group))result
{
    [[EaseMob sharedInstance].chatManager asyncJoinPublicGroup:groupId completion:^(EMGroup *group, EMError *error) {
        
        
        
        if (!error && group ) {
            
        
            UserModel *currentUserModel = [BmobHelper getCurrentUserModel];
            
            NSDictionary *dic = [currentUserModel toDictionary];
            
            
            BmobQuery *queryGroup = [BmobQuery queryWithClassName:kChatGroupTableName];
            
            [queryGroup whereKey:@"groupid" equalTo:groupId];
            
            [queryGroup findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
               
                if (array.count > 0) {
                    
                    
                    BmobObject *ob =[array firstObject];
                    
                    [ob addObjectsFromArray:@[dic] forKey:@"members"];
                    
                    [ob updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                       
                        if (isSuccessful) {
                            
                            
                            NSLog(@"添加成功");
                            
                        }
                        
                    }];
                    
                }
            }];
            
            
            
            if (result) {
                
                result(YES,group);
                
                
            }
        }
        else
        {
            result(NO,nil);
            
        }
        
    } onQueue:nil];
}

#pragma mark - 申请加群
+(void)applyJoinGroup:(NSString*)groupId groupName:(NSString*)groupName username:(NSString*)username message:(NSString*)msg result:(void(^)(BOOL success,EMGroup*group))result
{
    [[EaseMob sharedInstance].chatManager asyncApplyJoinPublicGroup:groupId withGroupname:groupName message:msg completion:^(EMGroup *group, EMError *error) {
        
        if (group) {
            
            if (result) {
                
                result(YES,group);
                
            }
        }
        else
        {
            if (result) {
                
                result(NO,nil);
                
            }
        }
        
    } onQueue:nil];
    
}

#pragma mark - 同意加群
+(void)agreadJoinGroupApplyWithModel:(MyConversation*)converModel result:(void(^)(BOOL success,EMGroup*group))result
{
    [[EaseMob sharedInstance].chatManager asyncAcceptApplyJoinGroup:converModel.groupId groupname:converModel.subTitle applicant:converModel.username completion:^(EMError *error) {
        
        if (!error) {
            
            if (result) {
                
                [self addMemberToGroup:converModel.groupId username:converModel.username];
                
                result(YES,nil);
            }
        }
        else
        {
            if (result) {
                
                result(NO,nil);
                
            }
        }
        
    } onQueue:nil];
}

#pragma mark - 拒绝加群申请
+(void)rejectJoinGroupApplyWithModel:(MyConversation*)converModel result:(void(^)(BOOL success,NSString*message))result
{
    
    [[EaseMob sharedInstance].chatManager rejectApplyJoinGroup:converModel.groupId groupname:converModel.subTitle toApplicant:converModel.username reason:converModel.reason];
    
    
}

#pragma mark - 将群组新成员加入到bmob members 当中
+(void)addMemberToGroup:(NSString*)groupId username:(NSString*)username
{
    BmobQuery *queryForUser = [BmobQuery queryForUser];
    
    [queryForUser whereKey:@"username" equalTo:username];
    
    [queryForUser findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
       
        
        if (!error) {
            
            if (array.count > 0) {
                
                BmobObject *userOB = [array firstObject];
                
                NSDictionary *dic = [userOB valueForKey:kBmobDataDic];
                
                if (dic) {
                    
                    BmobQuery *queryChatGroup = [BmobQuery queryWithClassName:kChatGroupTableName];
                    
                    [queryChatGroup whereKey:@"groupId" equalTo:groupId];
                    
                    [queryChatGroup findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                       
                        if (!error) {
                            
                            BmobObject *chatGroupOB = [array firstObject];
                            
                            [chatGroupOB addObjectsFromArray:@[dic] forKey:@"members"];
                            
                            [chatGroupOB updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                               
                                if (isSuccessful) {
                                    
                                    NSLog(@"群组成员添加成功");
                                    
                                    
                                }
                                
                            }];
                        }
                    }];
                }
            }
        }
        
    }];
}

@end
