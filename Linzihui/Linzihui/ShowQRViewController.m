//
//  ShowQRViewController.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/12/3.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "ShowQRViewController.h"

@interface ShowQRViewController ()
{
    UIImageView *_imageView;
    
}
@end

@implementation ShowQRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.title = @"二维码";
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGSize screenSize = self.view.bounds.size;
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 150, screenSize.width - 100, screenSize.width - 100)];
    
    _imageView.image = [LBXScanWrapper createQRWithString:_qrString size:_imageView.frame.size];
    
    
    [self.view addSubview:_imageView];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
