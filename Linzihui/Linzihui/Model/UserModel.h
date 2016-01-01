//
//  UserModel.h
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/3.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "JSONModel.h"
#import "BaseBmobModel.h"

@interface UserModel : BaseBmobModel

@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong ) NSString *password;
@property (nonatomic,strong)  NSString *mobilePhoneNumber;
@property (nonatomic,strong)  NSString *headImageURL;
@property (nonatomic,strong)  NSString *nickName;
@property (nonatomic,assign)  BOOL mobilePhoneNumberVerified;
@property (nonatomic,strong)  NSString *inviteCode;
@property (nonatomic,strong) NSArray *beiZhu;

@property (nonatomic,strong) NSString *beizhu;




@property (nonatomic,strong)   BmobGeoPoint *location;



@property (nonatomic,strong ) NSString *card;
@property (nonatomic,strong)  NSString *address;
@property (nonatomic,assign ) NSInteger sex;
@property (nonatomic,strong)  NSString *area; //地区
@property (nonatomic,strong)  NSString *selfComment; //签名
@property (nonatomic,strong)  NSArray *myFollows; //我关注的 objectId
@property (nonatomic,strong ) NSArray *followMes;  // 关注我的人的 objectId   只有同时我关注的人也关注我才可以加好友


@property (nonatomic,assign) BOOL followEach; //额外添加 标识是否互相关注


@property (nonatomic,assign) BOOL hadSelected;  //额外添加 是否选中  （群聊）

@property (nonatomic,assign) BOOL isIngroup;  //是否在群聊里面 



@end
