//
//  ShangPinModel.h
//  Linzihui
//
//  Created by ZhuHaikun on 16/5/21.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "JSONModel.h"

@interface ShangPinModel : JSONModel

@property (nonatomic,strong) NSString *shangjiaObjectId;
@property (nonatomic,strong) NSString *photos;
@property (nonatomic,strong) NSString *des;
@property (nonatomic,assign) CGFloat price;
@property(nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSArray *photoArray;



@end
