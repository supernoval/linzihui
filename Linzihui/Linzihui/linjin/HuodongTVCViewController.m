//
//  HuodongTVCViewController.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/26.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "HuodongTVCViewController.h"
#import "PublishActivity.h"

@interface HuodongTVCViewController ()

@end

@implementation HuodongTVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    
    self.title = @"邻近活动";
    
    UIBarButtonItem *_item = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(gotoPublishActivity)];
    
    self.navigationItem.rightBarButtonItem = _item;
    
    
    
    
}


-(void)gotoPublishActivity
{
    PublishActivity *_publish = [self.storyboard instantiateViewControllerWithIdentifier:@"PublishActivity"];
    
    
    [self.navigationController pushViewController:_publish animated:YES];
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
