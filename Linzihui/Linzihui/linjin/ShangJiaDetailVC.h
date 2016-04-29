//
//  ShangJiaDetailVC.h
//  Linzihui
//
//  Created by ZhuHaikun on 16/4/29.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ShangJiaModel.h"

@interface ShangJiaDetailVC : BaseTableViewController


@property (nonatomic,strong) ShangJiaModel *model;

@property (weak, nonatomic) IBOutlet UIView *headView;

@property (weak, nonatomic) IBOutlet UIImageView *photoView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

- (IBAction)showMap:(id)sender;


- (IBAction)switchAction:(id)sender;



@end
