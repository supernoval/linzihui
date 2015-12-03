//
//  MineTableViewController.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/2.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "MineTableViewController.h"
#import "CommonMethods.h"
#import "ConstantsHeaders.h"
#import "ModelHeader.h"
#import "ChangePersonInfoVC.h"
#import "EditPhotoViewController.h"
#import "ShowQRViewController.h"


static NSInteger photoActionSheetTag = 99;

static NSInteger sextActionSheetTag  = 100;


@interface MineTableViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,EditPhotoViewDelegate,UIAlertViewDelegate>
{
    NSArray *_titlesArray;
    
    UserModel *_model;
    
    UIImage *temImage;
    
    UIImage *showImage;
    UIAlertView *_logoutAlert;
    
    
    
    
    
}
@end

@implementation MineTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    _titlesArray = [self titlesArray];

    _model = [[UserModel alloc]init];
    
    self.footerView.frame = CGRectMake(0, 0, ScreenWidth, 120);
    
    
    

    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self requestPerSonInfo];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}


-(NSArray *)titlesArray
{
    NSArray *titles = @[@"头像",@"昵称",@"邻号",@"邀请码",@"二维码名片",@"我的地址",@"性别",@"地区",@"个性签名"];
    
    return titles;
    
}


#pragma mark - 请求个人信息 
-(void)requestPerSonInfo
{
    BmobQuery *queryPersonInfo = [BmobQuery queryForUser];
    
    BmobUser *currentUser = [BmobUser getCurrentUser];
    
    [queryPersonInfo whereKey:@"objectId" equalTo:currentUser.objectId];
    
    
    
    [BmobHelper queryWithObject:queryPersonInfo model:_model result:^(BOOL success, id object) {
        
        if (success) {
            
            [self.tableView reloadData];
            
        }
    }];
    
  
}



#pragma mark -  UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
    
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 5)];
    
    footerView.backgroundColor = [UIColor clearColor];
    
    return footerView;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    switch (section) {
        case 0:
        {
            return 6;
        }
            break;
        case 1:
        {
            
            return 3;
        }
            
            break;
            
            
        default:
            break;
    }
    
    return 0;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
    


}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section == 0) {
        
        
        if (indexPath.row == 0 || indexPath.row == 4) {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HeadPhotoCell"];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UILabel *titleLabel = (UILabel *)[cell viewWithTag:100];
                
                UIImageView *imageView = (UIImageView*)[cell viewWithTag:101];
                
                titleLabel.text = [_titlesArray objectAtIndex:indexPath.row];
                
                
                if (indexPath.row == 0) {
                    
                    [imageView sd_setImageWithURL:[NSURL URLWithString:_model.headImageURL] placeholderImage:kDefaultHeadImage];
                }
                else
                {
                    imageView.image = [UIImage imageNamed:@"erweima"];
                    
                    
                }
                
                
                
                
                
            });
            
            return cell;
            
        }
        else
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contentLabelCell"];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UILabel *titleLabel = (UILabel *)[cell viewWithTag:100];
                
                 UILabel *contentLabel = (UILabel *)[cell viewWithTag:101];
                
                titleLabel.text = [_titlesArray objectAtIndex:indexPath.row];
                
                
                switch (indexPath.row) {
                    case 1: //昵称
                    {
                        if (_model.nickName) {
                            
                             contentLabel.text = _model.nickName;
                        }
                       
                        
                    }
                        break;
                    case 2:  //林子号
                    {
                        contentLabel.text = _model.username;
                        
                    }
                        break;
                    case 3: //邀请码
                    {
                        NSString *yaoqingma = [_model.objectId substringToIndex:4];
                        
                        contentLabel.text = yaoqingma;
                        
                        
                    }
                        break;
                 
                        
                        
                        
                    default:
                        break;
                }
            });
            
            
            return cell;
        }
   
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contentLabelCell"];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UILabel *titleLabel = (UILabel *)[cell viewWithTag:100];
            
            UILabel *contentLabel = (UILabel *)[cell viewWithTag:101];
            
            titleLabel.text = [_titlesArray objectAtIndex:indexPath.row + 6];
            
            
            switch (indexPath.row) {
                case 0: //性别
                {
                  
                        
                        if (_model.sex == 0) {
                            
                            contentLabel.text = @"女";
                            
                         }
                        
                        if (_model.sex == 1) {
                            
                            contentLabel.text = @"男";
                            
                         }
                    
                }
                    break;
                case 1: //地区
                {
                    
                }
                    break;
                case 2:  //个性签名
                {
                    if (_model.selfComment) {
                        
                        contentLabel.text = _model.selfComment;
                        
                    }
                    
                }
                    break;
                    
                    
                default:
                    break;
            }
            
        });

        
        return cell;
    }
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        switch (indexPath.row) {
            case 0:  //修改头像
            {
                UIActionSheet *_pickActionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
                _pickActionSheet.delegate = self;
                
                
                [_pickActionSheet addButtonWithTitle:@"相册"];
                [_pickActionSheet addButtonWithTitle:@"照相"];
                
                [_pickActionSheet addButtonWithTitle:@"取消"];
                
                _pickActionSheet.cancelButtonIndex = 2;
                
                _pickActionSheet.tag = photoActionSheetTag;
                
                [_pickActionSheet showInView:self.view];
            }
                break;
            case 1:  //昵称
            {
                ChangePersonInfoVC *_changeInfoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePersonInfoVC"];
                
                _changeInfoVC.changeTitle = @"修改昵称";
                
                _changeInfoVC.key = @"nickName";
           
               
                _changeInfoVC.hidesBottomBarWhenPushed = YES;
                
           
                _changeInfoVC.value = _model.nickName;
                
                [self.navigationController pushViewController:_changeInfoVC animated:YES];
                
                
                
            }
                break;
            case 2:  //邻子号
            {
                
            }
                break;
            case 3: //邀请码
            {
                
            }
                break;
            case 4: //二维码名片
            {
                ShowQRViewController *_showQRVC = [[ShowQRViewController alloc]init];
                
                _showQRVC.hidesBottomBarWhenPushed = YES;
                
                _showQRVC.qrString = [NSString stringWithFormat:@"p%@",_model.username];
                
                
                
                [self.navigationController pushViewController:_showQRVC animated:YES];
                
            }
                break;
                
            case 5:  //我的地址
            {
                
            }
                break;
        
                
                
            default:
                break;
        }
     }
    
    if (indexPath.section == 1) {
        
        
        switch (indexPath.row) {
            case 0: //性别
            {
                UIActionSheet *_pickActionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
                _pickActionSheet.delegate = self;
                
                [_pickActionSheet addButtonWithTitle:@"男"];
                [_pickActionSheet addButtonWithTitle:@"女"];
                
                [_pickActionSheet addButtonWithTitle:@"取消"];
                
                _pickActionSheet.cancelButtonIndex = 2;
                
                _pickActionSheet.tag = sextActionSheetTag;
                
                [_pickActionSheet showInView:self.view];
            }
                break;
            case 1:  //地区
            {
                
            }
                break;
            case 2:  //个性签名
            {
                ChangePersonInfoVC *_changeInfoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePersonInfoVC"];
                
                _changeInfoVC.changeTitle = @"修改个性签名";
                
                
                _changeInfoVC.hidesBottomBarWhenPushed = YES;
                
                
                _changeInfoVC.value = _model.selfComment;
                _changeInfoVC.key = @"selfComment";
                
                [self.navigationController pushViewController:_changeInfoVC animated:YES];
            }
                break;
                
                
            default:
                break;
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}



#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    
    UIImage *editImage          = [info objectForKey:UIImagePickerControllerOriginalImage];
    //    UIImage *cutImage           = [self cutImage:editImage size:CGSizeMake(160, 160)];
    UIImage *cutImage  = [CommonMethods imageWithImage:editImage scaledToSize:CGSizeMake(300, 300)];
    
    temImage = cutImage;
    
    [CommonMethods upLoadPhotos:@[cutImage] resultBlock:^(BOOL success, NSArray *results) {
        
        if (success) {
            
            NSLog(@"results:%@",results);
            
            if (results.count > 0) {
                
                _model.headImageURL = [results firstObject];
                
                [BmobHelper updateBmobWithKey:@"headImageURL" value:_model.headImageURL object:[BmobUser getCurrentUser] result:^(BOOL isSuccess) {
                    
                    if (isSuccess) {
                        
                         [self.tableView reloadData];
                        
                        
                    }
                    else
                    {
                        [CommonMethods showDefaultErrorString:@"头像修改失败，请重试"];
                        
                    }
                    
                }];
                
                
               
                
               
                
            }
        }
        
    }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma  mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == photoActionSheetTag) {
        
        switch (buttonIndex) {
            case 0:
            {
                
          
                
                UIImagePickerController *_picker = [[UIImagePickerController alloc]init];
                _picker.editing = NO;
                _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                _picker.delegate = self;
                
                [self presentViewController:_picker animated:YES completion:nil];
                
            }
                break;
            case 1:
            {
                
             ;
                
                UIImagePickerController *_picker = [[UIImagePickerController alloc]init];
                _picker.editing = NO;
                _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                _picker.delegate = self;
                
                [self presentViewController:_picker animated:YES completion:nil];
            }
                break;
                
                
            default:
                break;
        }
    }
    
    
    if (actionSheet.tag == sextActionSheetTag) {
        
        if (buttonIndex == 0) //男
        {
            
            [BmobHelper updateBmobWithKey:@"sex" value:@(1) object:[BmobUser getCurrentUser] result:^(BOOL isSuccess) {
                
                if (isSuccess) {
                    
                    _model.sex = 1;
                    
                    [self.tableView reloadData];
                    
                }
            }];
            
        }
        else if (buttonIndex == 1) //女
        {
           
            [BmobHelper updateBmobWithKey:@"sex" value:@(0) object:[BmobUser getCurrentUser] result:^(BOOL isSuccess) {
                
                if (isSuccess) {
                    
                    _model.sex = 0;
                    
                    [self.tableView reloadData];
                }
            }];

        }
    
    }
}

-(void)doneEditeUpLoadPhoto:(UIImage *)photo
{
    temImage = photo;
    
    [self.tableView reloadData];
    
    [CommonMethods upLoadPhotos:@[photo] resultBlock:^(BOOL success, NSArray *results) {
       
        if (success) {
            
            NSLog(@"传成功");
            
        }
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)logoutAction:(id)sender {
    
    _logoutAlert = [[UIAlertView alloc]initWithTitle:nil message:@"确定退出?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [_logoutAlert show];
    
    
    
}



#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView == _logoutAlert) {
        
        if (buttonIndex == 1) {
            
            [BmobUser logout];
            
            [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO];
            
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kHadLogin];
            
            [[NSUserDefaults standardUserDefaults ] setBool:NO forKey:kEasyMobHadLogin];
            
            [[NSUserDefaults standardUserDefaults ] synchronize];
            UINavigationController *logNav = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNav"];
            
            [self presentViewController:logNav animated:YES completion:nil];
            
            
            
        }
    }
}
@end
