//
//  QunBaTableViewController.h
//  Linzihui
//
//  Created by ZhuHaikun on 16/6/1.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "BaseTableViewController.h"

@interface QunBaTableViewController : BaseTableViewController

@property (nonatomic ,strong) NSString *groupname;
@property (nonatomic,strong) NSString *groupId;
@property (nonatomic,strong) NSString *owner;


@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;

@property (weak, nonatomic) IBOutlet UISearchBar *searchbar;
- (IBAction)valueChange:(id)sender;

@end
