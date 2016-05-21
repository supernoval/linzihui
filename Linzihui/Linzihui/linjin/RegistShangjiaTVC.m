//
//  RegistShangjiaTVC.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/4/26.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "RegistShangjiaTVC.h"
#import "LocationViewController.h"
#import "TypeTableViewController.h"

@interface RegistShangjiaTVC ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,LocationViewDelegate>
{
    UIImage *_headPhoto;
    UIImage *_IdOneImage;
    UIImage *_IdTwoImage;
    
    NSString *_headPhotoURL;
    
    BmobGeoPoint *_location;
    
    
    
}

@end

@implementation RegistShangjiaTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"填写资料";
    
    
      [CommonMethods showDefaultErrorString:@"提示:为了避免与本人个人信息混杂，请用另外一个手机号重新注册商家"];
    
    
    _headerView.frame = CGRectMake(0, 0, ScreenWidth, 112);
    
    _footerView.frame = CGRectMake(0, 0, ScreenWidth, 100);
    

    
    _location = [[BmobGeoPoint alloc]init];
    
    
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithTitle:@"完成注册" style:UIBarButtonItemStylePlain target:self action:@selector(doneRegist)];
    
    self.navigationItem.rightBarButtonItem = button;
    
    

    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
  
    
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 2) //地图选点
    {
        
        LocationViewController *_locateVC = [LocationViewController defaultLocation];
        
        _locateVC.delegate = self;
        _locateVC.showSearchBar = YES;
        
        
        [self.navigationController pushViewController:_locateVC animated:YES];
        
    }
    
    if (indexPath.row == 4) //经营类型
    {
        
        [self showTypeSelectedVCWithShowType:1];
        
        
    }
    
    if (indexPath.row == 5) {
        
        [self showTypeSelectedVCWithShowType:2];
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(void)showTypeSelectedVCWithShowType:(NSInteger)temShowType
{
    TypeTableViewController *_typeSelecteTVC = [[TypeTableViewController alloc]initWithStyle:UITableViewStyleGrouped];
    
    _typeSelecteTVC.showType = temShowType;
    
    [_typeSelecteTVC setblock:^(NSString *type,NSInteger showType) {
        
        
        if (showType == 1) {
            
            _typeLabel.text = type;
        }
        if (showType == 2) {
            
            _distanceLabel.text = [NSString stringWithFormat:@"%@千米",type];
            
            
        }
        
        
        
        
    }];
    
    
    [self.navigationController pushViewController:_typeSelecteTVC animated:YES];
}

-(void)doneRegist
{
    
    if (!_headPhoto) {
        
        [CommonMethods showDefaultErrorString:@"请上传头像"];
        
        return;
    }
    
    if (!_IdOneImage || !_IdTwoImage) {
        
        [CommonMethods showDefaultErrorString:@"请上传证件照"];
        
        return;
        
    }
    
    if (_nameTF.text.length == 0) {
        
        [CommonMethods showDefaultErrorString:@"请填写店铺名称"];
        
        return;
    }
    
    if (_addressTF.text == 0) {
        
        [CommonMethods showDefaultErrorString:@"请填写店铺地址"];
        
        return;
    }
    
    if (_locationLabel.text.length == 0) {
        
        [CommonMethods showDefaultErrorString:@"请选择店铺地址坐标"];
        
        return;
    }
    
  
    
    if (_typeLabel.text.length == 0) {
        
        [CommonMethods showDefaultErrorString:@"请选择经营类型"];
        
        return;
    }
    
    if (_distanceLabel.text == 0) {
        
        [CommonMethods showDefaultErrorString:@"请选择覆盖范围"];
        
        return;
        
    }
    
    
    [self uploadHeadPhoto];
    
}

-(void)uploadHeadPhoto
{
    [MyProgressHUD showProgress];
    
    [CommonMethods upLoadPhotos:@[_headPhoto] resultBlock:^(BOOL success, NSArray *results) {
       
        if (success) {
            
            _headPhotoURL = [results firstObject];
            
            [self uploadIdImages];
            
        }
        
        else
        {
            [CommonMethods showDefaultErrorString:@"头像上传失败，请重试"];
            
        }
        
    }];
}

-(void)uploadIdImages
{
    [CommonMethods upLoadPhotos:@[_IdOneImage,_IdTwoImage] resultBlock:^(BOOL success, NSArray *results) {
       
        if (success) {
            
            
            [self saveDataWithIdImageURLs:results];
            
        }
        else
        {
            [CommonMethods showDefaultErrorString:@"上传证件照失败,请重试"];
            
            
        }
        
    }];
}

-(void)saveDataWithIdImageURLs:(NSArray*)IdImageURLs
{
    
    
    NSString *username = [BmobUser getCurrentUser].username;

    BmobObject *_shagjiaOB = [BmobObject objectWithClassName:kShangJia];
    
    [_shagjiaOB setObject:_headPhotoURL forKey:@"photo"];
    
    [_shagjiaOB setObject:_nameTF.text forKey:@"name"];
    
    [_shagjiaOB setObject:_addressTF.text forKey:@"address"];
    
    [_shagjiaOB setObject:_location forKey:@"location"];
    
    
    
    if (_yaoqingphoneNumTF.text.length > 0) {
        
        [_shagjiaOB setObject:_yaoqingphoneNumTF.text forKey:@"invitepeopleNumber"];
    }
    
    
    [_shagjiaOB setObject:_distanceLabel.text forKey:@"coverage"];
    
    [_shagjiaOB setObject:IdImageURLs forKey:@"IdImages"];
    
    [_shagjiaOB setObject:_typeLabel.text forKey:@"type"];
    
    
    [_shagjiaOB setObject:username forKey:@"username"];
    
    BmobUser *currentUser = [BmobUser getCurrentUser];
    
    [_shagjiaOB setObject:currentUser forKey:@"publisher"];
    
    [_shagjiaOB setObject:[NSNumber numberWithFloat:5.0] forKey:@"star"];
    
    [_shagjiaOB saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
       
        [MyProgressHUD dismiss];
       
        
        if (isSuccessful) {
            
            
            
            BmobUser *currentUser = [BmobUser getCurrentUser];
            
            [currentUser setObject:@YES forKey:@"isShangJia"];
            
            [currentUser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
               
                if (isSuccessful) {
                    
                    NSLog(@"商家用户表保存成功 ");
                }
                else
                {
                    NSLog(@"error:%@ ",error);
                    
                }
            }];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else
        {
            NSLog(@"error:%@",error);
            
        }
    }];
    
    
    
}

- (IBAction)addPhotoAction:(id)sender {
    
    [self showPickActionSheetWithTag:99];
    
    
}
- (IBAction)idOneAction:(id)sender {
    
     [self showPickActionSheetWithTag:100];
    
    
    
}
- (IBAction)idTwoAction:(id)sender {
    
     [self showPickActionSheetWithTag:101];
}



// tag  头像 99, 身份证照100,101
-(void)showPickActionSheetWithTag:(NSInteger)tag
{
    UIActionSheet *  _pickPhotoActionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    
    [_pickPhotoActionSheet addButtonWithTitle:@"相册图片描述"];
    
    [_pickPhotoActionSheet addButtonWithTitle:@"手机拍照描述"];
    
    [_pickPhotoActionSheet addButtonWithTitle:@"取消"];
    
    _pickPhotoActionSheet.cancelButtonIndex = 2;
    
    _pickPhotoActionSheet.tag = tag;
    
    [_pickPhotoActionSheet showInView:self.view];
    
    
}
#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex < 2) {
        
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
    
        
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        
        picker.delegate = self;
        picker.sourceType = sourceType;
        picker.view.tag = actionSheet.tag;
        
        [self presentViewController:picker animated:YES completion:nil];
        
    
    }
}

#pragma mark -  UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    image = [CommonMethods autoSizeImageWithImage:image];
    
    switch (picker.view.tag) {
        case 99:
        {
            [_photoButton setImage:image forState:UIControlStateNormal];
            
            _headPhoto = image;
            
        }
            break;
            
        case 100:
        {
            [_idOneButton setImage:image forState:UIControlStateNormal];
            
            _IdOneImage = image;
            
        }
            break;
            
        case 101:
        {
           
            [_idTwoButton setImage:image forState:UIControlStateNormal];
            
            _IdTwoImage = image;
            
            
        }
            break;
            
            
        default:
            break;
    }
    
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    
    
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
}

#pragma mark - LocationViewDelegate
-(void)sendLocationLatitude:(double)latitude longitude:(double)longitude andAddress:(NSString *)address
{
    
    _location.latitude = latitude;
    
    _location.longitude = longitude;
    
    _locationLabel.text = [NSString stringWithFormat:@"纬度:%.3f,经度:%.3f",longitude,latitude];
    
    
}

@end
