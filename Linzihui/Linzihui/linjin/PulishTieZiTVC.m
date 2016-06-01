//
//  PulishTieZiTVC.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/6/1.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "PulishTieZiTVC.h"

@interface PulishTieZiTVC ()<UITextFieldDelegate,UITextViewDelegate,AddPhotoViewDelegate>
{
    NSArray *_photos;
    
    NSString *type;
    
    
}
@end

@implementation PulishTieZiTVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"发表帖子";
    
    _addphotoView.delegate = self;
    _contentTV.delegate = self;
    
    
}


-(void)textViewDidBeginEditing:(UITextView *)textView
{
    _placelabel.hidden = YES;
    
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0) {
        
        _placelabel.hidden = NO;
        
        
    }
}
//只是用来隐藏键盘
-(void)showActionSheet
{
    [self.view endEditing:YES];
    
}


-(void)didChangePhotos:(NSArray*)photos
{
    _photos = photos;
    
}

- (IBAction)publish:(id)sender {
    
    
    if (_titleTF.text.length == 0) {
        
        [CommonMethods showDefaultErrorString:@"请填写帖子标题"];
        return;
    }
    
    if (_contentTV.text.length == 0) {
        
        [CommonMethods showDefaultErrorString:@"请填写帖子内容"];
        
        return;
    }
    
    if (_photos.count == 0) {
        
        [CommonMethods showDefaultErrorString:@"请上传帖子图片"];
        
        return;
        
    }
    
    [self uploadPhotos];
    
    
    
    
}

-(void)uploadPhotos
{
    [MyProgressHUD showProgress];
    
    
    [CommonMethods upLoadPhotos:_photos resultBlock:^(BOOL success, NSArray *results) {
       
        if (success) {
            
            [self saveData:results];
            
        }
    }];
    
}

-(void)saveData:(NSArray*)photosURL
{
    BmobObject *OB = [BmobObject objectWithClassName:kTieZi];
    
    [OB setObject:_titleTF.text forKey:@"title"];
    
    [OB setObject:[BmobUser getCurrentUser] forKey:@"publisher"];
    
    if (type.length > 0) {
        
        [OB setObject:type forKey:@"type"];
        
        
    }
    
    
    [OB setObject:_contentTV.text forKey:@"content"];
    
    [OB setObject:_groupId forKey:@"groupId"];
    
    [OB setObject:photosURL forKey:@"photos"];
    
    CGFloat latitude = [[NSUserDefaults standardUserDefaults] floatForKey:kCurrentLatitude];
    CGFloat longitude = [[NSUserDefaults standardUserDefaults] floatForKey:kCurrentLongitude];

    BmobGeoPoint  *point = [[BmobGeoPoint alloc]init];
    point.latitude = latitude;
    point.longitude = longitude;
    
    [OB setObject:point forKey:@"location"];
    
    
    [OB saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
       
        [MyProgressHUD dismiss];
        
        if (isSuccessful) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
            
        }
    }];
    
}
@end
