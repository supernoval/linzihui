//
//  ChangePersonInfoVC.h
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/8.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "BaseViewController.h"
#import "ModelHeader.h"

@interface ChangePersonInfoVC : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *myTextField;

- (IBAction)saveAction:(id)sender;
@property (nonatomic,strong) NSString *changeTitle;
@property (nonatomic,strong) UserModel *model;
@property (nonatomic,strong) NSString *value;
@property (nonatomic,strong) NSString *key;



@end
