//
//  InviteNewGroupMember.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/12/12.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "InviteNewGroupMember.h"

@interface InviteNewGroupMember ()
{
    NSArray *_friendList;
    
    
}
@end

@implementation InviteNewGroupMember

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.title = @"邀请好友";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self getFriendList];
    
    
    
}

-(void)getFriendList
{
 
    
    [BmobHelper getBmobBuddyUsers:^(NSArray *array) {
        
        
        if (array) {
            
            
            NSArray *ocup = [_group occupants];
            
    
            
            //去掉已在群里的好友
            for (UserModel *_model in array) {
                
              
                
                for (NSString *username in ocup) {
                    
                    
                    
                    if ([username isEqualToString:_model.username]) {
                        
                        
                        _model.isIngroup = YES;
                        
                    }
                    
               
                    
                }
            }
   
            
            _friendList = array;
            
            [self.tableView reloadData];
            
            
            
            
            
            
        }
    }];
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _friendList.count;
    
    
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 5)];
    
    
    footer.backgroundColor = [UIColor clearColor];
    
    
    
    return footer;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    
    return 5;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellId"];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellId"];
        
        UIImageView *headimageView =[[UIImageView alloc]initWithFrame:CGRectMake(15, 2, 40, 40)];
        headimageView.tag = 99;
        
        [cell.contentView addSubview:headimageView];
        
        
        UILabel *namLabel = [CommonMethods LabelWithText:nil andTextAlgniment:NSTextAlignmentLeft andTextColor:[UIColor blackColor] andTextFont:FONT_15 andFrame:CGRectMake(60, 0, 200, 44)];
        
        namLabel.tag = 100;
        
        [cell.contentView addSubview:namLabel];
        
        UIButton *sendButton = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 80, 7, 60, 30)];
        
        [sendButton setTitle:@"发送邀请" forState:UIControlStateNormal];
        
        [sendButton setTitleColor:kBlueBackColor forState:UIControlStateNormal];
        
        sendButton.titleLabel.font = FONT_15;
        
        
        [sendButton setTitleColor:kHightLightColor forState:UIControlStateHighlighted];
        
        
        sendButton.tag = 101;
        
       
        
        [cell.contentView addSubview:sendButton];
        
        
        
    }
    
    cell.contentView.tag = indexPath.section;
    
    UserModel *_userModel = [_friendList objectAtIndex:indexPath.section];

    UIImageView *headImageView = (UIImageView*)[cell viewWithTag:99];
    
    UILabel *namlabel = (UILabel*)[cell viewWithTag:100];
    
    
    UIButton *sender = (UIButton*)[cell viewWithTag:101];
    
    [sender addTarget:self action:@selector(sendInvite:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [headImageView sd_setImageWithURL:[NSURL URLWithString:_userModel.headImageURL] placeholderImage:kDefaultHeadImage];
    
    namlabel.text = _userModel.nickName;
    
    if (!_userModel.nickName) {
        
        namlabel.text = _userModel.username;
        
    }
    
    
    if (_userModel.isIngroup) {
        
        sender.hidden = YES;
    }
    else
    {
        sender.hidden = NO;
        
    }
    
    
    return cell;
}



-(void)sendInvite:(UIButton*)sender
{
    
    
    
    UserModel *_userModel = [_friendList objectAtIndex:[sender superview].tag];
    
    [[EaseMob sharedInstance].chatManager asyncAddOccupants:@[_userModel.username] toGroup:_group.groupId welcomeMessage:@"邀请加入群组" completion:^(NSArray *occupants, EMGroup *group, NSString *welcomeMessage, EMError *error) {
       
        if (!error) {
            
            [CommonMethods showDefaultErrorString:@"邀请发送成功"];
            
        }
        
        
    } onQueue:nil];
    
    
    
    
    
    
}





@end
