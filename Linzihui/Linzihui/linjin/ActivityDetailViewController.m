//
//  ActivityDetailViewController.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/1/28.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "ActivityDetailViewController.h"

@interface ActivityDetailViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>
{
   UIActionSheet *_pickPhotoActionSheet;
     UIImage *addImage;
    
    
}
@end

@implementation ActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if (_image_list.count == 0) {
        
         _image_list = [[NSMutableArray alloc]init];
    }
   
    _detailTV.text = _detailStr;
    
    if (_detailStr.length > 0) {
        
        _placeHolderLabel.hidden = YES;
    }
    _detailTV.delegate = self;
    
    [_image_list addObjectsFromArray:_imagesArray];
    
    
    
    
    addImage  = [UIImage imageNamed:@"tianjiazhaopian"];
    
    [_image_list addObject:addImage];
    
   
    
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(savedata)];
    
    self.navigationItem.rightBarButtonItem = barButton;
    
 
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_photoURLs.count > 0) {
        
        [self setEditeTypeButtonImage];
        
    }
    
       [self reloadPhotoViews];
    
}

-(void)savedata
{
   
    
    if (_detailTV.text.length == 0 ) {
        
        
        [CommonMethods showDefaultErrorString:@"请输入活动详情、流程、特点、注意事项"];
      
        return;
        
    }
    
    
    if (_image_list.count == 1) {
        
        [CommonMethods showDefaultErrorString:@"请上传活动详情图片"];
        
        return;
        
        
    }
    
    [_image_list removeObjectAtIndex:_image_list.count -1];
    
    
    _detailStr = _detailTV.text;
    
    
    if (_block) {
        
        _block(_image_list,_detailStr);
    
        
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
    
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    
    
    
}

-(void)setButtonImageWithTag:(NSInteger)tag image:(UIImage*)image
{
    
    
    
    for (UIButton *button in _photoView.subviews) {
        
        if (button.tag == tag + 1 ) {
            
            [button setImage:image forState:UIControlStateNormal];
            
        }
        
    }
}


#pragma mark - 编辑的时候先加载图片
-(void)setEditeTypeButtonImage
{
//    NSArray *photos = _huodongModel.photoURL;
    
    for (int i = 0; i < _photoURLs.count; i++) {
        
        NSString *url = [_photoURLs objectAtIndex:i];
        
        
        for (UIButton *button in _photoView.subviews) {
            
            if (button.tag == i + 1 ) {
                
                [button sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:kDefaultLoadingImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                    [_image_list addObject:image];
                    
                    if (_image_list.count == _photoURLs.count) {
                        
                        [_image_list addObject:addImage];
                        [self reloadPhotoViews];
                        
                    }
                    
                }];
                
            }
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


-(void)setBlock:(DetailBlock)block
{
    
    _block = block;
    
    
}



- (IBAction)showPicker:(id)sender {
    
    
    [self.view endEditing:YES];
    
    
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


#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet == _pickPhotoActionSheet)
    {
        if (buttonIndex == 3) {
            
            return;
            
        }
        
        
        
        if (buttonIndex == 2)
        {
 
                if (_image_list.count > 1 && actionSheet.tag < _image_list.count ) {
                    
                    [_image_list removeObjectAtIndex:actionSheet.tag -1];
                    
                    
                    [self reloadPhotoViews];
                    
                }
                
            
            
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


#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    image = [CommonMethods autoSizeImageWithImage:image];
    
 
        if (_image_list.count > 0) {
            
            [_image_list removeObjectAtIndex:_image_list.count -1];
        }
        
        
        
        if (image)
        {
            
            
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

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    _placeHolderLabel.hidden = YES;
    
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0) {
        
        _placeHolderLabel.hidden = NO;
        
    }
}


@end
