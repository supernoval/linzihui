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



typedef NS_ENUM(NSInteger,MessageStatus)
{
    MessageStatusPublish = 0,  //发布
    MessageStatusAttend ,      // 参加
    MessageStatusStart,        //活动开始
    MessageStatusArrived,      //活动签到
    MessageStatusEnd,         //活动结束
    MessageStatusInvite,      //邀请
    
};




typedef void (^successBlock)(BOOL isSuccess);
typedef void (^getObjectModelBlock)(BOOL success,id object);

@interface BmobHelper : NSObject


#pragma mark - 等级记录
+(void)saveLevelRecord;
+(void)getLevel:(void(^)(NSString*levelStr))result;
//注册时给别人添加等级
+(void)addLevel:(NSString*)invitecode;


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

#pragma mark - 取消关注
+ (void)cancelFollowWithUserModel:(UserModel*)model username:(NSString*)toDeleteusername result:(void(^)(BOOL success))result;


#pragma mark - 判断是否互相关注
+ (void)checkFollowEachOtherWithItemArray:(NSArray*)itemArray searchResult:(void(^)(NSArray*array))resultBlock;

#pragma mark - 判断关注类型
+ (void)checkFollowTypeWithUserModel:(UserModel*)model result:(void(^)(UserModel*finalModel))resultBlock;




#pragma mark -  获取好友列表  通过环信好友username 获取bmob 对应用户信息
+ (void)getBmobBuddyUsers:(void(^)(NSArray*array))block;

#pragma mark - 批量获取聊天记录里面用户的nickName headImageURL
+ (void)getConversionsNickNameHeadeImageURL:(NSArray*)conversations results:(void(^)(NSArray*array))result;

#pragma mark - 获取群组成员信息
+ (void)getGroupMembersInfo:(NSArray*)membersusername results:(void(^)(NSArray*arary))result;

#pragma mark - 通过聊天信息获取群基本信息
+ (void)getGroupChatInfo:(NSArray*)groupConver results:(void(^)(NSArray*array))result;

#pragma mark - 获取群组列表 信息
+ (void)getGroupListInfo:(NSArray*)EMGroupList results:(void(^)(NSArray*array))result;

#pragma mark - 获取邻近群组
+(void)getNearGroupList:(void(^)(NSArray*array))result;

#pragma mark - 获取群信息
+(void)getGroupInfo:(NSString*)groupId result:(void(^)(BOOL sccess,GroupChatModel*model))result;


                                                        

#pragma mark - 通讯录匹配
+(void)tongxunluMatch:(NSArray*)contacts results:(void(^)(NSArray*array))result;


#pragma mark - 获取活动信息
+(void)getHuoDongMessageswithusername:(NSString*)username index:(NSInteger)index results:(void(^)(NSArray*array))result;


#pragma mark - 创建活动消息
+(void)createHuodongMessage:(BmobObject*)huodong message:(NSString*)message status:(NSInteger)status username:(NSString*)username title:(NSString*)title result:(void(^)(BOOL success))result;

#pragma mark - 生成群聊头像
+(void)getGroupHeadImageView:(EMGroup*)group imageView:(UIImageView*)imageview result:(void(^)(BOOL success,UIImageView *headImageView))result;

#pragma mark - 获取备注
+(NSString*)getBeizhu:(NSString*)username;





@end
