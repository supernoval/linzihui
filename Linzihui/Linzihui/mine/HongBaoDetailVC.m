//
//  HongBaoDetailVC.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/4/23.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "HongBaoDetailVC.h"

@interface HongBaoDetailVC ()

@end

@implementation HongBaoDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"红包明细";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.numlabel.text = [NSString stringWithFormat:@"%.2f",[[_OB objectForKey:@"num"] floatValue]];
    self.timelabel.text = [CommonMethods getYYYYMMddHHmmssDateStr:_OB.createdAt];
    
    self.beizhuLable.text = [_OB objectForKey:@"beizhu"];
    
    BOOL isincome = [[_OB objectForKey:@"isincome"]boolValue];
    
    if (isincome) {
        
        self.typeLabel.text = @"收入";
    }
    else
    {
        self.typeLabel.text = @"支出";
    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
