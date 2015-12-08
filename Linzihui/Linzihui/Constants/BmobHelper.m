//
//  BmobHelper.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/8.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "BmobHelper.h"
#import "MyConversation.h"
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


#pragma mark - 设置单个 bmobobject 到 model
+(void)setModelWithObject:(BmobObject*)ob model:(id)model
{
    
    
    NSDictionary *dataDict = [ob valueForKey:@"bmobDataDic"];
    
    [model setValuesForKeysWithDictionary:dataDict];
    
    
    
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

#pragma mark - 判断是否互相关注
+ (void)checkFollowEachOtherWithItemArray:(NSArray*)itemArray searchResult:(void(^)(NSArray*))resultBlock
{
    BmobQuery *quary = [[BmobQuery alloc]initWithClassName:@"Follow"];
    
    BmobUser *currentUser = [BmobUser getCurrentUser];
    
    [quary whereKey:@"userObjectId" equalTo:currentUser.objectId];
    
    [quary findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
       
        if (!error && array.count > 0) {
            
            BmobObject *followOb = [array firstObject];
            
            NSArray *followsArray = [followOb objectForKey:@"myFollows"];
            
            if (followsArray.count > 0) {
                
                [self queryfollowMesWithItems:itemArray myFollows:followsArray searchResult:resultBlock];
                
            }
            else
            {
                if (resultBlock) {
                    
                    resultBlock(itemArray);
                }
            }
        }else
        {
            if (resultBlock) {
                
                resultBlock(itemArray);
            }
            
        }
        
    }];
    
    
}

+ (void)queryfollowMesWithItems:(NSArray*)itemArray myFollows:(NSArray*)followsArray searchResult:(void(^)(NSArray*))resultBlock
{
    
    BmobQuery *getAllFollowMes = [BmobQuery queryWithClassName:@"Follow"];
    
    BmobUser *currentUser = [BmobUser getCurrentUser];
    
    for (UserModel *oneModel in itemArray) {
        
        
        [getAllFollowMes whereKey:@"userObjectId" equalTo:oneModel.objectId];
    }
    
    
    
    [getAllFollowMes findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (!error && array.count > 0) {
            
            NSLog(@"followMes:%@",array);
            
            NSMutableArray *temArray = [[NSMutableArray alloc]initWithArray:array];
             BmobObject *targetOb = [array objectAtIndex:0];
            
            NSLog(@"targetOb.objectId:%@",targetOb.objectId);
            
          
            for (int i = 0;i < followsArray.count ; i++) {
                
                NSString *obId = [followsArray objectAtIndex:i];
                
                for (int d = 0; d < itemArray.count; d ++) {
                    
                    UserModel *model = [itemArray objectAtIndex:d];
                    
                    //判断关注我的人里面有没有这个人的 objectId
                    if ([obId isEqualToString:model.objectId]) {
                        
                        
                        //再遍历 判断 我有没有关注这个人
                        for (int f = 0; f < temArray.count ; f ++) {
                            
                            BmobObject *temOb = [temArray objectAtIndex:f];
                            
                                
                                NSArray *followMes = [temOb objectForKey:@"followMes"];
                                
                                for (NSString *temID in followMes) {
                                    
                                    
                                    
                                    if ([temID isEqualToString:currentUser.objectId]) {
                                        
                                        model.followEach = YES;
                                        
                                    }
                                
                            }
                        }
                        
                        
                    }
                }
            }
            
            
            
            if (resultBlock) {
                
                resultBlock(itemArray);
                
            }
            
        }
        else
        {
            if (resultBlock) {
                
                resultBlock(itemArray);
                
            }
        }
        
    }];
    
   
}

#pragma mark - 添加关注

//添加关注“我的”
+ (void)addFollowWithFollowedUserModel:(UserModel*)model result:(void (^)(BOOL))result
{
   
    UserModel *currentUserModel = [self getCurrentUserModel];
    BmobQuery *queryTargeUserFollow = [BmobQuery queryWithClassName:@"Follow"];
    [queryTargeUserFollow whereKey:@"userObjectId" equalTo:model.objectId];
    
    [queryTargeUserFollow findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
       
        if (!error ) {
            
            BmobObject *_followOb = [array firstObject];
            
            if (array.count == 0) {
                
                _followOb = [[BmobObject alloc]initWithClassName:@"Follow"];
                
            }
            
            NSMutableArray *muArray = [[NSMutableArray alloc]init];
            
            NSArray *followMes  = [_followOb objectForKey:@"followMes"];
            
            
            if (followMes) {
                
                [muArray addObjectsFromArray:followMes];
                [muArray addObject:currentUserModel.objectId];
                
            }
            else
            {
                [muArray addObject:currentUserModel.objectId];
                
            }
            
            [_followOb setObject:muArray forKey:@"followMes"];
            [_followOb setObject:model.objectId forKey:@"userObjectId"];
            
            
            if (array.count > 0) {
                
                [_followOb updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    
                    if (isSuccessful) {
                        
                        [self addMyFollowsWithModel:model result:result];
                        
                        
                    }
                }];
            }
            else
            {
                [_followOb saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                   
                    if (isSuccessful) {
                        
                        [self addMyFollowsWithModel:model result:result];
                        
                        
                    }
                }];
            }
        
        }
        else
        {
            result(NO);
            
        }
    }];
    
  

    
    

}

//添加我的关注
+ (void)addMyFollowsWithModel:(UserModel*)model result:(void (^)(BOOL))result
{
     UserModel *currentUserModel = [self getCurrentUserModel];
    
    //currentUserFollows
    BmobQuery *queryCurrentUserFoL = [BmobQuery queryWithClassName:@"Follow"];
    
    [queryCurrentUserFoL whereKey:@"userObjectId" equalTo:currentUserModel.objectId];
    
    [queryCurrentUserFoL findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if (!error) {
            
            BmobObject *_currentObject = [array firstObject];
            
            if (array.count == 0) {
                
                _currentObject = [[BmobObject alloc]initWithClassName:@"Follow"];
                
            }
            
            NSArray *myFollows = [_currentObject objectForKey:@"myFollows"];
            
            NSMutableArray *MuArray = [[NSMutableArray alloc]init];
            
            if (myFollows) {
                
                [MuArray addObjectsFromArray:myFollows];
                [MuArray addObject:model.objectId];
                
                
            }
            else
            {
                [MuArray addObject:model.objectId];
                
            }
            
            [_currentObject setObject:MuArray forKey:@"myFollows"];
            [_currentObject setObject:currentUserModel.objectId forKey:@"userObjectId"];
            
            if (array.count > 0) {
                
                [_currentObject updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    
                    if (isSuccessful) {
                        
                        if (result) {
                            
                            result(YES);
                            
                        }
                    }
                }];
            }
            else
            {
                [_currentObject saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    
                    if (isSuccessful) {
                        
                        if (result) {
                            
                            result(YES);
                            
                        }
                    }
                    
                }];
                
            }
          
            
        }
       else
       {
           if (result) {
               
               result(NO);
               
           }
       }
        
    }];
}



#pragma mark -  通过环信好友username 获取bmob 对应用户信息
+ (void)getBmobBuddyUsers:(void(^)(NSArray*))block{
    
    
     NSArray *buddyList = [[EaseMob sharedInstance].chatManager buddyList];
    
    BmobQuery  *query = [BmobQuery queryForUser];
    
    for (EMBuddy *buddy in buddyList) {
        
        //环信的 username 和  bmob 一样，注册的时候设置的
        [query whereKey:@"username" equalTo:buddy.username ];
        
       
        
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
       
        if (!error && array.count > 0) {
         
            NSMutableArray *muArray = [[NSMutableArray alloc]init];
            
            for (int i = 0;i < array.count; i++) {
                
                BmobObject *object = [array objectAtIndex:i];
                
                UserModel *model = [[UserModel alloc]initwithBmobObject:object];
                
                [muArray addObject:model];
                
                
            }
            
            if (block) {
                
                block(muArray);
                
            }
            
        }
        else
        {
            NSLog(@"error:%@",error);
            
            block(nil);
            
        }
        
    }];
    
    
}

#pragma mark - 批量获取聊天记录里面用户的nickName headImageURL
+ (void)getConversionsNickNameHeadeImageURL:(NSArray*)conversations results:(void(^)(NSArray*array))result
{
    
    BmobQuery *query = [BmobQuery queryForUser];
    
    
    NSMutableArray *_muArray = [[NSMutableArray alloc]init];
    
    
    for (EMConversation *_conver in conversations) {
        
        
        [_muArray addObject:_conver.chatter];
        
      
        
    }
    
    
    [query whereKey:@"username" containedIn:_muArray];
    

    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if (!error && array.count > 0) {
            
            NSMutableArray *muArray = [[NSMutableArray alloc]init];
            
            for (int i = 0;i < array.count; i++) {
                
                BmobObject *object = [array objectAtIndex:i];
                
                UserModel *model = [[UserModel alloc]initwithBmobObject:object];
                
                
                for (EMConversation*_myConver in conversations) {
                    
                    if ([_myConver.chatter isEqualToString:model.username]) {
                        
                        MyConversation *myConModel = [[MyConversation alloc]init];
                        
                        myConModel.nickName = model.nickName;
                        myConModel.headImageURL = model.headImageURL;
                        myConModel.converstion = _myConver;
                        
                        [muArray addObject:myConModel];
                        
                        
                    }
                    
                    
                }
                
            }
            
            if (result) {
                
                
                result(muArray);
                
            }
        
            
        }
        else
        {
            if (result) {
                
                result(nil);
                
            }
        }
        
        
    }];
    
}


#pragma mark - 通讯录匹配
+(void)tongxunluMatch:(NSArray*)contacts results:(void(^)(NSArray*array))result
{

    
    NSMutableArray *muArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < contacts.count; i ++) {
        
        NSDictionary *oneDict = [contacts objectAtIndex:i];
        
        NSString *phoneNum = [oneDict objectForKey:@"phone"];
        
        [muArray addObject:phoneNum];
        
      
        
    }
 
    
    
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
    
    NSInteger per = 10;
    
    NSInteger times = muArray.count/per +1;
    
   __block  NSMutableArray *searchRults = [[NSMutableArray alloc]init];
    
    __block NSInteger searchNum = 0;
    
    for (int i = 0; i < times; i++) {
        
        NSMutableArray *_perArray = [[NSMutableArray alloc]init];
        
        for (int d = 0; d < muArray.count;d ++) {
            
            NSString *temPhone = [muArray objectAtIndex:d];
            
            if (d <= i*per && d > (i-1)*per) {
                
                [_perArray addObject:temPhone];
                
            }
           
            
            
        }
        
      [self quequeSearch:_perArray queue:queue resultBlock:^(NSArray *array) {
         
          searchNum ++;
          
          if (array) {
              
              
              [searchRults addObjectsFromArray:array];
              
              
          }
          
          
          if (searchNum == times && i == times -1) {
              
              
              NSMutableArray *allcontantsArray = [[NSMutableArray alloc]init];
              
              for (int i = 0; i < contacts.count; i ++) {
                  
                  NSDictionary *oneDict = [contacts objectAtIndex:i];
                  
                  NSString *phoneNum = [oneDict objectForKey:@"phone"];
                  
                  ContactModel *_contactModel = [[ContactModel alloc]init];
                  
                  _contactModel.phoneNum = phoneNum;
                  _contactModel.nickName = [oneDict objectForKey:@"name"];
                  _contactModel.username = phoneNum;
                  
                  
                  for (UserModel *oneModel in searchRults) {
                      
                      //判断是否注册过
                      
                      if ([oneModel.username isEqualToString:phoneNum]) {
                          
                          _contactModel.hadRegist = YES;
                          _contactModel.headImageURL = oneModel.headImageURL;
                          _contactModel.nickName = oneModel.nickName;
                          
                          if ([EMHelper isBuddyWithUsername:_contactModel.username]) {
                              
                              _contactModel.isBuddy = YES;
                              
                          }
                          
                          
                      }
                  }
                  
                  //如果是自己的号码就不加
                  UserModel *currentUserModel = [BmobHelper getCurrentUserModel];
                  
                  if (![currentUserModel.username isEqualToString:_contactModel.username]) {
                      
                       [allcontantsArray addObject:_contactModel];
                  }
                 
                  
                  
               
                }
              
              
              if (result) {
                  
                  result(allcontantsArray);
                  
              }
              
           }
          
      }];
        
    }
    
    

    
    
}

+(void)quequeSearch:(NSArray*)consitions queue:(dispatch_queue_t)queue resultBlock:(void(^)(NSArray*array))block
{
    
    dispatch_async(queue, ^{
        
  
    
    BmobQuery *query = [BmobQuery queryForUser];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if (!error && array.count > 0)
        {
            
            
            
            NSMutableArray *temModelArray = [[NSMutableArray alloc]init];
            
            for (BmobObject *oneOB in array) {
                
                UserModel *model = [[UserModel alloc]initwithBmobObject:oneOB];
                
                [temModelArray addObject:model];
                
                
            }
            
            
            if (block) {
                block(temModelArray);
                
            }

            
        }
        else
        {
            
            
            if (block) {
                block(nil);
                
            }
            
            
        }
        
    }];
    
        
    });
    

}
@end
