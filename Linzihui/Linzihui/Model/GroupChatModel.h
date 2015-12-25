//
//  GroupChatModel.h
//  Linzihui
//
//  Created by ZhuHaikun on 15/12/8.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "JSONModel.h"
#import <BmobSDK/Bmob.h>
#import "EaseMob.h"

@interface GroupChatModel : JSONModel


@property (nonatomic,strong ) NSString *objectId;
@property (nonatomic,strong ) NSString *groupId;
@property (nonatomic,strong)  NSArray  *members; // 保存字典 {@"username":@"",@"nickName":@"",@"headImageURL":@""}

@property (nonatomic,strong) NSString *groupImage;
@property (nonatomic,strong)  NSString *subTitle;
@property (nonatomic,strong )  NSString *groupDes;
@property (nonatomic,strong ) NSString *owner_username;
@property (nonatomic,strong)  BmobGeoPoint *location;
@property (nonatomic,strong) NSString *createdAt;
@property (nonatomic,strong ) NSString *updatedAt;

@property (nonatomic,strong) NSString *groupHeadImage;










@end
