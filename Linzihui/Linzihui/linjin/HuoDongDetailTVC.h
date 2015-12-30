//
//  HuoDongDetailTVC.h
//  Linzihui
//
//  Created by ZhuHaikun on 15/12/18.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "BaseTableViewController.h"

@interface HuoDongDetailTVC : BaseTableViewController



@property (nonatomic) HuoDongModel *huodong;


@property (weak, nonatomic) IBOutlet UIView *headerView;



@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *feelabel;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet UILabel *publisher;

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UILabel *tedianLabel;

@property (weak, nonatomic) IBOutlet UILabel *liuchengLabel;


@property (weak, nonatomic) IBOutlet UILabel *shixianglabel;

@property (weak, nonatomic) IBOutlet UILabel *endRegistTimeLabel;


@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UIButton *attendButton;

- (IBAction)attendAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *checkButton;

- (IBAction)checkAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *numLabel;

- (IBAction)zixunAction:(id)sender;

- (IBAction)pinglunAction:(id)sender;

- (IBAction)qiandao:(id)sender;

- (IBAction)yaoqing:(id)sender;

@property (weak, nonatomic) IBOutlet SDPhotoGroup *photoView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoHeight;



@end
