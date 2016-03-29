//
//  AddPhotoView.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/3/28.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "AddPhotoView.h"

@implementation AddPhotoView

-(void)awakeFromNib{
    
}
-(id)initWithFrame:(CGRect)frame
{
    
    if (self == [super initWithFrame:frame]) {
        
        
    }
    
    
    return self;
    
}

-(void)setPhotosArray:(NSMutableArray *)photosArray
{
    
    _photosArray = photosArray;
    
    
    muPhotosArray = [[NSMutableArray alloc]init];
    
    
    [muPhotosArray addObjectsFromArray:photosArray];
    
    //如果图片少于8张就加上加号
    UIImage *addImage = [UIImage imageNamed:@"tianjiazhaopian"];
    
    if (muPhotosArray.count < 8) {
        
        [muPhotosArray addObject:addImage];
        
    }
    
    
    
    
    
    
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    
    
    if (!_photosArray) {
        
        
        _photosArray = [[NSMutableArray alloc]init];
        
        
    }
    
    
    if (!muPhotosArray) {
        
        
        muPhotosArray = [[NSMutableArray alloc]init];
        
        
    }
    
    
    
    if (muPhotosArray == nil || muPhotosArray.count == 0) {
        
        UIImage *addImage = [UIImage imageNamed:@"tianjiazhaopian"];
        
        muPhotosArray =[[NSMutableArray alloc]init];
        
        [muPhotosArray addObject:addImage];
        
      
    }
    

    [self setButtons];
    
    
    
}

-(void)setButtons
{
    
    //先删除
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        [obj removeFromSuperview];
        
        
    }];
    
    
    //再添加
    CGFloat buttonWith = 60;
    
    CGFloat buttonHeight = 60;
    
    CGFloat offSet = 8;
    
    
    for (int i = 0 ; i < muPhotosArray.count; i++) {
        
        int row = i /4;
        
        UIImage *image = [muPhotosArray objectAtIndex:i];
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake((buttonWith+ offSet) * (i%4) + offSet , (buttonHeight + offSet) * row + offSet, buttonWith, buttonHeight)];
        
        [button setImage:image forState:UIControlStateNormal];
        
        button.tag = i ;
        
        
        [button addTarget:self action:@selector(pickPhoto:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        
        
        
    }
}

-(void)pickPhoto:(UIButton*)sender
{
    
    if ([self.delegate respondsToSelector:@selector(showActionSheet)]) {
        
        [self.delegate showActionSheet];
        
    }

    
    if (_photosArray.count < 8 && _photosArray.count == sender.tag)
    {
        
        
        UIActionSheet *  _pickPhotoActionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        
        [_pickPhotoActionSheet addButtonWithTitle:@"相册图片描述"];
        
        [_pickPhotoActionSheet addButtonWithTitle:@"手机拍照描述"];
    
        [_pickPhotoActionSheet addButtonWithTitle:@"取消"];
        
        _pickPhotoActionSheet.cancelButtonIndex = 2;
        
        _pickPhotoActionSheet.tag = 99;
        
        [_pickPhotoActionSheet showInView:self];
      
        
    }
    else
    {
        
        
        UIActionSheet *  _pickPhotoActionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        
        
        [_pickPhotoActionSheet addButtonWithTitle:@"删除"];
        
        [_pickPhotoActionSheet addButtonWithTitle:@"取消"];
        
        _pickPhotoActionSheet.cancelButtonIndex = 1;
        
        _pickPhotoActionSheet.tag = sender.tag;
        
        [_pickPhotoActionSheet showInView:self];
    }
  
    
  
    
     
}




-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    if (actionSheet.tag ==99) {
        
  
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
    
    
    UIApplication *app = [UIApplication sharedApplication];
    
    UITabBarController *_controller = (UITabBarController*) app.keyWindow.rootViewController;
    
    UINavigationController *_navi = _controller.selectedViewController;
    
    UIViewController *vc = [_navi topViewController];
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    
    picker.delegate = self;
    picker.sourceType = sourceType;
    
    [vc presentViewController:picker animated:YES completion:nil];
        
          }
    
    else  //删除
    {
        
        if (buttonIndex == 0) //删除
        {
            
            if (_photosArray.count > actionSheet.tag) {
                
                
                [_photosArray removeObjectAtIndex:actionSheet.tag];
                
                
                [muPhotosArray removeAllObjects];
                
                [muPhotosArray addObjectsFromArray:_photosArray];
                
                if (muPhotosArray.count < 8) {
                    
                 [muPhotosArray addObject:[UIImage imageNamed:@"tianjiazhaopian"]];
                }
                
                
                
                //代理
                if ([self.delegate respondsToSelector:@selector(didChangePhotos:)]) {
                    
                    
                    [self.delegate didChangePhotos:_photosArray];
                    
                }
                
                [self setButtons];
                
                
            }
          
            
            
            
        }
    }
    
}



#pragma mark -  UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    image = [CommonMethods autoSizeImageWithImage:image];
    
    
    [_photosArray addObject:image];
    
    [muPhotosArray removeAllObjects];
    
    [muPhotosArray addObjectsFromArray:_photosArray];
    
    if (muPhotosArray.count < 8) {
        
        [muPhotosArray addObject:[UIImage imageNamed:@"tianjiazhaopian"]];
    }
    
    
    
    //代理
    if ([self.delegate respondsToSelector:@selector(didChangePhotos:)]) {
        
        
        [self.delegate didChangePhotos:_photosArray];
        
    }
    
    
    
    [self setButtons];
    
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
   
    
    

}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
}


@end
