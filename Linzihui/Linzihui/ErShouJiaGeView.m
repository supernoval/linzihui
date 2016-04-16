//
//  ErShouJiaGeView.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/4/16.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "ErShouJiaGeView.h"

@implementation ErShouJiaGeView

-(id)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        
    }
    
    return self;
    
}

-(void)awakeFromNib
{
    UIControl *control = [[UIControl alloc]initWithFrame:self.frame];
    
    [control addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    control.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self insertSubview:control atIndex:0];
    
    self.priceTF.delegate = self;
    
    self.msgTF.delegate= self;
    
    
    
//    [self sendSubviewToBack:]
}

-(void)remove
{
    [self removeFromSuperview];
    
}

- (IBAction)okAction:(id)sender {
    
    
    if (_msgTF.text.length == 0) {
        
        [CommonMethods showDefaultErrorString:@"请输入回复内容"];
        
        
        return;
        
        
    }
    
    if (_priceTF.text.length == 0) {
        
        [CommonMethods showDefaultErrorString:@"请输入价格"];
        
        return;
        
    }
    
    
    if ([self.delegate respondsToSelector:@selector(didInputMSGandPrice:price:)]) {
        
        [self.delegate didInputMSGandPrice:_msgTF.text price:_priceTF.text];
        
        
        
    }
    
    
    [self removeFromSuperview];
    
}

- (IBAction)cancelAction:(id)sender {
    
    [self removeFromSuperview];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    
    return YES;
    
}
@end
