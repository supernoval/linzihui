//
//  PayOrderInfoModel.h
//  YouKang
//
//  Created by Haikun Zhu on 15/7/14.
//  Copyright (c) 2015年 Ucan. All rights reserved.
//

#import "JSONModel.h"

@interface PayOrderInfoModel : JSONModel
@property (nonatomic, strong) NSString *producttype; //用于区别 购买或者充值  1购买   2充值
@property (nonatomic, strong) NSString *productName; //商品名称
@property (nonatomic, strong) NSString *productDescription; //商品详细
@property (nonatomic, strong) NSString *amount;  //金额
@property (nonatomic, strong) NSString *out_trade_no; //支付单号


@end
