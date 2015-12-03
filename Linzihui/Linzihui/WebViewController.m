//
//  WebViewController.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/12/3.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
    
    
    [_webView loadRequest:request];
    
    
    
    [self.view addSubview:_webView];
    
    
    
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
