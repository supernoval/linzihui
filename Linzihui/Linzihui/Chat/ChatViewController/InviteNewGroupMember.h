//
//  InviteNewGroupMember.h
//  Linzihui
//
//  Created by ZhuHaikun on 15/12/12.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "BaseTableViewController.h"

@interface InviteNewGroupMember : BaseTableViewController

@property (nonatomic) EMGroup *group;

@property (nonatomic) NSInteger type;  // 0 建群   1活动邀请
@property (nonatomic) BmobObject *huodong;
@property (nonatomic) NSString *message;
@property (nonatomic) NSString *messageTitle;



@end
