//
//  UserModel.h
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/3.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "JSONModel.h"

@interface UserModel : JSONModel

@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong ) NSString *password;
@property (nonatomic,strong)  NSString *mobilePhoneNumber;

@end
