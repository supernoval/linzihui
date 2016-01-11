//
//  HuodongCommentCell.h
//  Linzihui
//
//  Created by ZhuHaikun on 16/1/11.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDPhotoGroup.h"


@interface HuodongCommentCell : UITableViewCell



@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *commentLabel;


@property (weak, nonatomic) IBOutlet SDPhotoGroup *photoView;



@end
