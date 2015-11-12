//
//  WechatShareController.h
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/12.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "BaseTableViewController.h"

@interface WechatShareController : BaseTableViewController

@property (nonatomic,assign) NSInteger shareType; //1 微信 2 qq

@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;

@property (weak, nonatomic) IBOutlet UILabel *firstTitlelabel;
@property (weak, nonatomic) IBOutlet UIImageView *secImageView;
@property (weak, nonatomic) IBOutlet UILabel *secTitleLabel;

@end
