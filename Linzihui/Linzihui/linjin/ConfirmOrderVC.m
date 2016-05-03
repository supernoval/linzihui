//
//  ConfirmOrderVC.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/5/4.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "ConfirmOrderVC.h"

@interface ConfirmOrderVC ()

@end

@implementation ConfirmOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认订单";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self showData];
    
    
}

-(void)showData
{
    _nameLabel.text = [_shangpinDict objectForKey:@"des"];
    
    _priceLabel.text = [NSString stringWithFormat:@"%.2f元",[[_shangpinDict objectForKey:@"price"]floatValue]];
    
    [_photoImageView sd_setImageWithURL:[NSURL URLWithString:[_shangpinDict objectForKey:@"photos"]] placeholderImage:kDefaultHeadImage];
    
    
    _contactNameLabel.text = [NSString stringWithFormat:@"姓名:%@",[_addressDict objectForKey:@"name"]];
    
    _contactPhoneLabel.text = [NSString stringWithFormat:@"联系电话:%@",[_addressDict objectForKey:@"phone"]];
    
    _contactAddressLabel.text = [NSString stringWithFormat:@"详细地址:%@",[_addressDict objectForKey:@"address"]];
    
    
    
}



- (IBAction)ok:(id)sender
{
    
}


@end
