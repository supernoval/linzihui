//
//  PayOrder.m
//  YouKang
//
//  Created by Haikun Zhu on 15/6/18.
//  Copyright (c) 2015年 Ucan. All rights reserved.
//

#import "PayOrder.h"

@implementation PayOrder


#pragma mark -  微信支付

//+ (void)sendWXPay:(PayOrderInfoModel*)payInfo
//{
//    //{{{
//    //本实例只是演示签名过程， 请将该过程在商户服务器上实现
//    
//    //创建支付签名对象
//    payRequsestHandler *req = [[payRequsestHandler alloc]init];
//    //初始化支付签名对象
//    [req init:kWXAppID mch_id:MCH_ID];
//    //设置密钥
//    [req setKey:PARTNER_ID];
//    
//    //}}}
//    
//    //获取到实际调起微信支付的参数后，在app端调起支付
//    NSMutableDictionary *dict = [req sendPay_demoWithOrderDict:payInfo];
//    
//    if(dict == nil){
//        //错误提示 
//        NSString *debug = [req getDebugifo];
//        
//        
//        
//        NSLog(@"%@\n\n",debug);
//    }else{
//        NSLog(@"%@\n\n",[req getDebugifo]);
//        //[self alert:@"确认" msg:@"下单成功，点击OK后调起支付！"];
//        
//        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
//        
//        //调起微信支付
//        PayReq* req             = [[PayReq alloc] init];
//        req.openID              = [dict objectForKey:@"appid"];
//        req.partnerId           = [dict objectForKey:@"partnerid"];
//        req.prepayId            = [dict objectForKey:@"prepayid"];
//        req.nonceStr            = [dict objectForKey:@"noncestr"];
//        req.timeStamp           = stamp.intValue;
//        req.package             = [dict objectForKey:@"package"];
//        req.sign                = [dict objectForKey:@"sign"];
//        
//        [WXApi sendReq:req];
//    }
//}
//

#pragma mark - 调用支付宝支付
+(void)loadALiPaySDK:(PayOrderInfoModel*)payinfo
{
    NSString *partner = kAlipayParnerID;
    NSString *seller = kAliPaySellerID;
    NSString *privateKey = kAlipayPriviteKey;
    

    NSString *notifyURL = kAlipayNotifyURL;
   

    
    
 
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    
    /*
     *生成订单信息及签名
     */
    
//    NSInteger ran = arc4random()%10000;
//    NSString *tradeNO = [NSString stringWithFormat:@"07987456%ld",(long)ran];
    
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = [NSString stringWithFormat:@"%@",payinfo.out_trade_no]; //订单ID（由商家自行制定）
    order.productName =payinfo.productName; //商品标题
    order.productDescription = payinfo.productDescription; //商品描述
    order.amount =[NSString stringWithFormat:@"%@",payinfo.amount]; //商品价格
    
    order.notifyURL =  notifyURL; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
  
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = kAliPayURLSchemes;
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            NSInteger resultStatus = [[resultDic objectForKey:@"resultStatus"]integerValue];
            if (resultStatus == 9000) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kPaySucessNotification object:nil];
            }
            else
            {
                NSString *memo = [resultDic objectForKey:@"memo"];
                
                if (memo.length == 0)
                {
                    
                    memo = @"付款失败";
                    
                }
                
                [[[UIAlertView alloc]initWithTitle:nil message:memo delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show ];
                
            }
        }];
        
        
    }
    
    NSLog(@"orderString:%@",orderString);
    
}

@end
