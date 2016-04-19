//
//  PickDateView.h
//  Linzihui
//
//  Created by ZhuHaikun on 16/4/19.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@protocol PickDateDelegate <NSObject>

-(void)didPickDate:(NSDate*)date;


@end

@interface PickDateView : UIView
{
    UIView *_view_pickDate;
    UIDatePicker *_picker;
    
}

@property (nonatomic,assign)id <PickDateDelegate>delegate;

@property (nonatomic,strong) NSDate *mindate;
@property (nonatomic,strong) NSDate *maxdate;

-(id)init;

-(void)showPickView;



@end
