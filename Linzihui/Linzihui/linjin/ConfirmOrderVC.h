//
//  ConfirmOrderVC.h
//  Linzihui
//
//  Created by ZhuHaikun on 16/5/4.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "BaseViewController.h"
#import "ShangJiaModel.h"

@interface ConfirmOrderVC : BaseViewController

@property (nonatomic,strong) ShangJiaModel *shangjiaModel;

@property (nonatomic,strong) NSDictionary *shangpinDict;
@property (nonatomic,strong) NSDictionary *addressDict;

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;


- (IBAction)ok:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *contactNameLabel;


@property (weak, nonatomic) IBOutlet UILabel *contactPhoneLabel;

@property (weak, nonatomic) IBOutlet UILabel *contactAddressLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressLabelHeight;



@end
