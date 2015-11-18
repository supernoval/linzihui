//
//  NewMineTableViewController.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/18.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "NewMineTableViewController.h"
#import "MineTableViewController.h"

@interface NewMineTableViewController ()

@end

@implementation NewMineTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UserModel *model = [BmobHelper getCurrentUserModel];
    
    
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.headImageURL] placeholderImage:kDefaultHeadImage];
    
    _nickNameLabel.text = model.nickName;
    
    _linhaoLabel.text = model.username;
    
    _yaoqingmaLabel.text = [model.objectId substringToIndex:4];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section == 0) {
        
        MineTableViewController *_mine = [self.storyboard instantiateViewControllerWithIdentifier:@"MineTableViewController"];
        
        _mine.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:_mine animated:YES];
        
        
        
        
    }
  
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
