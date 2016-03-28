//
//  SetNewGroupNameImageVC.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/3/24.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "SetNewGroupNameImageVC.h"

@interface SetNewGroupNameImageVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    UIImage *headImage;
 
    NSString *imageURL;
    
    UIImagePickerController *_imagePickerController;
    
}
@end

@implementation SetNewGroupNameImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"群信息";
    
    
    
}




- (IBAction)changeHeadAction:(id)sender {
    
    
    [self.view endEditing:YES];
    
    UIActionSheet *_pickActionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    _pickActionSheet.delegate = self;
    
    
    [_pickActionSheet addButtonWithTitle:@"相册"];
    [_pickActionSheet addButtonWithTitle:@"照相"];
    
    [_pickActionSheet addButtonWithTitle:@"取消"];
    
    _pickActionSheet.cancelButtonIndex = 2;
    
    //            _pickActionSheet.tag = photoActionSheetTag;
    
    [_pickActionSheet showInView:self.view];
    
    
    
    
}

- (IBAction)createAction:(id)sender {
    
    
    if (_nameTextField.text.length == 0) {
        
        [CommonMethods showDefaultErrorString:@"请填写群名称"];
        
        return;
        
    }
    
    if (!headImage) {
        
        [CommonMethods showDefaultErrorString:@"请上传群头像"];
        
        return;
        
    }
    
    
  
    [self uploadData];
    
    


    
}

-(void)uploadData
{
    
    [MyProgressHUD showProgress];
    
    [CommonMethods upLoadPhotos:@[headImage] resultBlock:^(BOOL success, NSArray *results) {
       
        
        if (success && results.count > 0) {
            
            imageURL = [results firstObject];
            
            [self createGroup];
            
            
        }
        else
        {
            [MyProgressHUD dismiss];
            
        }
    }];
  
}

-(void)createGroup
{
    NSMutableArray *muArray = [[NSMutableArray alloc]init];
    
    for (UserModel *oneModel in _buddyList) {
        
        if (oneModel.hadSelected) {
            
            [muArray addObject:oneModel.username];
            
        }
    }
    
    if (muArray.count == 0) {
        
        
        [CommonMethods showDefaultErrorString:@"请选择朋友"];
        
        return;
    }
    
    
   
    
//    BmobUser *currentUser = [BmobUser getCurrentUser];
    
//    NSString *nick = [currentUser objectForKey:@"nickName"];
    
//    NSString *username = currentUser.username;
    

    
    NSMutableArray *addArray = [[NSMutableArray alloc]init];
    
    for (UserModel *oneModel in _buddyList) {
        
        if (oneModel.hadSelected) {
            
            [addArray addObject:oneModel];
            
        }
    }
    
    
    //将自己的也加进去
    UserModel *currentUserModel = [BmobHelper getCurrentUserModel];
    
    [addArray addObject:currentUserModel];
    
    
   
    
    [EMHelper createGroupWithinitTitle:_nameTextField.text description:@"邻里互帮" invitees:muArray welcomeMsg:@"欢迎加入" friends:addArray  groupName:_nameTextField.text headImage:imageURL result:^(BOOL success, EMGroup *group) {
        
        [MyProgressHUD dismiss];
        
        if (success) {
            
         
            if (_temBlock) {
                
                _temBlock(success,group,_nameTextField.text);
                
            }
            
            [[NSNotificationCenter defaultCenter ] postNotificationName:kCreategroupSuccessNoti object:group userInfo:@{@"groupid":group.groupId}];
            
            
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            
            
        }
    }];
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


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (image) {
        
        
        image = [CommonMethods autoSizeImageWithImage:image];
        
        
        
    }
    
    [_headImageButton setImage:image forState:UIControlStateNormal];
    
    headImage  = image;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
