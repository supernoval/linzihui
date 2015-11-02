//
//  MyProgressHUD.h
//  QianShouBang
//
//  Created by Haikun Zhu on 15/8/5.
//  Copyright (c) 2015年 zhuhaikun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyProgressHUD : NSObject


+(void)showError:(NSString*)error;

+(void)dismiss;

+(void)showProgress;

@end
