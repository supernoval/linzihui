//
//  ShowDetailViewController.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/1/15.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "ShowDetailViewController.h"


@interface ShowDetailViewController ()

@end

@implementation ShowDetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _detailTF.text = _detail;
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _detailTF.text = _detail;
    
}

-(void)setDetail:(NSString *)detail
{
    _detailTF.text = detail;
    
    _detail = detail;
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
