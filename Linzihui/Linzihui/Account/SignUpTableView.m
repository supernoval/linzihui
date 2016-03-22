//
//  SignUpTableView.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/15.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "SignUpTableView.h"

@interface SignUpTableView ()

@end

@implementation SignUpTableView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"注册";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)registAction:(id)sender {
    
    if (_nickNameLabel.text.length == 0) {
        
        [MyProgressHUD showError:@"请输入昵称"];
        
        return;
        
    }
    if (_codeTF.text.length > 16 || _codeTF.text.length == 0) {
        
        [MyProgressHUD showError:@"请输入小于16位的密码"];
        
        return;
        
        
    }
    
    if (![_codeTF.text isEqualToString:_checkCodeTF.text]) {
        
        
        [MyProgressHUD showError:@"两次输入的密码不一致"];
        
        return;
    }
    

    

    
    BmobUser *object = [[BmobUser alloc]init];
    
    object.username = _phone;
    object.password = _codeTF.text;
    [object setObject:_nickNameLabel.text forKey:@"nickName"];
    
//    object.mobilePhoneNumber = _phone;
    
    
    [object signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
        
        
        [MyProgressHUD dismiss];
        
        if (isSuccessful) {
            
            
            //邀请码
            NSString *invitecode = _yaoqingmaTF.text;
            
            if (invitecode.length > 0) {
                
                [BmobHelper addLevel:invitecode];
                
                
            }
            
            //添加关注信息
            BmobObject * _followOb = [[BmobObject alloc]initWithClassName:@"Follow"];
            
            BmobUser *currentUser = [BmobUser getCurrentUser];
            
            [_followOb setObject:currentUser.objectId forKey:@"userObjectId"];
            
            [_followOb saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
               
                if (isSuccessful) {
                    
                    NSLog(@"保存关注列表成功");
                    
                }
            }];
            
            [CommonMethods showDefaultErrorString:@"注册成功"];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
        else
        {
            NSLog(@"error:%@",error);
            
            [CommonMethods showDefaultErrorString:@"注册失败"];
            
            
        }
    }];
    

    
}

- (IBAction)showPrivacy:(id)sender {
}
@end
