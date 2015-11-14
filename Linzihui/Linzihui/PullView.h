//
//  PullView.h
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/14.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConstantsHeaders.h"

@protocol PullViewDelegate <NSObject>

-(void)didSelectedIndex:(NSInteger)index;


@end

@interface PullView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    UITapGestureRecognizer *_tap;
    
    
}
@property (nonatomic,strong) UITableView *listTableView;
@property (nonatomic,assign) id<PullViewDelegate> delegate;



-(id)initWithFrame:(CGRect)frame;

@end
