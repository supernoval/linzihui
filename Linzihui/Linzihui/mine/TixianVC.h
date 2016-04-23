//
//  TixianVC.h
//  Linzihui
//
//  Created by ZhuHaikun on 16/4/24.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "BaseViewController.h"

@interface TixianVC : BaseViewController


@property (nonatomic,assign) CGFloat totalMoney;

@property (weak, nonatomic) IBOutlet UITextField *tixianNumTF;


@property (weak, nonatomic) IBOutlet UITextField *alipayAccount;


- (IBAction)tixianAciont:(id)sender;

@end
