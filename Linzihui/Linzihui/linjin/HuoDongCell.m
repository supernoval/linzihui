//
//  HuoDongCell.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/30.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "HuoDongCell.h"

@implementation HuoDongCell

- (void)awakeFromNib {
    // Initialization code
    
    
    self.attendButton.clipsToBounds = YES;
    self.attendButton.layer.cornerRadius = 5;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
