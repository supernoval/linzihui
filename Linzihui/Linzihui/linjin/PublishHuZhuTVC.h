//
//  PublishHuZhuTVC.h
//  Linzihui
//
//  Created by ZhuHaikun on 16/4/19.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "BaseTableViewController.h"
#import "AddPhotoView.h"
#import "BaseViewController.h"
#import <BmobSDK/Bmob.h>
#import "PickDateView.h"

@interface PublishHuZhuTVC : BaseViewController<PickDateDelegate>


@property (weak, nonatomic) IBOutlet UITextView *contentTF;


@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;

@property (weak, nonatomic) IBOutlet AddPhotoView *photosView;

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (weak, nonatomic) IBOutlet UITextField *jinErTF;

- (IBAction)pickTimeAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *pickTimeButton;



@end
