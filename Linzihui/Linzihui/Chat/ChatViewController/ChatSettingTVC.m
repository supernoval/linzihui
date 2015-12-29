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
#import "PublishActivity.h"


@interface ChatSettingTVC ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    
    NSArray *_titles;
    
}
@end

@implementation ChatSettingTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"聊天信息";
    
    
    self.footerView.frame = CGRectMake(0, 0, ScreenWidth, 100);
    
    
    _titles = @[@"群组成员",@"邀请好友",@"群聊名称",@"群二维码",@"发布群活动",@"群聊头像"];
    
    
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
        
        
        
        
        if (indexPath.section == 3)
        {
            
            imageView.hidden = NO;
            
            imageView.image = [UIImage imageNamed:@"erweima"];
            
            
            
        }
        else if (indexPath.section == 5)
        {
            [imageView sd_setImageWithURL:[NSURL URLWithString:_groupHeadImage] placeholderImage:kDefaultHeadImage];
            
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
        case 4:
        {
            PublishActivity *_publish = [self.storyboard instantiateViewControllerWithIdentifier:@"PublishActivity"];
            
            _publish.groupId = _group.groupId;
            
            
            [self.navigationController pushViewController:_publish animated:YES];
            
            
        }
            break;
        case 5:
        {
            UIActionSheet *_pickActionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
            _pickActionSheet.delegate = self;
            
            
            [_pickActionSheet addButtonWithTitle:@"相册"];
            [_pickActionSheet addButtonWithTitle:@"照相"];
            
            [_pickActionSheet addButtonWithTitle:@"取消"];
            
            _pickActionSheet.cancelButtonIndex = 2;
            
//            _pickActionSheet.tag = photoActionSheetTag;
            
            [_pickActionSheet showInView:self.view];
            
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




#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (image) {
        
        
        image = [CommonMethods autoSizeImageWithImage:image];
        
        
        
    }
    
    [CommonMethods upLoadPhotos:@[image] resultBlock:^(BOOL success, NSArray *results) {
        
        NSString *url = [results firstObject];
        
        if (url) {
            
            _groupHeadImage = url;
            
            [self.tableView reloadData];
            
            BmobQuery *query = [BmobQuery queryWithClassName:kChatGroupTableName];
            
            [query whereKey:@"groupId" equalTo:_group.groupId];
            
            
            [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                
                if (!error && array.count > 0) {
                    
                    BmobObject *ob = [array firstObject];
                    
                    
                    [ob setObject:url forKey:@"groupHeadImage"];
                    
                    [ob updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                        
                        
                    }];
                    
                }
                
            }];
            
            
        }
       
        
    } ];
    
    
    
  
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    
    
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

        
        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 2:
                {
                    return;
                }
                    break;
                    
                    
                case 1: //相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 0: //相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
            }
        }
        else {
            if (buttonIndex == 1) {
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = NO;
        imagePickerController.sourceType = sourceType;
        imagePickerController.edgesForExtendedLayout = UIRectEdgeLeft;
        
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
