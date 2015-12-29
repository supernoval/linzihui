//
//  ChatSettingTVC.h
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/15.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "BaseTableViewController.h"

@interface ChatSettingTVC : BaseTableViewController


@property (nonatomic,strong) EMGroup *group;
@property (nonatomic,strong ) NSString *subTitle;
@property (nonatomic,strong) GroupChatModel *model;
@property (nonatomic,strong) NSString *groupHeadImage;



@property (weak, nonatomic) IBOutlet UIView *footerView;

@property (weak, nonatomic) IBOutlet UIButton *quiteButton;
- (IBAction)quiteAction:(id)sender;

@end
