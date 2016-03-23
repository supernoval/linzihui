//
//  MygroupListTVC.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/15.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "MygroupListTVC.h"
#import "ChatViewController.h"
#import "ApplyJoinGroupViewController.h"


@interface MygroupListTVC ()
{
    NSMutableArray *_groupListArray;
    
}
@end

@implementation MygroupListTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_isNearGroup) {
        
        self.title = @"邻近群组";
        
    }
    else
    {
         self.title = @"群聊";
    }
    _groupListArray = [[NSMutableArray alloc]init];
    
   
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeGroupNameNoti:) name:kChangeGroupSubTitleNoti object:nil];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [self getGroupList];
    
}

-(void)changeGroupNameNoti:(NSNotification*)note
{
    [self getGroupList];
    
}
- (void)getGroupList
{
    
    
    if (_isNearGroup) {
        
        
        [self getNearGroups];
        
    }
    else
    {
        [self getMyGroups];
        
    }
   
    
}

-(void)getNearGroups
{
    [BmobHelper getNearGroupList:^(NSArray *array) {
       
        if (array) {
            
            [_groupListArray removeAllObjects];
            
            [_groupListArray addObjectsFromArray:array];
            
            
            [self.tableView reloadData];
        }
        
        
    }];
}

-(void)getMyGroups
{
    [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsListWithCompletion:^(NSArray *groups, EMError *error) {
        
        if (!error && groups) {
            
            [BmobHelper getGroupListInfo:groups results:^(NSArray *array) {
                
                if (array) {
                    
                    [_groupListArray removeAllObjects];
                    
                    [_groupListArray addObjectsFromArray:array];
                    
                    
                    [self.tableView reloadData];
                    
                    
                }
            }];
            
            
            
            
        }
    } onQueue:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60.0;
    
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
        
         GroupChatModel *onegroup  = [_groupListArray objectAtIndex:indexPath.section];
        
        UIImageView *headImageView = (UIImageView*)[cell viewWithTag:100];
        
        [headImageView sd_setImageWithURL:[NSURL URLWithString:onegroup.groupHeadImage] placeholderImage:kDefaultHeadImage];
        
        UILabel *nameLabel = (UILabel*)[cell viewWithTag:101];
        UILabel *distanceLabel = (UILabel*)[cell viewWithTag:102];
        
        if (_isNearGroup) {
            
            distanceLabel.hidden = NO;
            
//            BmobGeoPoint *location = [onegroup.location ]
//            CGFloat latitude = [[onegroup.location :@"latitude"]floatValue];
            
            
            
            distanceLabel.text = [CommonMethods distanceStringWithLatitude:onegroup.location.latitude longitude:onegroup.location.longitude];
            
            
        }
        else
        {
            distanceLabel.hidden = YES;
            
        }
       
        
        
//        [headImageView sd_setImageWithURL:[NSURL URLWithString:oneModel.headImageURL] placeholderImage:kDefaultHeadImage];
        
        nameLabel.text = onegroup.subTitle;
        
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
     GroupChatModel *selectedGroup = [_groupListArray objectAtIndex:indexPath.section];
    
    if (_isNearGroup) {
        
        
        NSArray *members = selectedGroup.members;
        
        BOOL isMember = NO;
        
        BmobUser *currentUser = [BmobUser getCurrentUser];
        
        NSString *currentUsername = currentUser.username;
        
        if ([currentUsername isEqualToString:selectedGroup.owner_username]) {
            
            
            isMember = YES;
            
            
        }
        else
        {
            
           for (NSDictionary *dict in members) {
            
              
            NSString *username = [dict objectForKey:@"username"];
            
              if ([currentUsername isEqualToString:username]) {
                  
                  isMember = YES;
                  
              }
            
            }
        }
        
        if (isMember) {
            
            
             [self chatWithgroupModel:selectedGroup];
        }
        else
        {
            ApplyJoinGroupViewController *_applyJoinGroupVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ApplyJoinGroupViewController"];
            
            _applyJoinGroupVC.groupModel = selectedGroup;
            
            [self.navigationController pushViewController:_applyJoinGroupVC animated:YES];
        }
       
        
    }
    else
    {
       
        
        [self chatWithgroupModel:selectedGroup];
        
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
  

    
    
}

-(void)chatWithgroupModel:(GroupChatModel*)selectedGroup
{
    EMError *error = nil;
    
    EMGroup *group = [[EaseMob sharedInstance].chatManager fetchGroupInfo:selectedGroup.groupId error:&error];
    
    if (error) {
        
        [CommonMethods showDefaultErrorString:error.description];
        
        return;
        
    }
    
    ChatViewController *chatController = [[ChatViewController alloc] initWithChatter:selectedGroup.groupId isGroup:YES];
    chatController.title = selectedGroup.subTitle;
    chatController.subTitle = selectedGroup.subTitle;
    chatController.hidesBottomBarWhenPushed = YES;
    chatController.group = group ;
    chatController.groupHeadImageURL = selectedGroup.groupHeadImage;
    
    [self.navigationController pushViewController:chatController animated:YES];
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter ]removeObserver:self name:kChangeGroupSubTitleNoti object:nil];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
