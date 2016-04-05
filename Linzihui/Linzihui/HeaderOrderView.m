//
//  HeaderOrderView.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/4/5.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "HeaderOrderView.h"

@implementation HeaderOrderView

-(id)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        [self addButtons];
        
    }
    
    return self;
    
}

-(void)addButtons
{
    _orderButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/2, 50)];
    
    [_orderButton setTitle:@"分类" forState:UIControlStateNormal];
    
    [_orderButton addTarget:self action:@selector(showOrder) forControlEvents:UIControlEventTouchUpInside];
    
    [_orderButton setTitleColor:kBlueBackColor forState:UIControlStateNormal];
    
   
    [self addSubview:_orderButton];
    
   
    _distanceButton = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth/2, 0, ScreenWidth/2, 50)];
    [_distanceButton setTitle:@"距离排序" forState:UIControlStateNormal];
    
    [_distanceButton setTitleColor:kBlueBackColor forState:UIControlStateNormal];
    
    [_distanceButton addTarget:self action:@selector(changeDistanceOrder) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self addSubview:_distanceButton];
    
    
}

- (void)showOrder
{
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
    
    ErShouTypeTVC *_ershouTVC =[[ErShouTypeTVC alloc]initWithStyle:UITableViewStyleGrouped];
    
    
    [_ershouTVC setBlock:^(BOOL success, NSString *typeString) {
        
        if (success) {
            
            if ([self.delegate respondsToSelector:@selector(selectedType:)])
            {
                
                [_orderButton setTitle:typeString forState:UIControlStateNormal];
                
                [self.delegate selectedType:typeString];
                
                
            }
        }
        
    }];
    [_listTVC.navigationController pushViewController:_ershouTVC animated:YES];
}
- (void)setOrder
{
    
}

- (void)changeDistanceOrder
{
  
    if ([self.delegate respondsToSelector:@selector(changeDistance)]) {
        
        [self.delegate changeDistance];
        
    }
    
}
-(void)layoutSubviews
{
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
