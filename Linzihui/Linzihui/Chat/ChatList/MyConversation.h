//
//  MyConversation.h
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/12.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "EMConversation.h"
#import "JSONModel.h"
#import <BmobSDK/Bmob.h>
@interface MyConversation : JSONModel

-(id)init;

@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) EMConversation *converstion;
@property (nonatomic,strong) NSString *headImageURL;
@property (nonatomic,strong) NSString *nickName;

@property (nonatomic,strong )NSString *groupId;
@property (nonatomic,strong)  NSArray *members;
@property (nonatomic,strong)  NSString *subTitle;
@property (nonatomic,strong)  NSString *QRCode;
@property (nonatomic,strong ) NSString *owner_username;
@property (nonatomic,strong)  BmobGeoPoint *location;
@property (nonatomic,strong)  NSString *groupDes;
@property (nonatomic,strong)  NSDate *createdAt;
@property (nonatomic,strong ) NSDate *updatedAt;
@property (nonatomic,strong)  NSString *objectId;



@end
