//
//  PingJiaVC.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/5/7.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "PingJiaVC.h"

@interface PingJiaVC ()
{
    UIControl *control;
}
@end

@implementation PingJiaVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title= @"评价";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.starView.clipsToBounds = YES;

    
    

    
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self.starView];
    
    if (point.x < 150 && point.x > 0) {
        
   
        
        self.starView.frame = CGRectMake(self.starView.frame.origin.x, self.starView.frame.origin.y, point.x, 30);
        
        NSLog(@"%.2f,y:%.2f",point.x,point.y);
        
    }
    
    
    
    
}
-(void)touchcontrol
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)summit:(id)sender {
    
    
    
}
@end
