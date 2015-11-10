//
//  EditPhotoViewController.h
//  macaics
//
//  Created by gao dong  qq7693517 on 13-7-4.
//  Copyright (c) 2013年 com.hairbobo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol EditPhotoViewDelegate <NSObject>

-(void)doneEditeUpLoadPhoto:(UIImage*)photo;


@end
@class STScratchView;
@interface EditPhotoViewController : UIViewController{
    
}

@property(nonatomic,weak) id <EditPhotoViewDelegate> delegate;

@property (weak, nonatomic) UIImage *sourseImg;

@property ( nonatomic)  STScratchView *scratchView;
- (IBAction)cancel:(id)sender;
- (IBAction)doneAction:(id)sender;

@end
