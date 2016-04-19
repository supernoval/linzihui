//
//  PickDateView.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/4/19.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "PickDateView.h"

@implementation PickDateView

-(id)init
{
    if (self == [super init]) {
       
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        
        [self initViews];
        
        
    }
    
    return self;
    
}

-(void)setMindate:(NSDate *)mindate
{
    _picker.minimumDate = mindate;
    
}

-(void)setMaxdate:(NSDate *)maxdate
{
    _picker.maximumDate = maxdate;
    
}
-(void)initViews
{
    _view_pickDate = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 250)];
    
    _view_pickDate.backgroundColor = kBackgroundColor;
    
    [self addSubview:_view_pickDate];
    
    UIButton *sureButton = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 60, 0, 50, 40)];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    
    [sureButton setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [sureButton addTarget:self action:@selector(pickDate) forControlEvents:UIControlEventTouchUpInside];
    
    [_view_pickDate addSubview:sureButton];
    
    
    
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 50, 40)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(cancelPickDate) forControlEvents:UIControlEventTouchUpInside];
    [_view_pickDate addSubview:cancelButton];
    
    
    _picker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 50, ScreenWidth, 200)];
    
    _picker.datePickerMode = UIDatePickerModeDateAndTime;
    
    _picker.minimumDate = [NSDate date];
    
    [_view_pickDate addSubview:_picker];
}
-(void)pickDate
{
    
    
    NSDate *_date = _picker.date;
    
    if ([self.delegate respondsToSelector:@selector(didPickDate:)]) {
        
        
        [self.delegate didPickDate:_date];
        
        
    }
    
    [self dimissPickView];
    
    
}

-(void)cancelPickDate
{
    [self dimissPickView];
    
}


-(void)dimissPickView
{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        _view_pickDate.frame = CGRectMake(0, ScreenHeight - 250, ScreenWidth, 250);
        
        
    }completion:^(BOOL finished) {
    
        
        [self removeFromSuperview];
        
    }];
    
    
    
    
}
-(void)showPickView
{
    [UIView animateWithDuration:0.5 animations:^{
        
        _view_pickDate.frame = CGRectMake(0, ScreenHeight - 250, ScreenWidth, 250);
        
        
    }];
}


@end
