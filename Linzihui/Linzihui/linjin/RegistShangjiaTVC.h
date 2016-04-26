//
//  RegistShangjiaTVC.h
//  Linzihui
//
//  Created by ZhuHaikun on 16/4/26.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "BaseTableViewController.h"

@interface RegistShangjiaTVC : BaseTableViewController
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *photoButton;

- (IBAction)addPhotoAction:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *nameTF;

@property (weak, nonatomic) IBOutlet UITextField *addressTF;

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (weak, nonatomic) IBOutlet UITextField *yaoqingphoneNumTF;


@property (weak, nonatomic) IBOutlet UILabel *typeLabel;


@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;


@property (weak, nonatomic) IBOutlet UIButton *idOneButton;

- (IBAction)idOneAction:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *idTwoButton;

- (IBAction)idTwoAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *footerView;


@end
