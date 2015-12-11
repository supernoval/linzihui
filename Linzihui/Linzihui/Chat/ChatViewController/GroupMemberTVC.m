//
//  GroupMemberTVC.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/12/12.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "GroupMemberTVC.h"
#import "MyConversation.h"

@interface GroupMemberTVC ()
{
    NSArray *_friendList;
    
    
}
@end

@implementation GroupMemberTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"群组成员";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   
    
    
    [self getData];
    
}


-(void)getData
{
    NSArray *ocup = _group.occupants;
    
  
    [BmobHelper getGroupMembersInfo:ocup results:^(NSArray *arary) {
       
        if (arary) {
            
            _friendList = arary;
            
            [self.tableView reloadData];
            
        }
    }];
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 3)];
    
    footer.backgroundColor = [UIColor clearColor];
    
    
    return footer;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 3;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return _friendList.count;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellId"];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellId"];
        
        UIImageView *headimageView =[[UIImageView alloc]initWithFrame:CGRectMake(15, 2, 40, 40)];
        headimageView.tag = 99;
        
        [cell.contentView addSubview:headimageView];
        
        
        UILabel *namLabel = [CommonMethods LabelWithText:nil andTextAlgniment:NSTextAlignmentLeft andTextColor:[UIColor blackColor] andTextFont:FONT_15 andFrame:CGRectMake(60, 0, 200, 44)];
        
        namLabel.tag = 100;
        
        [cell.contentView addSubview:namLabel];
        
        
    }
    
    MyConversation *conver = [_friendList objectAtIndex:indexPath.section];
    
    
    UIImageView *headImageView = (UIImageView*)[cell viewWithTag:99];
    
    UILabel *namlabel = (UILabel*)[cell viewWithTag:100];
    
    
    [headImageView sd_setImageWithURL:[NSURL URLWithString:conver.headImageURL] placeholderImage:kDefaultHeadImage];
    
    
    namlabel.text = conver.nickName;
    
    if (!conver.nickName) {
        
        namlabel.text = conver.username;
        
    }
    
    
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}


@end
