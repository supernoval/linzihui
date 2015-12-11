//
//  LoginViewController.h
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/2.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface LoginViewController : BaseViewController



@property (weak, nonatomic) IBOutlet UITextField *usernameTF;

@property (weak, nonatomic) IBOutlet UITextField *codeTF;
- (IBAction)loginButton:(id)sender;


- (IBAction)registAction:(id)sender;


- (IBAction)forgetCodeAction:(id)sender;

- (IBAction)showPrivacy:(id)sender;





@end
