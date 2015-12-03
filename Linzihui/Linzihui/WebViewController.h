//
//  WebViewController.h
//  Linzihui
//
//  Created by ZhuHaikun on 15/12/3.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "BaseViewController.h"

@interface WebViewController : BaseViewController

@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) NSString *url;

@end
