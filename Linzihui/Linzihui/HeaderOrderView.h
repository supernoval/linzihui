//
//  HeaderOrderView.h
//  Linzihui
//
//  Created by ZhuHaikun on 16/4/5.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "ErShouTypeTVC.h"
#import "ErShouListTVC.h"

@protocol HeaderOrderDelegate <NSObject>

-(void)selectedType:(NSString*)type;

-(void)changeDistance;


@end
@interface HeaderOrderView : UIView
{
 
    
}

@property (nonatomic,strong) UIButton *distanceButton;


@property (nonatomic,strong) UIButton *orderButton;

@property (nonatomic,weak) ErShouListTVC *listTVC;

@property (nonatomic,weak) id <HeaderOrderDelegate> delegate;


-(id)initWithFrame:(CGRect)frame;


@end
