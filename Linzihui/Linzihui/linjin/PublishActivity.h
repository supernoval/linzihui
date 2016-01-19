//
//  PublishActivity.h
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/26.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "BaseTableViewController.h"

@interface PublishActivity : UITableViewController

@property (nonatomic) NSString *groupId;



@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UIButton *backGroundImageButton;


- (IBAction)changeBackImageAction:(id)sender;


@property (weak, nonatomic) IBOutlet UIView *photoFooterView;

- (IBAction)photoButtonAction:(id)sender ;




@end
