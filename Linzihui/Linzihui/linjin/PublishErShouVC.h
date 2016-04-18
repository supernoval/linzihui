//
//  PublishErShouVC.h
//  Linzihui
//
//  Created by ZhuHaikun on 16/3/28.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "BaseViewController.h"
#import "AddPhotoView.h"
#import "ErShouTypeTVC.h"
#import <CoreLocation/CoreLocation.h>
#import "ErShouListTVC.h"


@interface PublishErShouVC : BaseViewController

@property (nonatomic,assign) BOOL isEdited;

@property (nonatomic,strong) ErShouModel *editeModel;

@property (weak, nonatomic) IBOutlet UITextView *desTextView;

@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;

@property (weak, nonatomic) IBOutlet AddPhotoView *addPhotoView;

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIButton *typeButton;

- (IBAction)typeAction:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *priceTextField;

@end
