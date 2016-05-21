//
//  PublishShangPinVC.h
//  Linzihui
//
//  Created by ZhuHaikun on 16/5/3.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "BaseViewController.h"
#import "ShangJiaModel.h"

@interface PublishShangPinVC : BaseViewController



@property (weak, nonatomic) IBOutlet UIButton *uploadPhotoButton;


@property (nonatomic,strong) ShangJiaModel *model;

- (IBAction)uploadPhotoAction:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *shangpinnameLabel;

@property (weak, nonatomic) IBOutlet UITextView *shangpinDesTV;


@property (weak, nonatomic) IBOutlet UIButton *photo_1_button;


@property (weak, nonatomic) IBOutlet UIButton *photo_2_button;

@property (weak, nonatomic) IBOutlet UIButton *photo_3_button;


- (IBAction)photo_1_action:(id)sender;

- (IBAction)photo_2_action:(id)sender;

- (IBAction)photo_3_action:(id)sender;



@property (weak, nonatomic) IBOutlet UITextField *shangpinpriceLabel;

- (IBAction)okAction:(id)sender;



@end
