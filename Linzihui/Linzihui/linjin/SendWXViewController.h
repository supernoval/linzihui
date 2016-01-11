//
//  SendWXViewController.h
//  TXCar
//
//  Created by ZhuHaikun on 15/11/6.
//  Copyright © 2015年 BH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef  void (^SendWXBlock)(BOOL isSuccess ,id ob);



@interface SendWXViewController : BaseViewController
{
    SendWXBlock _block;
    
}

@property (nonatomic,assign)  NSInteger type; // 0熟人圈  1活动记录
@property (nonatomic) HuoDongModel *huodong; //活动



@property (nonatomic,assign ) BOOL isShuRenQuan;

@property (weak, nonatomic) IBOutlet UITextView *inputTextView;

@property (weak, nonatomic) IBOutlet UIView *photoView;
- (IBAction)photoButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *sayLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoViewHeightConstants;

-(void)setblock:(SendWXBlock)block;


@end
