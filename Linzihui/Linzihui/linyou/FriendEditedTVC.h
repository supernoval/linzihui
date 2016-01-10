//
//  FriendEditedTVC.h
//  Linzihui
//
//  Created by ZhuHaikun on 16/1/10.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "BaseTableViewController.h"

@interface FriendEditedTVC : BaseTableViewController


@property (nonatomic) UserModel *model;

- (IBAction)deleteFriend:(id)sender;

- (IBAction)addBlackSheet:(id)sender;
- (IBAction)jubao:(id)sender;


@end
