//
//  ShangPinDetailViewController.h
//  Linzihui
//
//  Created by ZhuHaikun on 16/5/21.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "BaseViewController.h"
#import "SDPhotoGroup.h"
#import "ShangPinModel.h"


@interface ShangPinDetailViewController : BaseViewController


@property (nonatomic,strong) ShangPinModel *model;

@property (weak, nonatomic) IBOutlet UIImageView *shangpinimageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailDes;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraints;



@property (weak, nonatomic) IBOutlet SDPhotoGroup *photoView;


@end
