//
//  PingJiaVC.h
//  Linzihui
//
//  Created by ZhuHaikun on 16/5/7.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "BaseViewController.h"
#import "BuyShangPinModel.h"

@interface PingJiaVC : BaseViewController

@property (nonatomic,strong) BuyShangPinModel *model;

@property (weak, nonatomic) IBOutlet UIView *starView;

@property (weak, nonatomic) IBOutlet UIView *touchView;


@property (weak, nonatomic) IBOutlet UITextView *commentTextView;

- (IBAction)summit:(id)sender;



@end
