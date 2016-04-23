//
//  TixianVC.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/4/24.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "TixianVC.h"

@interface TixianVC ()

@end

@implementation TixianVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"提现";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}


- (IBAction)tixianAciont:(id)sender {
    
    CGFloat tixianNum = [_tixianNumTF.text floatValue];
    
    NSString *alipayAccount = _alipayAccount.text;
    
    if (tixianNum == 0) {
        
        [CommonMethods showDefaultErrorString:@"请输入大于0的金额"];
        
        return;
        
    }
    
    if (alipayAccount.length == 0) {
        
        [CommonMethods showDefaultErrorString:@"请输入支付宝账号"];
        
        return;
        
        
    }
    
    if (_totalMoney < tixianNum) {
        
        [CommonMethods showDefaultErrorString:[NSString stringWithFormat: @"提现金额大于您的账户余额,账户余额为:%.2f",_totalMoney]];
        
        return;
        
    }
    
    [BmobHelper saveAccountDetail:[BmobUser getCurrentUser].username num:tixianNum isincome:NO beizhu:@"提现" isDraw:YES alipayAccount:alipayAccount];
    
    
    
}
@end
