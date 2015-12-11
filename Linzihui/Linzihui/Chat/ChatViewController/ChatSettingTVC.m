//
//  ChatSettingTVC.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/15.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "ChatSettingTVC.h"
#import "ShowQRViewController.h"
#import "GroupMemberTVC.h"
#import "InviteNewGroupMember.h"
#import "EditGroupNameVC.h"


@interface ChatSettingTVC ()
{
    
    NSArray *_titles;
    
}
@end

@implementation ChatSettingTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"聊天信息";
    
    
    self.footerView.frame = CGRectMake(0, 0, ScreenWidth, 100);
    
    
    _titles = @[@"群组成员",@"邀请好友",@"群聊名称",@"群二维码"];
    
    
    if ([_group.owner isEqualToString:[BmobHelper getCurrentUserModel].username]) {
        
        [_quiteButton setTitle:@"解散该群" forState:UIControlStateNormal];
        
    }

}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 44;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    
    
    return _titles.count;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellId"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        UIImageView *imageView = (UIImageView*)[cell viewWithTag:100];
        
        UILabel *titleLabel = (UILabel*)[cell viewWithTag:101];
        
        
        NSString *title = [_titles objectAtIndex:indexPath.section];
        
        titleLabel.text = title;
        
        
        imageView.image = [UIImage imageNamed:@"erweima"];
        
        if (indexPath.section == 3) {
            
            imageView.hidden = NO;
            
         
            
            
            
        }
        else
        {
            imageView.hidden = YES;
            
        }
        
    });
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case 0:
        {
            GroupMemberTVC *_groupMember = [[GroupMemberTVC alloc]initWithStyle:UITableViewStylePlain];
            
            _groupMember.group = _group;
            
            [self.navigationController pushViewController:_groupMember animated:YES];
            
            
        }
            break;
        case 1:
        {
            InviteNewGroupMember *_invite = [[InviteNewGroupMember alloc]initWithStyle:UITableViewStylePlain];
            
            
            _invite.group = _group;
            
            [self.navigationController pushViewController:_invite animated:YES];
            
            
        }
            break;
        case 2:
        {
            EditGroupNameVC *_editGroupVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EditGroupNameVC"];
            
            _editGroupVC.groupSubTitle = _subTitle;
            
            _editGroupVC.groupId = _group.groupId;
            
            
            [self.navigationController pushViewController:_editGroupVC animated:YES];
        }
            break;
        case 3:
        {
            ShowQRViewController *_QRVC = [[ShowQRViewController alloc]init];
            
            _QRVC.qrString = [NSString stringWithFormat:@"g%@",_group.groupId];
            
            
            [self.navigationController pushViewController:_QRVC animated:YES];
            
            
        }
            break;
            
            
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}


- (IBAction)quiteAction:(id)sender {
    
    
  
    
    BmobUser *CurrentUser = [BmobUser getCurrentUser];
    
    if ([_group.owner isEqualToString:CurrentUser.username]) {
        
        
        EMError *error = nil;
        
        [[EaseMob sharedInstance].chatManager destroyGroup:_group.groupId error:&error];
        
        if (!error) {
            
            NSLog(@"解散成功");
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
        else
        {
            NSLog(@"解散 error:%@",error);
            
            
        }
        
//        [[EaseMob sharedInstance].chatManager  asyncDestroyGroup:_group.groupId completion:^(EMGroup *group, EMGroupLeaveReason reason, EMError *error) {
//        
//            if (!error) {
//                
//                NSLog(@"解散成功");
//            }
//            else
//            {
//                NSLog(@"解散 error:%@",error);
//                
//                
//            }
//            
//        } onQueue:nil];
        
        
    }
    else
    {
        
        [[EaseMob sharedInstance].chatManager asyncLeaveGroup:_group.groupId completion:^(EMGroup *group, EMGroupLeaveReason reason, EMError *error) {
        
            if (!error) {
               
                NSLog(@"退出群成功");
                
              
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }
            else
            {
                NSLog(@"leave group Error:%@",error);
                
            }
        } onQueue:nil];
        
        
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
