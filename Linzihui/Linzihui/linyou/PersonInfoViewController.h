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



@property (nonatomic,strong) NSString *username;


@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *nickName;

@property (weak, nonatomic) IBOutlet UILabel *linhao;
@property (weak, nonatomic) IBOutlet UILabel *yaoqingma;

@property (weak, nonatomic) IBOutlet UILabel *qianming;

@property (weak, nonatomic) IBOutlet UILabel *address;

@property (weak, nonatomic) IBOutlet UIButton *sendButton;

- (IBAction)sendAction:(id)sender;


@end
