//
//  HongBaoDetailVC.h
//  Linzihui
//
//  Created by ZhuHaikun on 16/4/23.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "BaseViewController.h"

@interface HongBaoDetailVC : BaseViewController

@property (nonatomic,strong) BmobObject *OB;

@property (weak, nonatomic) IBOutlet UILabel *numlabel;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timelabel;

@property (weak, nonatomic) IBOutlet UILabel *beizhuLable;


@end
