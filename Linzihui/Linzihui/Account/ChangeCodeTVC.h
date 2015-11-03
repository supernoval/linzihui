//
//  ChangeCodeTVC.h
//  QianShouBang
//
//  Created by Haikun Zhu on 15/8/5.
//  Copyright (c) 2015年 zhuhaikun. All rights reserved.
//

#import "BaseTableViewController.h"

@interface ChangeCodeTVC : BaseTableViewController


@property (nonatomic) NSString *phoneNum;


@property (weak, nonatomic) IBOutlet UITextField *newpwdTF;
@property (weak, nonatomic) IBOutlet UITextField *againpwdTF;
- (IBAction)changeCodeAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *changeCodeButton;

@end
