//
//  ChangeCodeTVC.m
//  QianShouBang
//
//  Created by Haikun Zhu on 15/8/5.
//  Copyright (c) 2015年 zhuhaikun. All rights reserved.
//

#import "ChangeCodeTVC.h"
#import <SMS_SDK/SMSSDK.h>
#import "CommonMethods.h"
#import "MyProgressHUD.h"



@interface ChangeCodeTVC ()<UIAlertViewDelegate>
{
     
}
@end

@implementation ChangeCodeTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改密码";
    
    _changeCodeButton.clipsToBounds = YES;
    _changeCodeButton.layer.cornerRadius = 5.0;
    
    
}


- (IBAction)changeCodeAction:(id)sender {
    
    if (_newpwdTF.text.length == 0)
    {
        
        [MyProgressHUD showError:@"密码不能为空"];
        
     
        return;
    }
    
    if (_newpwdTF.text.length > 16) {
        
        [MyProgressHUD showError:@"密码必须小于16位"];
        
        
        return;
    }
    
    if (![_newpwdTF.text isEqualToString:_againpwdTF.text]) {
        
        [MyProgressHUD showError:@"两次输入的密码不一致"];
        
        
        return;
    }
    
    [MyProgressHUD showProgress];
    
    
    BmobQuery *query = [BmobUser query];
    
    [query whereKey:@"username" equalTo:_phoneNum];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
       
        if (array.count > 0) {
          
            BmobUser *_user = [array firstObject];
            
            [_user setObject:_newpwdTF.text forKey:@"password"];
            
            [_user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
              
                
                [MyProgressHUD dismiss];
                
                if (isSuccessful) {
                    
                    [CommonMethods showDefaultErrorString:@"修改成功"];
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
                }
                else
                {
                    [CommonMethods showDefaultErrorString:@"修改失败"];
                    
                }
                
                
            }];
            
        }
        else
        {
             [MyProgressHUD dismiss];
        }
        
    }];
 
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 999) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
