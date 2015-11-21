//
//  PullView.h
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/14.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConstantsHeaders.h"

static CGFloat pullViewWith = 150;
static CGFloat pullViewHeight = 225;

@protocol PullViewDelegate <NSObject>

-(void)didSelectedIndex:(NSInteger)index;

-(void)tapResgin;


@end

@interface PullView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    
    
    
    UIControl *_control;
    
    
    
    
}
@property (nonatomic,strong) UITableView *listTableView;
@property (nonatomic,assign) id<PullViewDelegate> delegate;



-(id)initWithFrame:(CGRect)frame;

@end
