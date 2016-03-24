//
//  SetNewGroupNameImageVC.h
//  Linzihui
//
//  Created by ZhuHaikun on 16/3/24.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CreateChatRoomTVC.h"

@interface SetNewGroupNameImageVC : BaseViewController



@property (nonatomic,assign) CreateChatRoomBlock temBlock;

@property (nonatomic) NSMutableArray *buddyList;


@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UIButton *headImageButton;


- (IBAction)changeHeadAction:(id)sender;


- (IBAction)createAction:(id)sender;



@end
