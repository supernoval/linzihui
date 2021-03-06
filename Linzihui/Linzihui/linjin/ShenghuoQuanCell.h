//
//  ShenghuoQuanCell.h
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/18.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDPhotoBrowser.h"
#import "SDPhotoGroup.h"


@interface ShenghuoQuanCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIButton *headButton;

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentextLabel;
@property (weak, nonatomic) IBOutlet SDPhotoGroup *photoView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textLabelHeight;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *zanButton;
@property (weak, nonatomic) IBOutlet UIButton *replayButton;

@property (weak, nonatomic) IBOutlet UILabel *commentNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *zanNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@property (weak, nonatomic) IBOutlet UILabel *levelLabel;


@end
