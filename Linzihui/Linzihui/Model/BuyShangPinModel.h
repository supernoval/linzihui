//
//  BuyShangPinModel.h
//  Linzihui
//
//  Created by ZhuHaikun on 16/5/7.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "JSONModel.h"

@interface BuyShangPinModel : JSONModel

@property(nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *shangpinName;
@property (nonatomic,strong) NSString *shangpinPhoto;
@property (nonatomic,assign) CGFloat price;
@property (nonatomic,assign)  NSInteger status;
@property (nonatomic,strong) BmobObject*shangpin;
@property (nonatomic,strong) BmobObject *shangjia;
@property (nonatomic,strong) BmobObject *address;
@property (nonatomic,strong) BmobObject *buyer;



@end
