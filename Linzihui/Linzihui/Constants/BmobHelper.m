//
//  BmobHelper.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/8.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "BmobHelper.h"

@implementation BmobHelper

#pragma mark - 获取当前用户 UserModel
+(UserModel*)getCurrentUserModel
{
    
    BmobUser *user = [BmobUser getCurrentUser];
    
    UserModel *model = [[UserModel alloc]initwithBmobObject:user];
    
    return model;
    
    
}

#pragma mark - 获取 bmobobject 的model
+(void)queryWithObject:(BmobQuery*)queryObject model:(id)model result:(getObjectModelBlock)block
{
    [queryObject findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
       
        if (!error) {
            
            if (array.count > 0) {
                
                BmobObject *object = [array firstObject];
                
                NSDictionary *dataDict = [object valueForKey:@"bmobDataDic"];
                
                if (dataDict) {
                    
                    [model setValuesForKeysWithDictionary:dataDict];
                    
                    if (block) {
                        
                       block(YES,model);
                    }
                    
                    
                }
                else
                {
                    if (block) {
                        
                        block(NO,model);
                    }
                }
               
                
                
            }
        }
    }];
}

#pragma mark - 保存单个信息
+ (void)updateBmobWithKey:(NSString*)key value:(id)value  usermodel:(UserModel*)model result:(void(^)(BOOL success))result
{
    BmobQuery *query = [BmobQuery queryWithClassName:@"_User"];
    
    [query whereKey:@"objectId" equalTo:model.objectId];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
       
        NSLog(@"查找被关注者");
        
        if (!error && array.count > 0) {
            
             NSLog(@"查找被关注者++");
            
            BmobObject *user =[array firstObject];
            
            [self updateBmobWithKey:key value:value object:user result:^(BOOL isSuccess) {
               
                if (result) {
                    
                    result(isSuccess);
                    
                }
                
            }];
        }
        
        
    }];
}
+(void)updateBmobWithKey:(NSString*)key value:(id)value  object:(id)object result:(successBlock)block
{
    


    [object setObject:value forKey:key];
    
    [object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        
         NSLog(@"被关注者更新");
        
        if (block) {
             NSLog(@"被关注者更新++");
             block(isSuccessful);
            
        }
        if (error) {
            NSLog(@"%s,%@",__func__,error);
            
        }
        
            
        
        
    }];
}

#pragma mark -  查询用户
+(void)searchUserWithUsername:(NSString*)username searchResult:(void(^)(NSArray*))resultBlock
{
    
    BmobQuery *_queryUser = [BmobQuery queryForUser];
    
    [_queryUser whereKey:@"username" equalTo:username];
    
    [_queryUser findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
       
        if (!error && array.count > 0) {
            
            NSMutableArray *muArray = [[NSMutableArray alloc]init];
            
            for (BmobObject *object in array) {
                
                
                UserModel *usermodel = [[UserModel alloc]initwithBmobObject:object];
                
                [muArray addObject:usermodel];
                
            }
          
            
            
            if (resultBlock) {
                
                
                resultBlock(muArray);
                
                
            }
        }
        
    }];
}

#pragma mark - 添加关注
+ (void)addFollowWithFollowedUserModel:(UserModel*)model result:(void (^)(BOOL))result
{
    UserModel *currentUserModel = [self getCurrentUserModel];
    
  __block  NSInteger saveNum = 0;
    
    if (!currentUserModel.myFollows) {
        
        currentUserModel.myFollows = [NSArray arrayWithObject:model.objectId];
        
        
    }
    else
    {
        NSMutableArray *muarray = [[NSMutableArray alloc]initWithArray:currentUserModel.myFollows];
        
        [muarray addObject:model.objectId];
        
        currentUserModel.myFollows = muarray;
        
    }
    
//    [self updateBmobWithKey:@"myFollows" value:currentUserModel.myFollows object:[BmobUser getCurrentUser] result:^(BOOL isSuccess) {
//       
//         saveNum ++;
//        
//        if (isSuccess) {
//            
//        
//            if (saveNum == 2) {
//                
//                
//                if (result) {
//                    
//                    result(YES);
//                    
//                }
//            }
//            else
//            {
//                if (saveNum == 2) {
//                    
//                    
//                    if (result) {
//                        
//                        result(NO);
//                        
//                    }
//                }
//            }
//            
//        }
//    }];
    
    
    if (!model.followMes) {
        
        model.followMes = [NSArray arrayWithObject:currentUserModel.objectId];
        
        
        
        
    }
    else
    {
        NSMutableArray *muArray = [[NSMutableArray alloc]initWithArray:model.followMes];
        
        [muArray addObject:currentUserModel.objectId];
        
        
        model.followMes = muArray;
        
    }
    
    BmobObject *followed = [BmobObject objectWithoutDatatWithClassName:@"_User" objectId:model.objectId];
    
    [self updateBmobWithKey:@"followMes" value:currentUserModel.myFollows object:[BmobUser getCurrentUser] result:^(BOOL isSuccess) {
        
        if (isSuccess) {
            
            
            
            if (saveNum == 2) {
                
                
                if (result) {
                    
                    result(YES);
                    
                }
            }
        }
        else
        {
            if (saveNum == 2) {
                
                
                if (result) {
                    
                    result(NO);
                    
                }
            }
        }
        
    }];
    
    
//    [self updateBmobWithKey:@"followMes" value:model.followMes usermodel:model result:^(BOOL isSuccess) {
//       
//            saveNum ++;
//        
//        if (isSuccess) {
//            
//        
//            
//            if (saveNum == 2) {
//                
//                
//                if (result) {
//                    
//                    result(YES);
//                    
//                }
//            }
//        }
//        else
//        {
//            if (saveNum == 2) {
//                
//                
//                if (result) {
//                    
//                    result(NO);
//                    
//                }
//            }
//        }
//        
//    }];
}


@end
