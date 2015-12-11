//
//  EditGroupNameVC.h
//  Linzihui
//
//  Created by ZhuHaikun on 15/12/12.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "BaseViewController.h"

@interface EditGroupNameVC : BaseViewController

@property (nonatomic) NSString *groupSubTitle;

@property (nonatomic) NSString *groupId;

@property (weak, nonatomic) IBOutlet UITextField *editTF;

- (IBAction)saveEdited:(id)sender;

@end
