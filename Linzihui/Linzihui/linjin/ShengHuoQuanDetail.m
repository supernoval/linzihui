//
//  ShengHuoQuanDetail.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/3/22.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "ShengHuoQuanDetail.h"

@interface ShengHuoQuanDetail ()

@end

@implementation ShengHuoQuanDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"详情";
    
    self.detailLabel.text = _detailText;
    
    CGFloat height = [StringHeight heightWithText:_detailText font:FONT_15 constrainedToWidth:self.view.frame.size.width - 40];
    
    self.detailLabelHeightConstant.constant = height ;
    
    
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
