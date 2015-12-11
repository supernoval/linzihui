//
//  BmobHelper.h
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/8.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>
#import "ModelHeader.h"
#import "EaseMob.h"
#import "NSUserDefaultKeys.h"
#import "EMHelper.h"

typedef void (^successBlock)(BOOL isSuccess);
typedef void (^getObjectModelBlock)(BOOL success,id object);

@interface BmobHelper : NSObject



#pragma mark - 获取当前用户 UserModel
+(UserModel*)getCurrentUserModel;

#pragma mark - 获取 bmobobject 的model
+(void)queryWithObject:(BmobQuery*)queryObject model:(id)model result:(getObjectModelBlock)block;

#pragma mark - 设置单个 bmobobject 到 model
+(void)setModelWithObject:(BmobObject*)ob model:(id)model;


#pragma mark - 保存单个信息
+ (void)updateBmobWithKey:(NSString*)key value:(id)value  usermodel:(UserModel*)model result:(void(^)(BOOL success))result;

+(void)updateBmobWithKey:(NSString*)key value:(id)value  object:(id)object result:(successBlock)block;

#pragma mark -  查询用户
+(void)searchUserWithUsername:(NSString*)username searchResult:(void(^)(NSArray*array))resultBlock;

#pragma mark - 添加关注 
+ (void)addFollowWithFollowedUserModel:(UserModel*)model  result:(void(^)(BOOL success))result;

#pragma mark - 判断是否互相关注
+ (void)checkFollowEachOtherWithItemArray:(NSArray*)itemArray searchResult:(void(^)(NSArray*array))resultBlock;


#pragma mark -  获取好友列表  通过环信好友username 获取bmob 对应用户信息
+ (void)getBmobBuddyUsers:(void(^)(NSArray*))block;

#pragma mark - 批量获取聊天记录里面用户的nickName headImageURL
+ (void)getConversionsNickNameHeadeImageURL:(NSArray*)conversations results:(void(^)(NSArray*array))result;

#pragma mark - 获取群基本信息
+ (void)getGroupChatInfo:(NSArray*)groupConver results:(void(^)(NSArray*array))result;
                                                        
                                                        

#pragma mark - 通讯录匹配
+(void)tongxunluMatch:(NSArray*)contacts results:(void(^)(NSArray*array))result;




@end
