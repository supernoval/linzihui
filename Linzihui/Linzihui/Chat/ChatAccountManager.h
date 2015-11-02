//
//  ChatAccountManager.h
//  Taling
//
//  Created by ZhuHaikun on 15/10/17.
//  Copyright © 2015年 ZhuHaikun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EaseMob.h"
@interface ChatAccountManager : NSObject


+(ChatAccountManager*)shareChatAccountManager;


#pragma mark - 登陆 
-(void)loginWithAccount:(NSString*)account successBlock:(void(^)(BOOL))isSuccess;

#pragma mark - 注册
-(void)registWithAccount:(NSString*)account  successBlock:(void(^)(BOOL))isSuccess;

#pragma mark - 添加好友
-(void)sendFriendRequest;


@end
