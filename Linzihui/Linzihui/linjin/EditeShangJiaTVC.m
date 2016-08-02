//
//  EditeShangJiaTVC.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/5/18.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "EditeShangJiaTVC.h"
#import "TypeTableViewController.h"
#import "LocationViewController.h"



@interface EditeShangJiaTVC ()<LocationViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
        BmobGeoPoint *_location;
    
      UIImage *_headPhoto;
    
}

@end

@implementation EditeShangJiaTVC

- (void)viewDidLoad {
    [super viewDidLoad];
 
    
    self.title = @"编辑商家信息";
    


    
    [_headButton sd_setBackgroundImageWithURL:[NSURL URLWithString:_model.photo] forState:UIControlStateNormal];
    
    _nameTextfield.text = _model.name;
    _addressTextfield.text= _model.address;
    
    _gpsLabel.text = [NSString stringWithFormat:@"纬度:%.3f  经度:%.3f",_model.location.latitude,_model.location.longitude];
    
    _typeLabel.text = _model.type;
    
    _distanceLabel.text = [NSString stringWithFormat:@"%@",_model.coverage];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    
    self.navigationItem.rightBarButtonItem = barButton;
    
    
    
}

-(void)save
{
    if (_nameTextfield.text.length == 0) {
        
        [CommonMethods showDefaultErrorString:@"请填写店名"];
        return;
    }
    
    if (_addressTextfield.text.length == 0) {
        
        [CommonMethods showDefaultErrorString:@"请填写地址"];
        
        return;
    }
    
    if (_typeLabel.text.length == 0) {
        
        [CommonMethods showDefaultErrorString:@"请选择经营类型"];
        
        return;
    }
    
    if (_distanceLabel.text.length == 0) {
        
        [CommonMethods showDefaultErrorString:@"请选择覆盖范围"];
        
        return;
    }
    
    
    [MyProgressHUD showProgress];
    
    
    if (_headPhoto) {
        
        [self uploadImage];
        
    }
    else
    {
        [self saveData:nil];
        
    }
    
}
-(void)uploadImage
{
    
    [CommonMethods upLoadPhotos:@[_headPhoto] resultBlock:^(BOOL success, NSArray *results) {
        
        if (success) {
            
            [self saveData:[results firstObject]];
        }
        
        
    }];
    
}

-(void)saveData:(NSString *)headImageURL
{
    BmobObject *ob = [BmobObject objectWithoutDataWithClassName:kShangJia objectId:_model.objectId];
    
    if (_location) {
        
        [ob setObject:_location forKey:@"location"];
        
    }
    
    [ob setObject:_typeLabel.text forKey:@"type"];
    
    [ob setObject:_distanceLabel.text forKey:@"coverage"];
    
    [ob setObject:_nameTextfield.text forKey:@"name"];
    
    if (headImageURL) {
        
        [ob setObject:headImageURL forKey:@"photo"];
        
    }
    
    [ob updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
       
        [MyProgressHUD dismiss];
        
        if (isSuccessful) {
            
            NSLog(@"编辑成功");
            [CommonMethods showDefaultErrorString:@"编辑成功"];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
        else
        {
            NSLog(@"error:%@",error);
            
        }
    }];
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
    
    if (indexPath.row == 3) //经营类型
    {
        
        [self showTypeSelectedVCWithShowType:1];
        
        
    }
    
    if (indexPath.row == 4) {
        
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


#pragma mark - LocationViewDelegate
-(void)sendLocationLatitude:(double)latitude longitude:(double)longitude andAddress:(NSString *)address
{
    
    _location = [[BmobGeoPoint alloc]init];
    
    _location.latitude = latitude;
    
    _location.longitude = longitude;
    
    _gpsLabel.text = [NSString stringWithFormat:@"纬度:%.3f,经度:%.3f",longitude,latitude];
    
    
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
            [_headButton setBackgroundImage:image forState:UIControlStateNormal];
            
            
            _headPhoto = image;
            
        }
            break;
            
        case 100:
        {
            [_headButton setImage:image forState:UIControlStateNormal];
            
//            _IdOneImage = image;
            
        }
            break;
            
        case 101:
        {
            
            [_headButton setImage:image forState:UIControlStateNormal];
            
//            _IdTwoImage = image;
            
            
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



- (IBAction)changeHeadAction:(id)sender {
    
    [self showPickActionSheetWithTag:99];
    
    
}
@end
