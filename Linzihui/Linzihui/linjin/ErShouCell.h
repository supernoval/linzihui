//
//  ErShouCell.h
//  Linzihui
//
//  Created by ZhuHaikun on 16/3/30.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDPhotoGroup.h"

@interface ErShouCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UIButton *headButton;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *levelLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *pirceLabel;



@property (weak, nonatomic) IBOutlet SDPhotoGroup *photoView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (weak, nonatomic) IBOutlet UIButton *replayButton;
@property (weak, nonatomic) IBOutlet UILabel *replayNumLabel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelHeight;

@property (weak, nonatomic) IBOutlet UILabel *validateLabel;


- (IBAction)likeAction:(id)sender;


@property (weak, nonatomic) IBOutlet UILabel *likeNumLabel;
- (IBAction)replayAction:(id)sender;



@end
