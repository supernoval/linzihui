//
//  LevelDetailViewController.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/12/25.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "LevelDetailViewController.h"

@interface LevelDetailViewController ()

@end

@implementation LevelDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"等级规则";
    
    [BmobHelper getLevel:^(NSString *levelStr) {
        
        _currentLevel.text = levelStr;
        
        
        
        
        
    }];
    _detailLabel.text = @"等级规则:(分为从幼儿园到大学教授级别) \n 邀请好友：每邀请5个好友升一级";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
