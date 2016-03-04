//
//  ApplyJoinGroupViewController.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/3/4.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "ApplyJoinGroupViewController.h"

@interface ApplyJoinGroupViewController ()<UIAlertViewDelegate>
{
    UIAlertView *_alertView;
    
}
@end

@implementation ApplyJoinGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"群信息";
    _footerView.frame = CGRectMake(0, 0, ScreenWidth, 200);
    
    _alertView = [[UIAlertView alloc]initWithTitle:@"发送加群申请" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"发送", nil];
    
    
    _alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    
    
}

 -(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self showData];
    
    
}


-(void)showData
{
    
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:_groupModel.groupHeadImage] placeholderImage:kDefaultHeadImage];
    
    self.memberNum.text = [NSString stringWithFormat:@"%ld人",(long)_groupModel.members.count];

    self.nickNameLabel.text = [NSString stringWithFormat:@"%@",_groupModel.subTitle];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}



- (IBAction)applyJoin:(id)sender {
    
    
    [_alertView show];
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 1) {
        
        UITextField *TF = [alertView textFieldAtIndex:0];
        NSString *msg = TF.text;
        if (msg == nil) {
            
            msg = @"";
            
        }
        [EMHelper applyJoinGroup:_groupModel.groupId groupName:_groupModel.subTitle username:nil message:msg result:^(BOOL success, EMGroup *group) {
           
            if (success) {
                
                [CommonMethods showDefaultErrorString:@"申请发送成功"];
                
                [self.navigationController popViewControllerAnimated:YES];
                
                
            }
        }];
    }
    
}
@end
