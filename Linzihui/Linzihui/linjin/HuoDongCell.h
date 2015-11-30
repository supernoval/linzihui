//
//  HuoDongCell.h
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/30.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HuoDongCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@property (weak, nonatomic) IBOutlet UILabel *feeLabel;


@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;


@property (weak, nonatomic) IBOutlet UILabel *publisherLabel;

@property (weak, nonatomic) IBOutlet UIButton *attendButton;

@property (weak, nonatomic) IBOutlet UILabel *attendNumLabel;




@end
