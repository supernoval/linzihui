//
//  PublishShangPinVC.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/5/3.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "PublishShangPinVC.h"

@interface PublishShangPinVC ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
{
    UIImage *_shangpinImage;
    
}
@end

@implementation PublishShangPinVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"发布商品";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.shangpinDesTV.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    
    self.shangpinDesTV.layer.borderWidth = 1;
    
    
}


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
    
    

    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    
    picker.delegate = self;
    picker.sourceType = sourceType;
    
    [self presentViewController:picker animated:YES completion:nil];
    
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    image = [CommonMethods autoSizeImageWithImage:image];
    
    [_uploadPhotoButton setImage:image forState:UIControlStateNormal];
    
    _shangpinImage = image;
    
    
    [picker dismissViewControllerAnimated:YES completion:^{
       
        
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
}

- (IBAction)uploadPhotoAction:(id)sender {
    
    UIActionSheet *  _pickPhotoActionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    
    [_pickPhotoActionSheet addButtonWithTitle:@"相册图片描述"];
    
    [_pickPhotoActionSheet addButtonWithTitle:@"手机拍照描述"];
    
    [_pickPhotoActionSheet addButtonWithTitle:@"取消"];
    
    _pickPhotoActionSheet.cancelButtonIndex = 2;
    
    _pickPhotoActionSheet.tag = 99;
    
    [_pickPhotoActionSheet showInView:self.view];
    
}
- (IBAction)okAction:(id)sender {
    
    if (!_shangpinImage) {
        
        [CommonMethods showDefaultErrorString:@"请上传商品图片"];
        return;
    }
    
    if (_shangpinnameLabel.text.length == 0) {
        
        [CommonMethods showDefaultErrorString:@"请填写商品名称"];
        
        return;
        
    }
    
    if (_shangpinDesTV.text.length == 0) {
        
        [CommonMethods showDefaultErrorString:@"请填写商品描述"];
        
        return;
        
    }
    
    if (_shangpinpriceLabel.text.length == 0) {
        
        [CommonMethods showDefaultErrorString:@"请填写商品价格"];
        
        return;
        
        
    }
    
    
    [self uploadImage];
    
    
}

-(void)uploadImage
{
    [MyProgressHUD showProgress];
    
    [CommonMethods upLoadPhotos:@[_shangpinImage] resultBlock:^(BOOL success, NSArray *results) {
       
        if (success) {
            
            NSString *photourl =[results firstObject];
            
            [self summitWithphotoURL:photourl];
            
        }
        
        else
        {
            
            [MyProgressHUD dismiss];
            
            [CommonMethods showDefaultErrorString:@"商品图片上传失败,请重试"];
            
            
        }
        
        
    }];
}

-(void)summitWithphotoURL:(NSString *)photourl
{
    BmobObject *OB = [BmobObject objectWithClassName:kShangPin];
    
    [OB setObject:photourl forKey:@"photos"];
    
    [OB setObject:_shangpinnameLabel.text forKey:@"name"];
    
    [OB setObject:_shangpinDesTV.text forKey:@"des"];
    
    [OB setObject:[NSNumber numberWithFloat:[_shangpinpriceLabel.text floatValue]] forKey:@"price"];
    
    [OB setObject:_model.objectId forKey:@"shangjiaObjectId"];
    
    [OB setObject:[BmobUser getCurrentUser].username forKey:@"username"];
    
    [OB saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
       
        
        if (isSuccessful) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        else
        {
            NSLog(@"error:%@",error);
            
            [CommonMethods showDefaultErrorString:@"上传失败,请重试"];
            
        }
        
    }];
    
}
@end
