//
//  EditeShangJiaTVC.h
//  Linzihui
//
//  Created by ZhuHaikun on 16/5/18.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ShangJiaModel.h"

@interface EditeShangJiaTVC : BaseTableViewController


@property (nonatomic,strong) ShangJiaModel *model;


@property (weak, nonatomic) IBOutlet UIButton *headButton;

@property (weak, nonatomic) IBOutlet UITextField *nameTextfield;



@property (weak, nonatomic) IBOutlet UITextField *addressTextfield;

@property (weak, nonatomic) IBOutlet UILabel *gpsLabel;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;


@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

- (IBAction)changeHeadAction:(id)sender;



@end
