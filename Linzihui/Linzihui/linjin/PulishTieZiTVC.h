//
//  PulishTieZiTVC.h
//  Linzihui
//
//  Created by ZhuHaikun on 16/6/1.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "BaseTableViewController.h"
#import "BaseViewController.h"
#import "AddPhotoView.h"

@interface PulishTieZiTVC :BaseViewController


@property (nonatomic,strong) NSString *groupId;

@property (weak, nonatomic) IBOutlet UITextField *titleTF;
@property (weak, nonatomic) IBOutlet UILabel *placelabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTV;
@property (weak, nonatomic) IBOutlet UIView *buttonsView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstant;


@property (weak, nonatomic) IBOutlet AddPhotoView *addphotoView;
- (IBAction)publish:(id)sender;

@end
