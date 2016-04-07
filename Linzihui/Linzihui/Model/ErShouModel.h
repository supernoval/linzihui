//
//  ErShouModel.h
//  Linzihui
//
//  Created by ZhuHaikun on 16/3/29.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "JSONModel.h"
#import <BmobSDK/Bmob.h>

@interface ErShouModel : JSONModel

@property (nonatomic,strong) NSString *objectId;
@property (nonatomic,strong) BmobObject *publisher;
@property (nonatomic,strong) NSString *des;
@property (nonatomic,strong) NSArray *photos;
@property (nonatomic,strong) NSArray *comments;
@property (nonatomic,strong) BmobGeoPoint *location;
@property (nonatomic,strong) NSArray *zan;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *price;
@property (nonatomic,strong) NSArray *buyers;


@property (nonatomic,strong) NSDate *updatedAt;
@property (nonatomic,strong) NSDate *createdAt;




@end
