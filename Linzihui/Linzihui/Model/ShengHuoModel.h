//
//  ShengHuoModel.h
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/18.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "JSONModel.h"
#import <BmobSDK/Bmob.h>
@interface ShengHuoModel : JSONModel

@property (nonatomic,strong) NSString *text;
@property (nonatomic,strong ) NSArray *image_url;
@property (nonatomic,strong)  NSArray *comment;
@property (nonatomic,strong)  BmobUser *publisher;
@property (nonatomic,strong) NSString *objectId;
@property (nonatomic,strong) NSDate *createdAt;
@property (nonatomic,strong)  NSDate *updatedAt;
@property (nonatomic,strong) BmobGeoPoint *location;




@end
