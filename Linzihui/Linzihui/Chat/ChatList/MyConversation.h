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
@property (nonatomic)  NSString *beizhu;
@property (nonatomic,assign) NSInteger myTimeStamp;



//群消息
@property (nonatomic,strong) BmobObject *owner;
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
@property (nonatomic,strong) NSString *groupHeadImage;

@property (nonatomic,assign) NSInteger messageType; // 0 单聊  1群聊   2活动消息 3申请入群信息


@property (nonatomic,strong) NSString *message;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) BmobObject *huodong;
@property (nonatomic,assign) NSInteger status;

//拒绝加群理由
@property (nonatomic,weak)  NSString *reason;





@end
