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

-(id)initwithUserModel:(UserModel *)model
{
    
    
    
    if (self == [super init]) {
        
        
        self.frame = CGRectMake(0, 64,ScreenWidth , ScreenHeight);
        
        self.model = model;
        
        if (model.followType == CheckTypeFriend) {
            
            self.isFriend = YES;
        }
        else
        {
            self.isFriend = NO;
            
        }
        
        
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
    
    if (!_isFriend) {
        
        pullHeight = 100;
        
    }
    
    UIView *pullView = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth - pullwith, 0, pullwith, pullHeight)];
    
    
    pullView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
    
    
    [self addSubview:pullView];
    
    
    CGFloat origion =0;
    
    if (!_isFriend) {
        
        origion = pullHeight/3;
        
    }
    
    
    UIButton *deleButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, pullwith, pullHeight/3)];
    
    deleButton.backgroundColor = [UIColor clearColor];
    
    [deleButton setTitle:@"删除好友" forState:UIControlStateNormal];
    
    [deleButton setTitleColor:kBlueBackColor forState:UIControlStateNormal];
    
    [deleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [deleButton addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    
    

    
    UIButton *blockButton = [[UIButton alloc]init];
    
    UIButton *jubao = [[UIButton alloc]init];
    
    
    if (_isFriend) {
        
            [pullView addSubview:deleButton];
        
        blockButton.frame = CGRectMake(0, pullHeight/3 , pullwith, pullHeight/3);
        
        jubao.frame= CGRectMake(0, pullHeight/3 * 2, pullwith, pullHeight/3);
    }
  else
  {
      blockButton.frame = CGRectMake(0, 0 , pullwith, pullHeight/2);
      
      jubao.frame= CGRectMake(0, pullHeight/2 , pullwith, pullHeight/2);
  }
    
    
    blockButton.backgroundColor = [UIColor clearColor];
    
    [blockButton setTitle:@"加入黑名单" forState:UIControlStateNormal];
    [blockButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [blockButton setTitleColor:kBlueBackColor forState:UIControlStateNormal];
    
    
    [blockButton addTarget:self action:@selector(blockAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    [pullView addSubview:blockButton];
    
    
  
    
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
    UIAlertView *_alert = [[UIAlertView alloc]initWithTitle:nil message:@"确实删除该好友?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    
    _alert.tag = 99;
    
    [_alert show];
}

-(void)blockAction
{
    UIAlertView *_alert = [[UIAlertView alloc]initWithTitle:nil message:@"将该好友加入黑名单?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    _alert.tag = 100;
    
    [_alert show];
}

-(void)jubao
{
    UIAlertView *_alert = [[UIAlertView alloc]initWithTitle:nil message:@"确定举报该用户?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    _alert.tag = 101;
    
    [_alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        switch (alertView.tag) {
            case 99:
            {
                EMError *error = nil;
                
                BOOL success = [[EaseMob sharedInstance].chatManager removeBuddy:_model.username removeFromRemote:YES error:&error];
                
                if (success && !error) {
                    
                    
                    [[EaseMob sharedInstance].chatManager removeConversationByChatter:_model.username deleteMessages:YES append2Chat:YES];
                    
                    
                    [CommonMethods showDefaultErrorString:@"删除成功"];
                    
                    [self dismiss];
                    
                }
                
                
            }
                break;
            case 100:
            {
                //                EMError *error = nil;
                
                BOOL success = [[EaseMob sharedInstance].chatManager blockBuddy:_model.username relationship:eRelationshipBoth];
                
                if (success) {
                    
                    [CommonMethods showDefaultErrorString:@"已加入黑名单"];
                    
                  [self dismiss];
                    
                }
            }
                break;
            case 101:
            {
                [CommonMethods showDefaultErrorString:@"举报成功"];
                
                 [self dismiss];
                
            }
                break;
                
                
            default:
                break;
        }
    }
    
}



@end
