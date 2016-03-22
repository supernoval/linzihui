//
//  ShengHuoQuanDetail.h
//  Linzihui
//
//  Created by ZhuHaikun on 16/3/22.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "BaseViewController.h"

@interface ShengHuoQuanDetail : BaseViewController


@property (nonatomic) NSString *detailText;

@property (weak, nonatomic) IBOutlet UITextView *detailLabel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailLabelHeightConstant;



@end
