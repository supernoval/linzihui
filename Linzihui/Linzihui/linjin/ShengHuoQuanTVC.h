//
//  ShengHuoQuanTVC.h
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/18.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ShenghuoQuanCell.h"
#import "CommentCell.h"

@interface ShengHuoQuanTVC : BaseTableViewController


@property (nonatomic,assign) NSInteger isShuRenQuan;  // 0生活圈   1 熟人圈 2相册自己   3相册别人的 4商家动态
@property (nonatomic)  NSString *username;
@property (nonatomic) NSArray *myFollows;  //我关注的人的 usernames




- (IBAction)publishAction:(id)sender;



@end
