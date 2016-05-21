//
//  BuyHistoryCell.h
//  Linzihui
//
//  Created by ZhuHaikun on 16/5/18.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuyHistoryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *shangpinnamelabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *addresslabel;

@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commnetHeight;

@property (weak, nonatomic) IBOutlet UIButton *nameButton;


@end
