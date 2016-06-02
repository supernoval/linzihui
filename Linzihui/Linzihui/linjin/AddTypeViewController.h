//
//  AddTypeViewController.h
//  Linzihui
//
//  Created by ZhuHaikun on 16/6/2.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "BaseViewController.h"

@interface AddTypeViewController : BaseViewController


@property (nonatomic,strong) BmobObject *QunOB;

@property (weak, nonatomic) IBOutlet UITextField *typenameTF;

- (IBAction)summitAction:(id)sender;

@end
