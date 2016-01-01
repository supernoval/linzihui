//
//  AddBeiZhuVC.h
//  Linzihui
//
//  Created by ZhuHaikun on 16/1/1.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "BaseViewController.h"

@interface AddBeiZhuVC : BaseViewController


@property (weak, nonatomic) IBOutlet UITextField *beizhuLabel;
@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *beizhuStr;

- (IBAction)save:(id)sender;

@end
