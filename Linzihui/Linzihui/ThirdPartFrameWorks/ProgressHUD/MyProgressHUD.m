//
//  MyProgressHUD.m
//  QianShouBang
//
//  Created by Haikun Zhu on 15/8/5.
//  Copyright (c) 2015年 zhuhaikun. All rights reserved.
//

#import "MyProgressHUD.h"
#import "ProgressHUD.h"

@implementation MyProgressHUD


+(void)showError:(NSString *)error
{
    [ProgressHUD showError:error];
    
}

+(void)showProgress
{
    [ProgressHUD show:nil];
    
}

+(void)dismiss
{
    [ProgressHUD dismiss];
    
    
}
@end
