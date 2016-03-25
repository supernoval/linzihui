//
//  PersonInfoViewController.h
//  Linzihui
//
//  Created by ZhuHaikun on 15/12/23.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseTableViewController.h"

@interface PersonInfoViewController : BaseTableViewController
@property (weak, nonatomic) IBOutlet UIView *footerView;

@property (weak, nonatomic) IBOutlet UIButton *cancelAttendButton;

@property (weak, nonatomic) IBOutlet UILabel *linhaoTitleLabel;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightButton;

- (IBAction)showInfo:(id)sender;

@property (nonatomic,strong) NSString *username;

@property (nonatomic) BOOL isShowed; //是否从聊天界面过来

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *nickName;

@property (weak, nonatomic) IBOutlet UILabel *linhao;
@property (weak, nonatomic) IBOutlet UILabel *yaoqingma;

@property (weak, nonatomic) IBOutlet UILabel *beizhuLabel;


@property (weak, nonatomic) IBOutlet UILabel *qianming;

@property (weak, nonatomic) IBOutlet UILabel *address;



@property (weak, nonatomic) IBOutlet UIButton *sendButton;

- (IBAction)sendAction:(id)sender;
- (IBAction)cancelAttend:(id)sender;


@end
