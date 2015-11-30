//
//  PersonCell.h
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/30.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@end
