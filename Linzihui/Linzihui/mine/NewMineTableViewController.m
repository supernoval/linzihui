//
//  NewMineTableViewController.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/18.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "NewMineTableViewController.h"
#import "MineTableViewController.h"
#import "MyPhotosViewController.h"
#import "SettingTableViewController.h"
#import "ShengHuoQuanTVC.h"
#import "LevelDetailViewController.h"
#import "HongBaoViewController.h"



@interface NewMineTableViewController ()

@end

@implementation NewMineTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我";
    
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UserModel *model = [BmobHelper getCurrentUserModel];
    
    
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.headImageURL] placeholderImage:kDefaultHeadImage];
    
    _nickNameLabel.text = model.nickName;
    
    _linhaoLabel.text = model.username;
    
    _yaoqingmaLabel.text = [model.objectId substringToIndex:4];
    
    
    [BmobHelper getLevel:^(NSString *levelStr) {
       
        [_levelButton setTitle:levelStr forState:UIControlStateNormal];
        
        
        
        
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section == 0) {
        
        MineTableViewController *_mine = [self.storyboard instantiateViewControllerWithIdentifier:@"MineTableViewController"];
        
        _mine.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:_mine animated:YES];
        
        
        
        
    }
    
    if (indexPath.section == 2) //相册
    {
//        MyPhotosViewController *_myPhotoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyPhotosViewController"];
//        
//        
//        _myPhotoVC.hidesBottomBarWhenPushed = YES;
//        
//        
//        [self.navigationController pushViewController:_myPhotoVC animated:YES];
        
        ShengHuoQuanTVC *_shenghuoQuan = [self.storyboard instantiateViewControllerWithIdentifier:@"ShengHuoQuanTVC"];
        
        _shenghuoQuan.hidesBottomBarWhenPushed = YES;
        
        _shenghuoQuan.isShuRenQuan = 2;
        
        
        [self.navigationController pushViewController:_shenghuoQuan animated:YES];
        
        
        
    }
  
    if (indexPath.section  == 3) {
        
        SettingTableViewController *_settting = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingTableViewController"];
        
        
        _settting.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:_settting animated:YES];
        
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)showLevel:(id)sender {
    
    LevelDetailViewController *_levelDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"LevelDetailViewController"];
    
    _levelDetail.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:_levelDetail animated:YES];
    
    
}
- (IBAction)showHongBao:(id)sender {
    
    HongBaoViewController *_hongBaoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HongBaoViewController"];
    _hongBaoVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:_hongBaoVC animated:YES];
    
    
}
@end
