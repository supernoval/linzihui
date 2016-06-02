//
//  AddTypeViewController.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/6/2.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "AddTypeViewController.h"

@interface AddTypeViewController ()

@end

@implementation AddTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"新增分类";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)summitAction:(id)sender {
    
    if (_typenameTF.text.length == 0) {
        
        [CommonMethods showDefaultErrorString:@"请输入分类名称"];
        
        return;
    }
    
    [_QunOB addObjectsFromArray:@[_typenameTF.text] forKey:@"types"];
    
    [_QunOB updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
       
        
        if (isSuccessful) {
            
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else
        {
            NSLog(@"error:%@",error);
            
        }
        
    }];
    
}
@end
