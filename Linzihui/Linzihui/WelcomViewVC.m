//
//  WelcomViewVC.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/1/1.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "WelcomViewVC.h"

@interface WelcomViewVC ()<UIScrollViewDelegate>
{
    UIScrollView *myScrollView;
    
}
@end

@implementation WelcomViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    myScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    
    myScrollView.delegate = self;
    
    
    myScrollView.contentSize = CGSizeMake(ScreenWidth *3, self.view.frame.size.height);
    myScrollView.pagingEnabled = YES;
    myScrollView.alwaysBounceVertical = NO;
    
    for (int i = 1; i < 4; i ++) {
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((i-1)*ScreenWidth, 0, ScreenWidth, ScreenHeight)];
        
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"welcome_%d",i]];
        
        [myScrollView addSubview:imageView];
        
        
        
    }
    
    [self.view addSubview:myScrollView];
    
    
    
}





-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat contentOffset = scrollView.contentOffset.x;
    
    
    if (contentOffset > ScreenWidth * 2.2) {
        
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIsFirstLaunch];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self dismissViewControllerAnimated:NO completion:nil];
        
        
    }
}


@end
