//
//  UserModel.h
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/3.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "JSONModel.h"
#import "BaseBmobModel.h"


typedef NS_ENUM(NSInteger,CheckType)
{
    CheckTypeOnlyFollowMe, //对方关注我
    CheckTypeOnlyMyFollow,  //我关注对方
    CheckTypeFollowEachOther,  //互相关注
    CheckTypeFriend,   //好友
    CheckTypeNone,
    
};

@interface UserModel : BaseBmobModel

@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong ) NSString *password;
@property (nonatomic,strong)  NSString *mobilePhoneNumber;
@property (nonatomic,strong)  NSString *headImageURL;
@property (nonatomic,strong)  NSString *nickName;
@property (nonatomic,assign)  BOOL mobilePhoneNumberVerified;
@property (nonatomic,strong)  NSString *inviteCode;
@property (nonatomic,strong) NSArray *beiZhu;
@property (nonatomic,assign) NSInteger level;
@property (nonatomic,strong) NSArray *attendActivities;


@property (nonatomic,strong) NSString *beizhu;
@property (nonatomic)        NSInteger age;




@property (nonatomic,strong)   BmobGeoPoint *location;

//额外添加
@property (nonatomic,assign) CGFloat latitude;
@property (nonatomic,assign) CGFloat longitude;




@property (nonatomic,strong ) NSString *card;
@property (nonatomic,strong)  NSString *address;
@property (nonatomic,assign ) NSInteger sex;
@property (nonatomic,strong)  NSString *area; //地区
@property (nonatomic,strong)  NSString *xiaoqu;
@property (nonatomic,strong)  NSString *selfComment; //签名
@property (nonatomic,strong)  NSArray *myFollows; //我关注的 objectId
@property (nonatomic,strong ) NSArray *followMes;  // 关注我的人的 objectId   只有同时我关注的人也关注我才可以加好友


@property (nonatomic,assign) BOOL followEach; //额外添加 标识是否互相关注

@property (nonatomic,assign) CheckType followType;  //关注类型  对方关注自己   自己关注对方   双方互相关注

@property (nonatomic,assign) BOOL hadSelected;  //额外添加 是否选中  （群聊）

@property (nonatomic,assign) BOOL isIngroup;  //是否在群聊里面



//邻近二手添加
@property (nonatomic,strong) NSString *price; //价格 

@property (nonatomic,strong) NSString *message;

@property (nonatomic,assign) BOOL isAccepted;//是否接受该卖家；对于邻近互助：是否发给他红包

//邻近互助
@property (nonatomic,assign) BOOL hadAccepted; //是否已经接受了红包
@property (nonatomic,assign) CGFloat hongbaoNum; //领取的红包金额


@end
