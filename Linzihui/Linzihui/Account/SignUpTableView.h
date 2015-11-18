//
//  SignUpTableView.h
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/15.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "BaseTableViewController.h"

@interface SignUpTableView : BaseTableViewController


@property (nonatomic,strong ) NSString *phone;

@property (weak, nonatomic) IBOutlet UITextField *codeTF;

@property (weak, nonatomic) IBOutlet UITextField *checkCodeTF;
@property (weak, nonatomic) IBOutlet UITextField *yaoqingmaTF;
- (IBAction)registAction:(id)sender;
- (IBAction)showPrivacy:(id)sender;

@end
