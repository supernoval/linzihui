//
//  LoginViewController.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/2.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistTableViewController.h"
#import "ForgetCodeTVC.h"
#import "ChatAccountManager.h"

#import "PrivacyViewController.h"


@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    
    
    
}


- (IBAction)loginButton:(id)sender {
    
    if (_usernameTF.text.length == 0) {
        
        [CommonMethods showDefaultErrorString:@"请填写用户名"];
        
        return;
        
    }
    
    if (_codeTF.text.length == 0) {
        
        [CommonMethods showDefaultErrorString:@"请填写密码"];
        
        return;
    }
    
    
 
    
    [BmobUser loginInbackgroundWithAccount:_usernameTF.text andPassword:_codeTF.text block:^(BmobUser *user, NSError *error) {
        
        if (!error) {
            
            CGFloat longitude = [[NSUserDefaults standardUserDefaults ] floatForKey:kCurrentLongitude];
            
            CGFloat latitude = [[NSUserDefaults standardUserDefaults] floatForKey:kCurrentLatitude];
            
            if (longitude > 0 && latitude > 0) {
                
                BmobUser *currentUser = [BmobUser getCurrentUser];
                
                BmobGeoPoint *point = [[BmobGeoPoint alloc]initWithLongitude:longitude WithLatitude:latitude];
                
                [currentUser setObject:point forKey:@"location"];
                
                
                [currentUser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    
                    if (isSuccessful) {
                        
                        NSLog(@"地理坐标保存成功");
                        
                    }
                    else
                    {
                        NSLog(@"地理位置保存失败 ：%@",error);
                        
                        
                    }
                }];

                
            }
            

            
            [[ChatAccountManager shareChatAccountManager] loginWithAccount:_usernameTF.text successBlock:^(BOOL isSuccess) {
               
                if (isSuccess) {
                    
                    NSLog(@"环信账号登陆成功!");
                    
                }
                
            }];
            [[NSUserDefaults standardUserDefaults ] setBool:YES forKey:kHadLogin];
            [[NSUserDefaults standardUserDefaults ] synchronize];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
            
        }
        else
        {
            [CommonMethods showDefaultErrorString:@"登陆失败"];
            
        }
        
    }];
    
    
    
}

- (IBAction)registAction:(id)sender {
    
    RegistTableViewController *regist = [self.storyboard instantiateViewControllerWithIdentifier:@"RegistTableViewController"];
    
    
    [self.navigationController pushViewController:regist animated:YES];
    
    
    
}

- (IBAction)forgetCodeAction:(id)sender {
    
    ForgetCodeTVC *_forgetcode = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgetCodeTVC"];
    
    [self.navigationController pushViewController:_forgetcode animated:YES];
    
    
}

- (IBAction)showPrivacy:(id)sender {
    
    UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"privacyNav"];
    
    [self presentViewController:nav animated:YES completion:nil];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
