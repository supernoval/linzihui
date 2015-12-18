//
//  HuoDongModel.h
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/30.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "JSONModel.h"
#import <BmobSDK/Bmob.h>
@interface HuoDongModel : JSONModel

@property (nonatomic,strong) NSString *objectId;
@property (nonatomic,strong ) NSString *title;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong ) NSString *realName ;
@property (nonatomic,strong)  BmobGeoPoint *location;
@property (nonatomic,strong) NSDate *endRegistTime;
@property (nonatomic,strong) NSString *needFamilyNum;
@property (nonatomic,strong ) NSArray *photoURL;
@property (nonatomic,strong)  BmobUser *starter;
@property (nonatomic,strong) NSString *TeDian;
@property (nonatomic,strong ) NSString *LiuCheng;
@property (nonatomic,strong) NSString *ZhuYiShiXiang;
@property (nonatomic,strong) NSArray *AttendUsers;
@property (nonatomic,strong) NSString *ageRequest;
@property (nonatomic,strong) NSString *photoNum;
@property (nonatomic,strong ) NSString *phoneNum;
@property (nonatomic,strong) NSString *updatedAt;
@property (nonatomic,strong) NSString *createdAt;
@property (nonatomic,strong ) NSString *feeNum;
@property (nonatomic,strong)  NSDate *startTime;
@property (nonatomic,strong ) NSDate *endTime;
@property (nonatomic)         NSInteger status;
@property (nonatomic,strong)  NSString *groupId;




@end
