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

@property (nonatomic,strong ) NSString *card;
@property (nonatomic,strong)  NSString *address;
@property (nonatomic,assign ) NSInteger sex;
@property (nonatomic,strong)  NSString *area;
@property (nonatomic,strong)  NSString *selfComment;



@end
