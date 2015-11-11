//
//  ContactModel.h
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/12.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "JSONModel.h"

@interface ContactModel : JSONModel

@property (nonatomic,strong ) NSString *username;
@property (nonatomic,strong)  NSString *nickName;
@property (nonatomic,strong)  NSString *phoneNum;
@property (nonatomic,strong)  NSString *headImageURL;
@property (nonatomic,assign)  BOOL hadRegist;
@property (nonatomic,strong)  NSString *weichatName;
@property (nonatomic,strong)  NSString *qqName;
@property (nonatomic,assign) BOOL isBuddy; //是否好友

@end
