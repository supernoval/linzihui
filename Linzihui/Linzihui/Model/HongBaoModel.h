//
//  HongBaoModel.h
//  Linzihui
//
//  Created by ZhuHaikun on 16/4/21.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "JSONModel.h"
#import <BmobSDK/Bmob.h>
@interface HongBaoModel : JSONModel

@property (nonatomic,strong) NSString *objectId;

@property (nonatomic,strong) BmobObject*publisher;
@property (nonatomic,strong) NSArray *photos;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) BmobGeoPoint *location;
@property (nonatomic,strong) NSDate *validate;
@property (nonatomic,assign) CGFloat hongbaoNum;
@property (nonatomic,strong) NSDate *createdAt;
@property (nonatomic,strong) NSDate *updatedAt;
@property (nonatomic,strong) NSArray *comments;




@end
