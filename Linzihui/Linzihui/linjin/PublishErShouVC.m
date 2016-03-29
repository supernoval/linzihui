//
//  PublishErShouVC.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/3/28.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "PublishErShouVC.h"
#import "AddPhotoView.h"

@interface PublishErShouVC ()<AddPhotoViewDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    NSArray *_photos;
    
    NSString *_type;
    
    
}
@end

@implementation PublishErShouVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title  = @"发布二手";
    
    
    UIBarButtonItem *publishButton = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(publish)];
    
    self.navigationItem.rightBarButtonItem = publishButton;
    
    
    self.desTextView.delegate = self;
    
    
    
    
    
}


-(void)publish
{
    if (self.desTextView.text.length == 0) {
        
        
        [CommonMethods showDefaultErrorString:@"请输入商品描述"];
        
        return;
        
    }
    
    if (_photos.count == 0) {
        
        [CommonMethods showDefaultErrorString:@"请上传商品图片"];
        
        return;
        
    }
    
    
    
    if (_priceTextField.text.length == 0) {
        
        [CommonMethods showDefaultErrorString:@"请输入商品价格"];
        
        return;
        
    }
    
    if (_type.length == 0) {
        
        [CommonMethods showDefaultErrorString:@"请选择商品类型"];
        
        return;
        
    }
    
    
}


-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
    self.placeHolderLabel.hidden = YES;
    
    
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0) {
        
        self.placeHolderLabel.hidden = NO;
        
    }
}


#pragma mark - AddPhotoViewDelegate

-(void)didChangePhotos:(NSArray *)photos
{
    
    _photos = photos;
    
    
}





- (IBAction)typeAction:(id)sender {
    
    
    ErShouTypeTVC *typeTVC = [[ErShouTypeTVC alloc]initWithStyle:UITableViewStylePlain];
    
    typeTVC.selectedType = _type;
    
    [typeTVC setBlock:^(BOOL success, NSString *typeString) {
        
        _type = typeString;
        
        
    }];
    
    
    [self.navigationController pushViewController:typeTVC animated:YES];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
