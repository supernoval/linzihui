//
//  ChangePersonInfoVC.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/8.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "ChangePersonInfoVC.h"
#import "BmobHelper.h"

@interface ChangePersonInfoVC ()

@end

@implementation ChangePersonInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
  
    if (_value) {
        
         _myTextField.text = _value; 
    }
  
    
}

-(void)setChangeTitle:(NSString *)changeTitle
{
    self.title = changeTitle;
    
}

- (IBAction)saveAction:(id)sender {
    
    
    
    if (_myTextField.text.length > 0  && _key) {
        
        
        [BmobHelper updateBmobWithKey:_key value:_myTextField.text object:[BmobUser getCurrentUser] result:^(BOOL isSuccess) {
           
            if (isSuccess) {
                
                
                [CommonMethods showDefaultErrorString:@"修改成功"];
                
                
            }else
            {
                [CommonMethods showDefaultErrorString:@"修改失败"];
                
            }
        }];
    }
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
