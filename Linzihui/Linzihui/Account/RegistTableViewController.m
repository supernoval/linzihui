//
//  RegistTableViewController.m
//  QianShouBang
//
//  Created by Haikun Zhu on 15/8/5.
//  Copyright (c) 2015年 zhuhaikun. All rights reserved.
//

#import "RegistTableViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import "CommonMethods.h"
#import "MyProgressHUD.h"
#import "PrivacyViewController.h"
#import "SignUpTableView.h"




@interface RegistTableViewController ()<UIAlertViewDelegate>
{
    NSString *dviceToken;
    
    UIAlertView *_noneAlertView;
    
    UIAlertView *_dviceHadRegist;
    
    
    
}
@end

@implementation RegistTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"验证手机";
    
    _registButton.clipsToBounds = YES;
    _registButton.layer.cornerRadius = 5.0;
    

    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
   
}


- (IBAction)sendCodeAction:(id)sender {
    
    

    
    
    if ([CommonMethods checkTel:_phoneTF.text])
    {
        
    
        //检测是否注册过
        
        BmobQuery *query = [BmobQuery queryForUser];
        
        [query whereKey:@"username" equalTo:_phoneTF.text];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            
            if (!error ) {
                
                if (array.count > 0) {
                    
                    [CommonMethods showDefaultErrorString:@"该用户已注册"];
                    
                }
                else
                {
                    [self getCode];
                    
                    
                }
            }
            
        }];
        
        
        
     
        
        
    }
    else
    {
        [MyProgressHUD showError:@"手机号码不正确"];
        
    }
    
}

- (void)getCode
{
    _sendCodeButton.enabled = NO;
    
    [self getAutoCodeTime];
    
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_phoneTF.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
        if (!error) {
            
            NSLog(@"sendsms!");
            
            
        }
        else
        {
            NSLog(@"error:%@",error);
            
        }
    }];
}
- (IBAction)registAction:(id)sender {
    
  
    
 
    
    
    if (![CommonMethods checkTel:_phoneTF.text]) {
        
        [MyProgressHUD showError:@"请输入正确的手机号码"];
        
        return;
        
    }
    
    if (_SMSCodeTF.text.length == 0) {
        
        [MyProgressHUD showError:@"请输入验证码"];
        
        
        return;
        
        
    }
    

    
    
    [self checkSMSCode:_SMSCodeTF.text];
    
    
    
}

#pragma mark -  校验验证码
-(void)checkSMSCode:(NSString *)SMSCode
{
    
    [MyProgressHUD showProgress];
    
    [SMSSDK commitVerificationCode:SMSCode phoneNumber:_phoneTF.text zone:@"86" result:^(NSError *error) {
      
        
        if (!error)
        {
            
            [self summitRegist];
            
        }
        else
        {
            [MyProgressHUD dismiss];
            
            [CommonMethods showDefaultErrorString:@"验证码不正确"];
            
            
        }
    }];
    

    
}

#pragma mark - 下一步
-(void)summitRegist
{

     [MyProgressHUD dismiss];
    
    SignUpTableView *_signUpTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUpTableView"];
    _signUpTVC.phone = _phoneTF.text;
    
    [self.navigationController pushViewController:_signUpTVC animated:YES];
    
    
    
    
    
    
}

- (IBAction)showPrivacy:(id)sender {
    
    UINavigationController *_privacy = [self.storyboard instantiateViewControllerWithIdentifier:@"privacyNav"];
    
    [self presentViewController:_privacy animated:YES completion:nil];
    
    
}


#pragma mark - 倒计时
-(void)getAutoCodeTime{
    __block int timeout=30;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [_sendCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal] ;
                _sendCodeButton.enabled = YES;
                
            });
        }else{
            int seconds = timeout % 31;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
//                NSLog(@"____%@",strTime);
                
                [_sendCodeButton setTitle:[NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateNormal] ;
                
                
                
                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}





#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == _noneAlertView)
    {
        
        [self.navigationController popViewControllerAnimated:YES];
        
        return;
    }
    
    if (alertView == _dviceHadRegist) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
        return;
        
    }
}

#pragma mar - 自动登录
-(void)login:(NSString*)phone  code:(NSString*)code
{
    
    [MyProgressHUD showProgress];

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
