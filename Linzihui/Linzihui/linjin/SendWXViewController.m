//
//  SendWXViewController.m
//  TXCar
//
//  Created by ZhuHaikun on 15/11/6.
//  Copyright © 2015年 BH. All rights reserved.
//

#import "SendWXViewController.h"

#import "EditPhotoViewController.h"
#import <BmobSDK/Bmob.h>
#import <BmobSDK/BmobUser.h>
#import <BmobSDK/BmobProFile.h>

@interface SendWXViewController ()<UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSMutableArray *_image_list;
    NSMutableArray *_image_list1;
     NSMutableArray *_image_list2;
    NSInteger _select_imageview_index;
    
    UIImage *addImage;
    
    UITapGestureRecognizer *_tapGesture;
    
     UIActionSheet *_pickPhotoActionSheet;
    
    
    NSArray *_photoImageURLs;
    
    
    
}
@end

@implementation SendWXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    
    UIBarButtonItem *submit_btn = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(submit_clicked)];
    self.navigationItem.rightBarButtonItem =submit_btn;
    _image_list = [[NSMutableArray alloc]init];
     _image_list1 = [[NSMutableArray alloc]init];
     _image_list2 = [[NSMutableArray alloc]init];
    addImage  = [UIImage imageNamed:@"tianjiazhaopian"];
    
    [_image_list addObject:addImage];
    
    _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resign)];
    
    _inputTextView.delegate = self;
    
     [self reloadPhotoViews];
    
}

-(void)submit_clicked{
  
    if (_inputTextView.text.length == 0 && _image_list.count == 1) {
        
        
        UIImage *image = [_image_list firstObject];
        
        if (image == addImage) {
            
            [CommonMethods showDefaultErrorString:@"请输入内容"];
            
            
            return;
            
        }
        
        
     
    }
    
    
    NSString *text = _inputTextView.text;
    
    if (!text) {
        
        text = @"";
        
        
    }
    
    if (_image_list.count < 8) {
        
        [_image_list removeObjectAtIndex:_image_list.count -1];
        
    }
    
     [MyProgressHUD showProgress];
    
    [CommonMethods upLoadPhotos:_image_list resultBlock:^(BOOL success, NSArray *results) {
        
        if (success) {
            
            _photoImageURLs = results;
            
            
            BmobUser *currentUser = [BmobUser getCurrentUser];
            
            BmobObject *ob = [BmobObject objectWithClassName:kShengHuoQuanTableName];
            
            [ob setObject:currentUser forKey:@"publisher"];
            
            [ob setObject:_photoImageURLs forKey:@"image_url"];
            [ob setObject:text forKey:@"text"];
            [ob setObject:@[] forKey:@"comment"];
            
            
            CGFloat longitude = [[NSUserDefaults standardUserDefaults ] floatForKey:kCurrentLongitude];
            
            CGFloat latitude = [[NSUserDefaults standardUserDefaults] floatForKey:kCurrentLatitude];
            
            if (longitude > 0 && latitude > 0) {
                
                BmobGeoPoint *point = [[BmobGeoPoint alloc]initWithLongitude:longitude WithLatitude:latitude];
                
                
                [ob setObject:point forKey:@"location"];
                
                
            }
            
            
            [ob saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
               
                   [MyProgressHUD dismiss];
                
                if (isSuccessful) {
                    
                    [CommonMethods showDefaultErrorString:@"发送成功"];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                    
                }
                else
                {
                    
                    [CommonMethods showDefaultErrorString:@"发送失败"];
                    
                }
                
            }];
            
            
        }
        else
        {
             [MyProgressHUD dismiss];
            
            [CommonMethods showDefaultErrorString:@"发送失败"];
            
        }
    }];
  
    
    
}





-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
   
}

-(void)resign
{
    [self.view endEditing:YES];
    
    
    [self.view removeGestureRecognizer:_tapGesture];
    
}

#pragma mark - UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    _sayLabel.hidden = YES;
    
    [self.view addGestureRecognizer:_tapGesture];
    
    
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        
        _sayLabel.hidden = NO;
        
        
    }
    else
    {
        _sayLabel.hidden = YES;
        
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0) {
        
        _sayLabel.hidden = NO;
        
        
    }
    
}





- (IBAction)photoButtonAction:(id)sender {
    
    
    [self resign];
    
    UIButton *sendbutton = (UIButton*)sender;
    
        _pickPhotoActionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        
        [_pickPhotoActionSheet addButtonWithTitle:@"相册图片描述"];
        [_pickPhotoActionSheet addButtonWithTitle:@"手机拍照描述"];
        [_pickPhotoActionSheet addButtonWithTitle:@"删除"];
        
        [_pickPhotoActionSheet addButtonWithTitle:@"取消"];
        
        _pickPhotoActionSheet.cancelButtonIndex = 3;
        _pickPhotoActionSheet.tag = sendbutton.tag;
    
        [_pickPhotoActionSheet showInView:self.view];
    
 
   
    
    
    

}








#pragma mark - 刷新图片界面
-(void)reloadPhotoViews
{
    
    
    for (int i = 0; i < _image_list.count; i ++) {
        
        UIImage *image = [_image_list objectAtIndex:i];
        
        [self setButtonImageWithTag:i image:image];
        
        
    }
    
    //将没有放置图片的按钮设置成不可点击
    [self setButtonEnAble];
    
    _inputTextView.frame = CGRectMake(0, 0, 240, 128);
    _inputTextView.contentSize = CGSizeMake(240, 128);
    
    _inputTextView.contentOffset = CGPointMake(0, 0);
    
    NSLog(@"textviewFrame%@",_inputTextView);
    
    
}

-(void)setButtonImageWithTag:(NSInteger)tag image:(UIImage*)image
{
    for (UIButton *button in _photoView.subviews) {
        
        if (button.tag == tag +1 ) {
            
            [button setImage:image forState:UIControlStateNormal];
            
        }
    }
}

-(void)setButtonEnAble
{
    for (UIButton *button in _photoView.subviews) {
        
        if (button.tag <= _image_list.count) {
            
            button.enabled = YES;
            
        }
        else
        {
            button.enabled = NO;
            
        }
    }
}



#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    
    
     [_image_list removeObjectAtIndex:_image_list.count -1];
    
     [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (image) {
        
        
        image = [CommonMethods autoSizeImageWithImage:image];
        
        [_image_list addObject:image];
        
        
       
        
       
        
    }
    
    //再把加号 放进去
    if (_image_list.count < 8) {
        
        [_image_list addObject:addImage];
        
    }
    [self reloadPhotoViews];
    
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
}



#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet == _pickPhotoActionSheet)
    {
        if (buttonIndex == 3) {
        
            return;
            
        }
        if (buttonIndex == 2) {
            
        
            [_image_list removeObjectAtIndex:actionSheet.tag -1];
            
            
            [self reloadPhotoViews];
            
            return;
            
        }
        
        
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
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
