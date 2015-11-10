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

typedef void (^successBlock)(BOOL isSuccess);
typedef void (^getObjectModelBlock)(BOOL success,id object);

@interface BmobHelper : NSObject


#pragma mark - 获取当前用户 UserModel
+(UserModel*)getCurrentUserModel;

#pragma mark - 获取 bmobobject 的model
+(void)queryWithObject:(BmobQuery*)queryObject model:(id)model result:(getObjectModelBlock)block;



#pragma mark - 保存单个信息
+ (void)updateBmobWithKey:(NSString*)key value:(id)value  usermodel:(UserModel*)model result:(void(^)(BOOL))result;

+(void)updateBmobWithKey:(NSString*)key value:(id)value  object:(id)object result:(successBlock)block;

#pragma mark -  查询用户
+(void)searchUserWithUsername:(NSString*)username searchResult:(void(^)(NSArray*))resultBlock;

#pragma mark - 添加关注 
+ (void)addFollowWithFollowedUserModel:(UserModel*)model  result:(void(^)(BOOL))result;

#pragma mark - 判断是否互相关注
+ (void)checkFollowEachOtherWithItemArray:(NSArray*)itemArray searchResult:(void(^)(NSArray*))resultBlock;





@end
