//
//  MygroupListTVC.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/15.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "MygroupListTVC.h"
#import "ChatViewController.h"


@interface MygroupListTVC ()
{
    NSMutableArray *_groupListArray;
    
}
@end

@implementation MygroupListTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"群聊";
    _groupListArray = [[NSMutableArray alloc]init];
    
    [self getGroupList];
    
    
}

- (void)getGroupList
{
    [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsListWithCompletion:^(NSArray *groups, EMError *error) {
        
        if (!error && groups) {
            
            [_groupListArray addObjectsFromArray:groups];
            
            [self.tableView reloadData];
            
            
        }
    } onQueue:nil];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 1;
    
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *blankView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    
    blankView.backgroundColor = [UIColor clearColor];
    
    return blankView;
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _groupListArray.count;
    
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    
    return 1;
    
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellId"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        UIImageView *headImageView = (UIImageView*)[cell viewWithTag:100];
        
        UILabel *nameLabel = (UILabel*)[cell viewWithTag:101];
        
        EMGroup *onegroup  = [_groupListArray objectAtIndex:indexPath.section];
        
        
//        [headImageView sd_setImageWithURL:[NSURL URLWithString:oneModel.headImageURL] placeholderImage:kDefaultHeadImage];
        
        nameLabel.text = onegroup.groupSubject;
        
//        if (!oneModel.nickName) {
//            
//            nameLabel.text = oneModel.username;
//            
//            
//        }
        
        
//        if (oneModel.hadSelected) {
//            
//            cell.accessoryType = UITableViewCellAccessoryCheckmark;
//        }
//        else
//        {
//            cell.accessoryType = UITableViewCellAccessoryNone;
//            
//        }
        
        
    });
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
  
    EMGroup *selectedGroup = [_groupListArray objectAtIndex:indexPath.section];
    
    
    ChatViewController *chatController = [[ChatViewController alloc] initWithChatter:selectedGroup.groupId isGroup:YES];
    chatController.title = selectedGroup.groupSubject;
    
    chatController.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:chatController animated:YES];
    
   
    
    
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
