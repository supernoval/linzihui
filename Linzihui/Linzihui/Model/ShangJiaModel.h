//
//  ShangJiaModel.h
//  Linzihui
//
//  Created by ZhuHaikun on 16/4/26.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "JSONModel.h"

@interface ShangJiaModel : JSONModel

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *photo;
@property (nonatomic,strong ) NSString *countyAddress;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *coverage;
@property (nonatomic,strong ) NSArray *IdImages;
@property (nonatomic,strong)  BmobGeoPoint *location;
@property (nonatomic,strong) NSString *username;

@end
