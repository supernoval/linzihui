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

@interface EMHelper : NSObject<IChatManagerDelegate>

+(EMHelper*)getHelper;


#pragma mark - 接受好友请求
-(BOOL)accepBuddyRequestWithUserName:(NSString*)username error:(EMError**)error;

#pragma mark -  发送好友请求
+(void)sendFriendRequestWithBuddyName:(NSString*)buddyName Mesage:(NSString*)message;

#pragma mark  - 检查是否为好友
+(BOOL)isBuddyWithUsername:(NSString*)userName;

#pragma mark - 创建群组 
+ (void)createGroupWithinitTitle:(NSString*)title description:(NSString*)description invitees:(NSArray*)invitees welcomeMsg:(NSString*)welcomeMsg result:(void(^)(BOOL success,EMGroup*group))result;

#pragma  mark - 邀请加入群
+ (void)inviteBuddyJoinGroup;





@end
