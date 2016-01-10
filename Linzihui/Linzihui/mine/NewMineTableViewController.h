//
//  NewMineTableViewController.h
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/18.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "BaseHomeTableViewController.h"

@interface NewMineTableViewController : BaseHomeTableViewController

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;


@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *yaoqingmaLabel;

@property (weak, nonatomic) IBOutlet UILabel *linhaoLabel;


@property (weak, nonatomic) IBOutlet UILabel *levelLabel;

- (IBAction)showLevel:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *levelButton;


- (IBAction)showHongBao:(id)sender;



@end
