//
//  PersonPullView.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/1/12.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "PersonPullView.h"
#import "BaseTableViewController.h"
@implementation PersonPullView

-(id)init
{
    
    
    
    if (self == [super init]) {
        
        
        self.frame = CGRectMake(0, 0,ScreenWidth , ScreenHeight);
        
        
        UIControl *backGroundView = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        
        [backGroundView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self addSubview:backGroundView];
        
        
        [self addPullView];
        
        
        
        
        
    }
    
    return self;
    
}

-(void)addPullView
{
    
    CGFloat pullwith = 120;
    
    CGFloat pullHeight = 150;
    
    
    UIView *pullView = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth - pullwith, 0, pullwith, pullHeight)];
    
    
    pullView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
    
    
    [self addSubview:pullView];
    
    
    UIButton *deleButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, pullwith, pullHeight/3)];
    
    deleButton.backgroundColor = [UIColor clearColor];
    
    [deleButton setTitle:@"删除好友" forState:UIControlStateNormal];
    
    [deleButton setTitleColor:kBlueBackColor forState:UIControlStateNormal];
    
    [deleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [deleButton addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    [pullView addSubview:deleButton];
    
    
    UIButton *blockButton = [[UIButton alloc]initWithFrame:CGRectMake(0, pullHeight/3, pullwith, pullHeight/3)];
    
    blockButton.backgroundColor = [UIColor clearColor];
    
    [blockButton setTitle:@"加入黑名单" forState:UIControlStateNormal];
    [blockButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [blockButton setTitleColor:kBlueBackColor forState:UIControlStateNormal];
    
    
    [blockButton addTarget:self action:@selector(blockAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    [pullView addSubview:blockButton];
    
    
    UIButton *jubao = [[UIButton alloc]initWithFrame:CGRectMake(0, pullHeight/3 * 2, pullwith, pullHeight/3)];
    
    jubao.backgroundColor = [UIColor clearColor];
    
    [jubao setTitleColor:kBlueBackColor forState:UIControlStateNormal];
    
    [jubao setTitle:@"举报用户" forState:UIControlStateNormal];
    
    [jubao setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [pullView addSubview:jubao];
    
    
    [jubao addTarget:self action:@selector(jubao) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    
}

-(void)show
{
    
}


-(void)dismiss
{
    
    [self removeFromSuperview];
    
    
}

-(void)deleteAction
{
    
}

-(void)blockAction
{
    
}

-(void)jubao
{
    
}





@end
