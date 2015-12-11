//
//  CreateChatRoomTVC.h
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/14.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "BaseTableViewController.h"

typedef void (^CreateChatRoomBlock)(BOOL success,EMGroup *group);


@interface CreateChatRoomTVC : BaseTableViewController
{
    CreateChatRoomBlock _block;
    
}

-(void)setblock:(CreateChatRoomBlock)block;



@end
