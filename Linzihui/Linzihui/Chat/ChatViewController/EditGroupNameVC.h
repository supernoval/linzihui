//
//  EditGroupNameVC.h
//  Linzihui
//
//  Created by ZhuHaikun on 15/12/12.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^SetName)(NSString *groupName);
@interface EditGroupNameVC : BaseViewController
{
    SetName _block;
    
}

@property (nonatomic) NSString *groupSubTitle;

@property (nonatomic) NSString *groupId;

-(void)setBlock:(SetName)block;

@property (weak, nonatomic) IBOutlet UITextField *editTF;

- (IBAction)saveEdited:(id)sender;

@end
