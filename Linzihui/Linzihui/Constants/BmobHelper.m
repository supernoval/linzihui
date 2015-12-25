//
//  BmobHelper.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/8.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "BmobHelper.h"
#import "MyConversation.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
@implementation BmobHelper

#pragma mark - 等级记录
+(void)saveLevelRecord
{
    
    
    //增加打开次数
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kHadLogin])
    {
        
  
    BmobQuery *query = [BmobQuery queryWithClassName:kDengJi];
    
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if (!error ) {
            
            if (array.count > 0) {
                
                BmobObject *ob = [array firstObject];
                
                [ob incrementKey:@"openTimes"];
                
                [ob updateInBackground];
                
            }
            else
            {
                
                BmobObject *ob = [BmobObject objectWithClassName:kDengJi];
                
                [ob setObject:[BmobUser getCurrentUser].username forKey:@"username"];
                
                [ob saveInBackground];
                
            }
            
            
        }
        
    }];
        
          }
    
    
}
+(void)getLevel:(void(^)(NSString*levelStr))result{
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kHadLogin]) {
        
        BmobQuery *query = [BmobQuery queryWithClassName:kDengJi];
        
        [query whereKey:@"username" equalTo:[BmobUser getCurrentUser].username];
        
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            
            if (!error && array.count > 0) {
                
                
                BmobObject *bo = [array firstObject];
                
                NSInteger times = [[bo objectForKey:@"openTimes"]integerValue];
                
                
                NSInteger level = times/90;
                
                NSString *str = nil;
                
                switch (level) {
                    case 0:
                    {
                        str =  @"幼儿园";
                    }
                        break;
                    case 1:
                    {
                        str = @"小学生";
                    }
                        break;
                    case 2:
                    {
                        str = @"中学生";
                    }
                        break;
                    case 3:
                    {
                        str = @"高中生";
                    }
                        break;
                    case 4:
                    {
                        str = @"大学生";
                    }
                        break;
                    case 5:
                    {
                        str = @"硕士";
                    }
                        break;
                    case 6:
                    {
                        str = @"博士";
                    }
                        break;
                    case 7:
                    {
                        str = @"教授";
                    }
                        break;
                        
                        
                        
                    default:
                    {
                           str = @"教授";
                    }
                        break;
                }
                
                
                
                if (result) {
                    
                    result(str);
                    
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

}

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
    
    NSMutableArray *muArray = [[NSMutableArray alloc]init];
    
    for (UserModel *oneModel in itemArray) {
        
        [muArray addObject:oneModel.objectId];
        
     
    }
    
       [getAllFollowMes whereKey:@"userObjectId" containedIn:muArray];
    
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
                    
                    //判断关注我的人里面有没有这个人的 username
                    if ([obId isEqualToString:model.username]) {
                        
                        
                        //再遍历 判断 我有没有关注这个人
                        for (int f = 0; f < temArray.count ; f ++) {
                            
                            BmobObject *temOb = [temArray objectAtIndex:f];
                            
                                
                                NSArray *followMes = [temOb objectForKey:@"followMes"];
                                
                                for (NSString *temID in followMes) {
                                    
                                    
                                    
                                    if ([temID isEqualToString:currentUser.username]) {
                                        
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
                [muArray addObject:currentUserModel.username];
                
            }
            else
            {
                [muArray addObject:currentUserModel.username];
                
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
                [MuArray addObject:model.username];
                
                
            }
            else
            {
                [MuArray addObject:model.username];
                
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
+ (void)getBmobBuddyUsers:(void(^)(NSArray*array))block{
    
    
     NSArray *buddyList = [[EaseMob sharedInstance].chatManager buddyList];
    
    BmobQuery  *query = [BmobQuery queryForUser];
    
    NSMutableArray *muArray = [[NSMutableArray alloc]init];
    
    for (EMBuddy *buddy in buddyList) {
        
        //环信的 username 和  bmob 一样，注册的时候设置的
        
        [muArray addObject:buddy.username];
        
       
        
    }
    
    [query whereKey:@"username" containedIn:muArray];
    
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
                        
                        myConModel.username = model.username;
                        myConModel.nickName = model.nickName;
                        myConModel.headImageURL = model.headImageURL;
                        myConModel.converstion = _myConver;
                        myConModel.messageType = 0;
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
            
            NSLog(@"get userinfo error:%@",error);
            
            if (result) {
                
                result(nil);
                
            }
        }
        
        
    }];
    
}

#pragma mark - 获取群组成员信息
+ (void)getGroupMembersInfo:(NSArray*)membersusername results:(void(^)(NSArray*arary))result
{
    BmobQuery *query = [BmobQuery queryForUser];
    
    if (membersusername.count == 0) {
        
        membersusername = @[];
    }
    [query whereKey:@"username" containedIn:membersusername];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
       
        NSMutableArray *muArray = [[NSMutableArray alloc]init];
        
        for (int i = 0;i < array.count; i++) {
            
            BmobObject *object = [array objectAtIndex:i];
            
            UserModel *model = [[UserModel alloc]initwithBmobObject:object];
            
            
            for (NSString*username in membersusername) {
                
                if ([username isEqualToString:model.username]) {
                    
                    MyConversation *myConModel = [[MyConversation alloc]init];
                    
                    myConModel.username = model.username;
                    myConModel.nickName = model.nickName;
                    myConModel.headImageURL = model.headImageURL;
                   
                    
                    [muArray addObject:myConModel];
                    
                    
                }
                
                
            }
            
        }
        
        if (result) {
            
            
            result(muArray);
            
        }
        
        
    }];
}
#pragma mark - 通过聊天信息获取群基本信息
+ (void)getGroupChatInfo:(NSArray*)groupConver results:(void(^)(NSArray*array))result
{
    BmobQuery *_query = [BmobQuery queryWithClassName:kChatGroupTableName];
    
    
    NSMutableArray *_groups = [[NSMutableArray alloc]init];
    
    for (EMConversation *con in groupConver) {
        
        [_groups addObject:con.chatter];
        
    }
    
    [_query whereKey:@"groupId" containedIn:_groups];
    
    
    [_query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
       
        if (!error && array.count > 0) {
            
            NSMutableArray *muArray = [[NSMutableArray alloc]init];
            
            for (BmobObject *ob in array) {
                
                NSString *groupId = [ob objectForKey:@"groupId"];
                
                for (EMConversation *_temCon in groupConver) {
                    
                    if ([groupId isEqualToString:_temCon.chatter]) {
                        
                        NSDictionary *dataDict = [ob valueForKey:kBmobDataDic];
                        
                        MyConversation *_myConver = [[MyConversation alloc]init];
                        
                        [_myConver setValuesForKeysWithDictionary:dataDict];
                        
                        _myConver.converstion = _temCon;
                        _myConver.messageType = 1;
                        
                        [muArray addObject:_myConver];
                        
                        
                        
                    }
                }
                
                
            }
            
            
            if (result) {
                
                result(muArray);
                
            }
        }
        else
        {
            
            NSLog(@"获取群信息失败：%@",error);
            
            if (result) {
                
                result(nil);
            }
        }
    }];
}
                                                        

#pragma mark - 获取群组列表 信息
+ (void)getGroupListInfo:(NSArray*)EMGroupList results:(void(^)(NSArray*array))result
{
   
    NSMutableArray *groupIds = [[NSMutableArray alloc]init];
    
    
    for (EMGroup *group in EMGroupList) {
        
        [groupIds addObject:group.groupId];
        
    }
    
    BmobQuery *query = [BmobQuery queryWithClassName:kChatGroupTableName];
    
    
    [query whereKey:@"groupId" containedIn:groupIds];
    
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
       
        if (!error && array) {
            
            NSMutableArray *resutls = [[NSMutableArray alloc]init];
            
            for (BmobObject *ob in array) {
                
                GroupChatModel *model = [[GroupChatModel alloc]init];
                
                NSDictionary *dataDic = [ob valueForKey:kBmobDataDic];
                
                [model setValuesForKeysWithDictionary:dataDic];
                
                
                [resutls addObject:model];
            }
            
            if (result) {
                
                result(resutls);
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

#pragma mark - 获取邻近群组
+(void)getNearGroupList:(void(^)(NSArray*array))result
{
    
    
    CGFloat latitude = [[NSUserDefaults standardUserDefaults ]floatForKey:kCurrentLatitude];
    
    CGFloat longitude = [[NSUserDefaults standardUserDefaults ]floatForKey:kCurrentLongitude];
    
    
    BmobGeoPoint *point = [[BmobGeoPoint alloc]init];
    
    point.latitude = latitude;
    
    point.longitude = longitude;
    
    
    
    BmobQuery *query = [[BmobQuery alloc]initWithClassName:kChatGroupTableName];
    
    [query whereKey:@"location" nearGeoPoint:point withinKilometers:3];
    
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        
        if (!error && array) {
            
            NSMutableArray *resutls = [[NSMutableArray alloc]init];
            
            for (BmobObject *ob in array) {
                
                GroupChatModel *model = [[GroupChatModel alloc]init];
                
                NSDictionary *dataDic = [ob valueForKey:kBmobDataDic];
                
                
                [model setValuesForKeysWithDictionary:dataDic];
                
                BmobGeoPoint *location  = [ob objectForKey:@"location"];
                
                model.location = location;
                
                
                [resutls addObject:model];
            }
            
            if (result) {
                
                result(resutls);
            }
        }
        else
        {
            
            NSLog(@"error:%@",error);
            
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


#pragma mark - 获取活动信息
+(void)getHuoDongMessageswithusername:(NSString*)username index:(NSInteger)index results:(void(^)(NSArray*array))result
{
    
    NSInteger limit = 10;
    
    BmobQuery *_query = [BmobQuery queryWithClassName:kHuoDongMessagesTableName];
    
    
    [_query includeKey:@"huodong"];
    
    _query.skip = limit *index;
    
    _query.limit = limit;
    
    
    [_query whereKey:@"username" equalTo:username];
    
    [_query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
       
        
        if (!error && array) {
            
            NSMutableArray *muArray = [[NSMutableArray alloc]init];
            
            
            
            for (BmobObject *ob in array) {
                
                
                NSDictionary *dataDict = [ob valueForKey:kBmobDataDic];
                
                
                MyConversation *_convert = [[MyConversation alloc]init];
                [_convert setValuesForKeysWithDictionary:dataDict];
                
                _convert.messageType = 2;
                
                
                [muArray addObject:_convert];
                
                
                
            }
            
            
            if (result) {
                
                result(muArray);
            }
        }
        else
        {
            NSLog(@"error:%@",error);
            
            result(nil);
            
        }
        
        
    }];
    
    
    
}

#pragma mark - 创建活动消息
+(void)createHuodongMessage:(BmobObject*)huodong message:(NSString*)message status:(NSInteger)status username:(NSString*)username title:(NSString*)title result:(void(^)(BOOL success))result
{
    BmobObject *ob = [BmobObject objectWithClassName:kHuoDongMessagesTableName];
    
    [ob setObject:huodong forKey:@"huodong"];
    
    [ob setObject:message forKey:@"message"];
    
    [ob setObject:@(status) forKey:@"status"];
    
    [ob setObject:username forKey:@"username"];
    
    [ob setObject:title forKey:@"title"];
    
    
    [ob saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
       
        if (isSuccessful) {
            
            if (result) {
                
                result(YES);
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


#pragma mark - 获取群信息
+(void)getGroupInfo:(NSString*)groupId result:(void(^)(BOOL sccess,GroupChatModel*model))result
{
    
    BmobQuery *query = [BmobQuery queryWithClassName:kChatGroupTableName];
    
    [query whereKey:@"groupId" equalTo:groupId];
    
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
       
        
        if (!error && array.count > 0) {
            
            BmobObject *ob = [array firstObject];
            
            GroupChatModel *_model = [[GroupChatModel alloc]init];
            
            NSDictionary *dataDic = [ob valueForKey:kBmobDataDic];
            
            [_model setValuesForKeysWithDictionary:dataDic];
            
            
            if (result) {
                
                result(YES,_model);
            }
            
        }
        else
        {
            if (result) {
                
                result(NO,nil);
                
            }
        }
        
    }];
}


#pragma mark - 生成群聊头像
+(void)getGroupHeadImageView:(EMGroup*)group imageView:(UIImageView *)imageview result:(void (^)(BOOL sccessu, UIImageView *headImageView))result
{
    
    NSArray *goupMembers = [group occupants];
    
   
    if (goupMembers.count > 9) {
        
        NSMutableArray *muarray = [[NSMutableArray alloc]init];
        
        for (int i = 0; i < goupMembers.count ; i++) {
            
            if (i < 9) {
                
                NSString *username = [goupMembers objectAtIndex:i];
                
                [muarray addObject:username];
            }
        }
        
        goupMembers = muarray;
        
    }
    
    [BmobHelper getGroupMembersInfo:goupMembers results:^(NSArray *arary) {
       
        if (arary) {
            
            
            if (imageview) {
                
          
                CGSize imageSize = imageview.frame.size;
                
                CGFloat temWith = imageSize.width /3;
                
                CGFloat temHeight = imageSize.height / 3;
                
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                   
                      UIGraphicsBeginImageContext(imageSize);
                    
                    for (int d = 0; d < arary.count; d++) {
                        
                          NSInteger line = d/3;
                        
                        MyConversation *con = [arary objectAtIndex:d];
                        NSData *imageData = nil;
                        
                        
                        if (con.headImageURL) {
                            
                            imageData= [[NSUserDefaults standardUserDefaults] objectForKey:con.headImageURL];
                            
                        }
                        
                        
                        
                        if (!imageData) {
                            
                            imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:con.headImageURL]];
                            
                            if (imageData) {
                                
                                [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:con.headImageURL];
                                
                                [[NSUserDefaults standardUserDefaults] synchronize];
                            }
                         
                            
                        }
                    
                        
                        
                        UIImage *image = [UIImage imageWithData:imageData];
                        
                        
                        [image drawInRect:CGRectMake(temWith*d + 2, line*temHeight, temWith, temHeight)];
                        
                        
                        
                    }
                    
                    
                    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
                    
                    UIGraphicsEndImageContext();
                    
                   dispatch_async(dispatch_get_main_queue(), ^{
                      
                       imageview.image = finalImage;
                       
                   });
                    
                    
                });
                
                
                
                
                
//                for (int i = 0; i < arary.count ; i ++) {
//                    
//                    NSInteger line = i/3;
//                    
//                    MyConversation *con = [arary objectAtIndex:i];
//                    
//                    UIImageView *temImageView = [[UIImageView alloc]initWithFrame:CGRectMake(temWith*i, line*temHeight, temWith, temHeight)];
//                    
//                    [temImageView sd_setImageWithURL:[NSURL URLWithString:con.headImageURL] placeholderImage:kDefaultHeadImage];
//                    
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                           [imageview addSubview:temImageView];
//                    });
//                 
//                    
//                }
                
            }
            
            
            
        }
    }];
   
    
}

@end
