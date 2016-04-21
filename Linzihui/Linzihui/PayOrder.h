//
//  PayOrder.h
//  YouKang
//
//  Created by Haikun Zhu on 15/6/18.
//  Copyright (c) 2015年 Ucan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"

#import "ConstantsHeaders.h"
#import "PayOrderInfoModel.h"
#import "DataSigner.h"
@interface PayOrder : NSObject



#pragma mark - 调用支付宝支付
+(void)loadALiPaySDK:(PayOrderInfoModel*)payinfo;

@end
