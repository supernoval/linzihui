//
//  BuyAddressVC.h
//  Linzihui
//
//  Created by ZhuHaikun on 16/5/4.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "BaseViewController.h"
#import "ShangJiaModel.h"
#import "ConfirmOrderVC.h"

@interface BuyAddressVC : BaseViewController


@property (nonatomic,strong) NSDictionary *shangpinDict;
@property (nonatomic,strong ) ShangJiaModel *shangjiaModel;

@property (weak, nonatomic) IBOutlet UITextField *contactNameLabel;

@property (weak, nonatomic) IBOutlet UITextField *contactPhoneNum;

@property (weak, nonatomic) IBOutlet UITextField *contactAddress;

- (IBAction)nextAction:(id)sender;



@end
