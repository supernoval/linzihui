//
//  GZViewController.h
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/12.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "BaseViewController.h"
#import "ConstantsHeaders.h"

@interface GZViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *segMent;
- (IBAction)switchAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
