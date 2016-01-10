//
//  FriendEditedTVC.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/1/10.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "FriendEditedTVC.h"

@interface FriendEditedTVC ()<UIAlertViewDelegate>

@end

@implementation FriendEditedTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = _model.beizhu;
    
    if (!self.title) {
        self.title = _model.nickName;
    }
    
    if (!self.title) {
        
        self.title = _model.username;
        
    }
    
    
}


- (IBAction)deleteFriend:(id)sender {
    
    
   
    UIAlertView *_alert = [[UIAlertView alloc]initWithTitle:nil message:@"确实删除该好友?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    
    _alert.tag = 99;
    
    [_alert show];
    
    
    
    
}

- (IBAction)addBlackSheet:(id)sender {
    
    
    UIAlertView *_alert = [[UIAlertView alloc]initWithTitle:nil message:@"将该好友加入黑名单?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    _alert.tag = 100;
    
    [_alert show];
    
    
}



- (IBAction)jubao:(id)sender {
    
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
                    
                    [CommonMethods showDefaultErrorString:@"删除成功"];
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
                }
                
                
            }
                break;
            case 100:
            {
//                EMError *error = nil;
                
                BOOL success = [[EaseMob sharedInstance].chatManager blockBuddy:_model.username relationship:eRelationshipBoth];
                
                if (success) {
                    
                    [CommonMethods showDefaultErrorString:@"已加入黑名单"];
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
                }
            }
                break;
            case 101:
            {
                 [CommonMethods showDefaultErrorString:@"举报成功"];
            }
                break;
                
                
            default:
                break;
        }
    }
    
}
@end
