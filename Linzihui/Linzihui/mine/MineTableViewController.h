//
//  MineTableViewController.h
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/2.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "BaseHomeTableViewController.h"
#import "BaseTableViewController.h"
#import "SearchNearByViewController.h"

@interface MineTableViewController : BaseTableViewController
@property (weak, nonatomic) IBOutlet UIView *footerView;
- (IBAction)logoutAction:(id)sender;

@end
