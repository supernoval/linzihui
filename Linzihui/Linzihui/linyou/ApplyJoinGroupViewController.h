//
//  ApplyJoinGroupViewController.h
//  Linzihui
//
//  Created by ZhuHaikun on 16/3/4.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "BaseTableViewController.h"
#import "GroupChatModel.h"

@interface ApplyJoinGroupViewController : BaseTableViewController

@property (nonatomic) GroupChatModel *groupModel;


@property (nonatomic) NSString *groupId;

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@property (weak, nonatomic) IBOutlet UILabel *header;

@property (weak, nonatomic) IBOutlet UILabel *memberNum;
@property (weak, nonatomic) IBOutlet UILabel *groupDes;

@property (weak, nonatomic) IBOutlet UIView *footerView;

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;




- (IBAction)applyJoin:(id)sender;



@end
