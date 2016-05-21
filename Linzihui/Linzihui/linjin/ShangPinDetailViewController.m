//
//  ShangPinDetailViewController.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/5/21.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "ShangPinDetailViewController.h"

@interface ShangPinDetailViewController ()

@end

@implementation ShangPinDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"商品详情";
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _nameLabel.text = _model.name;
    
    _priceLabel.text = [NSString stringWithFormat:@"%.2f元",_model.price];
    
    _detailDes.text = _model.des;
    
    [_shangpinimageView sd_setImageWithURL:[NSURL URLWithString:_model.photos] placeholderImage:kDefaultHeadImage];
    
    
    CGFloat desHeight = [StringHeight heightWithText:_model.des font:FONT_15 constrainedToWidth:ScreenWidth-130];
    
    if (desHeight < 21) {
        
        desHeight = 21;
        
    }
    _heightConstraints.constant = desHeight;
    
  
    _photoView.photoItemArray = _model.photoArray;
    
    
}






@end
