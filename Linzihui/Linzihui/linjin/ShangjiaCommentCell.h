//
//  ShangjiaCommentCell.h
//  Linzihui
//
//  Created by ZhuHaikun on 16/4/29.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShangjiaCommentCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentlabel;

@property (weak, nonatomic) IBOutlet UIButton *buyButton;



@end
