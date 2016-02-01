//
//  DetailViewController.h
//  Linzihui
//
//  Created by ZhuHaikun on 16/2/1.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "BaseViewController.h"
#import "SDPhotoGroup.h"

@interface DetailViewController : BaseViewController


@property (weak, nonatomic) IBOutlet UITextView *detailTV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailHeight;

@property (weak, nonatomic) IBOutlet SDPhotoGroup *photoView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoViewHeight;



@end
