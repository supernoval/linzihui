//
//  HuoDongDetailTVC.h
//  Linzihui
//
//  Created by ZhuHaikun on 15/12/18.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ShowDetailViewController.h"
@interface HuoDongDetailTVC : BaseTableViewController



@property (nonatomic) HuoDongModel *huodong;


@property (weak, nonatomic) IBOutlet UIView *headerView;


@property (weak, nonatomic) IBOutlet UIImageView *backGroundImageView;

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


@property (weak, nonatomic) IBOutlet UILabel *ageRequest;

@property (weak, nonatomic) IBOutlet UILabel *familyNum;



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


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailtitleheight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailheight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tediantitleheight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tedianheight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *liuchentitleheight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *liuchenheight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zhuyititleHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zhuyiheight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailButtonHeight;


@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tedianButtonHeght;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *liuchengButtonHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zhuyiButtonHeight;

@property (weak, nonatomic) IBOutlet UIButton *publishButton;

- (IBAction)showPublisherAction:(id)sender;

- (IBAction)showDetail:(id)sender;

- (IBAction)showTeDian:(id)sender;

- (IBAction)showLiuChen:(id)sender;

- (IBAction)showShiXiang:(id)sender;



- (IBAction)showMapView:(id)sender;


@end
