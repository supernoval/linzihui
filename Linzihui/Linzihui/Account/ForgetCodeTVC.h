//
//  ForgetCodeTVC.h
//  QianShouBang
//
//  Created by Haikun Zhu on 15/8/5.
//  Copyright (c) 2015年 zhuhaikun. All rights reserved.
//

#import "BaseTableViewController.h"

@interface ForgetCodeTVC : BaseTableViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *sendCodeButton;
- (IBAction)sendCodeAction:(id)sender;
- (IBAction)summitAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *summitButton;

@end
