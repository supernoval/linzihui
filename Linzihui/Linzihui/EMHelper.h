//
//  EMHelper.h
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/10.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

typedef enum{
    ApplyStyleFriend            = 0,
    ApplyStyleGroupInvitation,
    ApplyStyleJoinGroup,
}ApplyStyle;


#import <Foundation/Foundation.h>
#import "EaseMob.h"
#import "ConstantsHeaders.h"
#import "InvitationManager.h"
#import "ModelHeader.h"


@interface EMHelper : NSObject<IChatManagerDelegate>

+(EMHelper*)getHelper;


#pragma mark - 接受好友请求
-(BOOL)accepBuddyRequestWithUserName:(NSString*)username error:(EMError**)error;

#pragma mark -  发送好友请求
+(void)sendFriendRequestWithBuddyName:(NSString*)buddyName Mesage:(NSString*)message;

#pragma mark  - 检查是否为好友
+(BOOL)isBuddyWithUsername:(NSString*)userName;

#pragma mark - 创建群组 
+ (void)createGroupWithinitTitle:(NSString*)title description:(NSString*)description invitees:(NSArray*)invitees welcomeMsg:(NSString*)welcomeMsg friends:(NSArray*)friends result:(void(^)(BOOL success,EMGroup*group))result;

#pragma  mark - 邀请加入群
+ (void)inviteBuddyJoinGroup;

#pragma mark - 添加群
+(void)joinGroup:(NSString*)groupId username:(NSString*)username result:(void(^)(BOOL success,EMGroup*group))result;

#pragma mark - 申请加群
+(void)applyJoinGroup:(NSString*)groupId groupName:(NSString*)groupName username:(NSString*)username message:(NSString*)msg result:(void(^)(BOOL success,EMGroup*group))result;

#pragma mark - 同意加群
+(void)agreadJoinGroupApplyWithModel:(MyConversation*)converModel result:(void(^)(BOOL success,EMGroup*group))result;

#pragma mark - 拒绝加群申请
+(void)rejectJoinGroupApplyWithModel:(MyConversation*)converModel result:(void(^)(BOOL success,NSString*message))result;


                                                                              




@end
