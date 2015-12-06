//
//  FeedBackViewController.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/12/6.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "FeedBackViewController.h"

@interface FeedBackViewController ()

@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [_contentTV becomeFirstResponder];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)summitAction:(id)sender {
    
    if (_contentTV.text.length == 0) {
        
        [CommonMethods showDefaultErrorString:@"请填写反馈内容"];
        
        return;
        
    }
    
    [_contentTV resignFirstResponder];
    
    
//    [self.view endEditing:YES];
    
    
    BmobObject *_Ob = [BmobObject objectWithClassName:kFeedBackTableName];
    
    
    [_Ob setObject:_contentTV.text forKey:@"content"];
    
    [_Ob setObject:[BmobUser getCurrentUser] forKey:@"user"];
    
    
    
    [_Ob saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
       
        if (isSuccessful) {
            
            [CommonMethods showDefaultErrorString:@"感谢您的反馈,我们将尽快处理"];
            
            
            [self.navigationController popViewControllerAnimated:YES];
            
            
        }
        
        
    }];
}
@end
