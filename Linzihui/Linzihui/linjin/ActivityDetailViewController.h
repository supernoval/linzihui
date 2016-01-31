//
//  ActivityDetailViewController.h
//  Linzihui
//
//  Created by ZhuHaikun on 16/1/28.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef void (^DetailBlock)(NSMutableArray*imagesArray,NSString*detail);


@interface ActivityDetailViewController : BaseViewController
{
    DetailBlock _block;
    
}


-(void)setBlock:(DetailBlock)block;


@property (nonatomic) NSString *detailStr;
@property (nonatomic)  NSMutableArray *image_list;
@property (nonatomic) NSArray *photoURLs;


@property (weak, nonatomic) IBOutlet UITextView *detailTV;

@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;

@property (weak, nonatomic) IBOutlet UIView *photoView;

- (IBAction)showPicker:(id)sender;



@end
