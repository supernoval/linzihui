//
//  BmobHelper.h
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/8.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>
#import "BaseBmobModel.h"

typedef void (^successBlock)(BOOL isSuccess);
typedef void (^getObjectModelBlock)(BOOL success,id object);

@interface BmobHelper : NSObject


#pragma mark - 获取 bmobobject 的model
+(void)queryWithObject:(BmobQuery*)queryObject model:(id)model result:(getObjectModelBlock)block;



#pragma mark - 保存单个信息
+(void)updateBmobWithKey:(NSString*)key value:(id)value  object:(BmobObject*)object result:(successBlock)block;




@end
