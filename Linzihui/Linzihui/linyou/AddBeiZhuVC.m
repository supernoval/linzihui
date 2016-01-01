//
//  AddBeiZhuVC.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/1/1.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "AddBeiZhuVC.h"

@interface AddBeiZhuVC ()

@end

@implementation AddBeiZhuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改备注";
    
    _beizhuLabel.text = _beizhuStr;
    
    
}



- (IBAction)save:(id)sender {
    
    
    if (_beizhuLabel.text.length == 0) {
        
        return;
        
    }
    
    UserModel *model = [BmobHelper getCurrentUserModel];
    
    NSArray *beiZhus = model.beiZhu;
    
    NSMutableDictionary *mudic = [[NSMutableDictionary alloc]init];
    
    NSMutableArray *temMuArray = [[NSMutableArray alloc]initWithArray:beiZhus];
    
    [mudic setObject:_username forKey:@"username"];
    [mudic setObject:_beizhuLabel.text forKey:@"beizhu"];
    
    if (beiZhus.count > 0) {
        
        BOOL inside = NO;
        
   
    for (int i = 0 ;i < beiZhus.count; i++) {
        
        NSDictionary *dic = [beiZhus objectAtIndex:i];
        
        NSString *username = [dic objectForKey:@"username"];
        
        if ([username isEqualToString:_username]) {
            
            [temMuArray replaceObjectAtIndex:i withObject:mudic];
            
            inside = YES;
            
        }
        
   
        
        }
        
        if (!inside) {
            
            [temMuArray addObject:mudic];
            
        }
        
     }
    else
    {
        [temMuArray addObject:mudic];
        
    }
    
    [MyProgressHUD showProgress];
    
    [BmobHelper updateBmobWithKey:@"beiZhu" value:temMuArray usermodel:model result:^(BOOL success) {
        
        [MyProgressHUD dismiss];
        
        if (success) {
            
            NSLog(@"添加备注成功");
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    }];
    
    
    
}
@end
