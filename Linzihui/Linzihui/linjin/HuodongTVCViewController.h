//
//  HuodongTVCViewController.h
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/26.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "BaseTableViewController.h"
#import "SDPhotoGroup.h"

@interface HuodongTVCViewController : BaseTableViewController


@property (nonatomic,assign) BOOL isFromYaoYiYao;

@property (nonatomic,strong)  NSMutableArray *dataSource;

@property (nonatomic,assign) BOOL isShowGroupActivity;
@property (nonatomic,weak)    NSString *groupId;





@end
