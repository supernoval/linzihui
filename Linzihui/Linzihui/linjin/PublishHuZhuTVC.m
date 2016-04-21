//
//  PublishHuZhuTVC.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/4/19.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "PublishHuZhuTVC.h"

@interface PublishHuZhuTVC ()<UITextFieldDelegate,UITextViewDelegate,AddPhotoViewDelegate>
{
    NSArray *_photos;
    
    NSDate *_validate;
    
    PickDateView *_pickdateView;
    
    
    
}
@end

@implementation PublishHuZhuTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发布邻近互助";
    
    _photosView.delegate = self;
    
    _contentTF.delegate = self;
    _jinErTF.delegate = self;
    
    UIBarButtonItem *publishButton = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(publishHuZhu)];
    
    
    
    self.navigationItem.rightBarButtonItem = publishButton;
    
    
    
    _pickdateView = [[PickDateView alloc]init];
    
    _pickdateView.delegate = self;
    
    [CommonMethods getCurrentLocation:^(BOOL success, NSString *address) {
        
        if (success) {
            
            self.locationLabel.text = [NSString stringWithFormat:@"所在地址:%@",address];
            
            
        }
    }];
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_pickdateView removeFromSuperview];
    
}

#pragma mark -发布互助

-(void)publishHuZhu
{
    
    [self.view endEditing:YES];
    
    if (_contentTF.text.length == 0) {
        
        [CommonMethods showDefaultErrorString:@"请填写帮助内容"];
        return;
    }
    
    if (_photos.count == 0) {
        
        [CommonMethods showDefaultErrorString:@"上传图片" ];
        return;
    }
    
    if (_jinErTF.text == 0 || [_jinErTF.text floatValue] == 0) {
        
        [CommonMethods showDefaultErrorString:@"红包金额要大于0"];
        
        return;
        
    }
    
    if (!_validate) {
        
        [CommonMethods showDefaultErrorString:@"请选择有效时间"];
        
        return;
        
    }
    
    [self upLoadImages];
    
    
    
}

-(void)upLoadImages
{
    
    [MyProgressHUD showProgress];
    
    [CommonMethods upLoadPhotos:_photos resultBlock:^(BOOL success, NSArray *results) {
        
        if (success && results.count > 0) {
            
            [self saveDataWithImageURLs:results];
            
        }
        else
        {
            [MyProgressHUD dismiss];
            
            [CommonMethods showDefaultErrorString:@"上传失败，请重试"];
            
        }
    } ];
}

-(void)saveDataWithImageURLs:(NSArray*)imgURLS
{
    
    CGFloat currentLat = [[NSUserDefaults standardUserDefaults] floatForKey:kCurrentLatitude];
    
    CGFloat currentLon = [[NSUserDefaults standardUserDefaults] floatForKey:kCurrentLongitude];
    
    BmobGeoPoint *point  = [[BmobGeoPoint alloc]initWithLongitude:currentLon WithLatitude:currentLat];

    
    
    BmobObject *ob =[BmobObject objectWithClassName:kLinJinHuZhu];
    
    [ob setObject:[BmobUser getCurrentUser] forKey:@"publisher"];
    
    [ob setObject:imgURLS forKey:@"photos"];
    
    [ob setObject:_contentTF.text forKey:@"content"];
    
    [ob setObject:point forKey:@"location"];
    [ob setObject:[NSNumber numberWithFloat:[_jinErTF.text floatValue]] forKey:@"hongbaoNum"];
    
    
    [ob setObject:_validate forKey:@"validate"];
    
    [ob saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
       
        [MyProgressHUD dismiss];
        
        if (isSuccessful) {
            
            
            if ([_jinErTF.text floatValue] > 1) {
                
                [BmobHelper sendHongBaoJPush];
            }
            
            
            [self.navigationController popViewControllerAnimated:YES];
            
            NSLog(@"HuZhu upload Succes");
        }
        else
        {
            [CommonMethods showDefaultErrorString:@"发布失败，请重试"];
            NSLog(@"Huzhu Error:%@",error);
            
        }
    }];
    
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _placeHolderLabel.hidden = YES;
    
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    
    if (textView.text.length == 0) {
        
        _placeHolderLabel.hidden = NO;
    }
}

#pragma mark - UITextFieldDelegate 
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        
        self.view.center = CGPointMake(self.view.center.x, self.view.center.y - 200);
        
        
    }];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.view.center = CGPointMake(self.view.center.x, self.view.center.y + 200);
        
        
    }];
    
}



#pragma mark - AddPhotoViewDelegate
- (void)didChangePhotos:(NSArray *)photos{
    
    
    _photos = photos;
    
    
}

-(void)showActionSheet
{
    [self.view endEditing:YES];
    
}


- (IBAction)pickTimeAction:(id)sender {
    
    [self.view endEditing:YES];
    
    [self.navigationController.view addSubview:_pickdateView];
    
    [_pickdateView showPickView];
    
    
}

#pragma mark - PickDateDelegate
-(void)didPickDate:(NSDate *)date
{
    _validate = date;
    
    NSString *dateStr = [CommonMethods getYYYYMMddhhmmDateStr:date];
    
    [_pickTimeButton setTitle:dateStr forState:UIControlStateNormal];
    
    
}
@end
