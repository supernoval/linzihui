//
//  GongKaiQunVC.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/3/27.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "GongKaiQunVC.h"
#import "GongkaiqunCell.h"
#import "ApplyJoinGroupViewController.h"
#import "ChatViewController.h"


@interface GongKaiQunVC ()
{
    NSArray* _groups;
    
    
}
@end

@implementation GongKaiQunVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"公开的群";
    [self loadData];
    
    
    
}

-(void)loadData
{
    [BmobHelper  getPublicGroup:^(BOOL success, NSArray *groups) {
       
        if (success) {
            
            _groups = groups;
            
            [self.tableView reloadData];
            
        }
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return _groups.count;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    GongkaiqunCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GongkaiqunCell"];
    
     GroupChatModel *onegroup  = [_groups objectAtIndex:indexPath.section ];
    
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:onegroup.groupImage] placeholderImage:kDefaultHeadImage];
    
    cell.nameLabel.text = onegroup.subTitle;
    
    
    
    return cell;
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
 
        GroupChatModel *selectedGroup = [_groups objectAtIndex:indexPath.section ];
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
        
 


      [tableView deselectRowAtIndexPath:indexPath animated:YES];
    

    
        


            


    
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




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
