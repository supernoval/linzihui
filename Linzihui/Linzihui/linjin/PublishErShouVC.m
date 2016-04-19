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
    
    
    self.addPhotoView.delegate = self;
    
    if (_isEdited) {
        
        self.title = @"编辑二手";
        
         self.placeHolderLabel.hidden = YES;
        
        [publishButton setTitle:@"保存"];
        
        self.desTextView.text = _editeModel.des;
        
        self.priceTextField.text = _editeModel.price;
        
        [self.typeButton setTitle:_editeModel.type forState:UIControlStateNormal];
        
        _type = _editeModel.type;
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           
            NSMutableArray *muArray = [[NSMutableArray alloc]init];
            
            for (int i = 0; i < _editeModel.photos.count; i++ ) {
                
                NSString *url = [_editeModel.photos objectAtIndex:i];
                
                UIImage *temimage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
                
                [muArray addObject:temimage];
                
                
            }
            
            _photos = muArray;
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
               
                self.addPhotoView.photosArray = muArray;
                
                
            });
            
            
        });
    }
    
    self.priceTextField.delegate = self;
    
    
    //获取当前位置
    [CommonMethods getCurrentLocation:^(BOOL success, NSString *address) {
       
        if (success) {
            
            self.locationLabel.text = [NSString stringWithFormat:@"所在地址:%@",address];
            
            
        }
    }];
    
    
}


-(void)publish
{
    
    [self.view endEditing:YES];
    
    
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
    
    
    CGFloat longitude = [[NSUserDefaults standardUserDefaults ] floatForKey:kCurrentLongitude];
    
    CGFloat latitude = [[NSUserDefaults standardUserDefaults] floatForKey:kCurrentLatitude];
    
    
    
    ErShouModel *model = [[ErShouModel alloc]init];
    
    BmobUser *currentUser = [BmobUser getCurrentUser];
    
    model.publisher = currentUser;
    
    model.des = _desTextView.text;
    
    model.photos = imgURLS;
    
    model.comments = @[];
    model.price = _priceTextField.text;
    
    if (longitude > 0 && latitude > 0) {
        
    
        BmobGeoPoint *point  = [[BmobGeoPoint alloc]initWithLongitude:longitude WithLatitude:latitude];
        
        model.location = point;
        
        
        
    }
    model.zan = @[];
    
    model.type = _type;
    
    
    
    
    BmobObject *_ErshouOb ;
    
    if (_isEdited) {
        
        
        _ErshouOb = [BmobObject objectWithoutDatatWithClassName:kErShou objectId:_editeModel.objectId];
        
        
        
    }
    else
    {
        _ErshouOb = [BmobObject objectWithClassName:kErShou];
        
        
    }
    
    
    [_ErshouOb setObject:model.publisher forKey:@"publisher"];
    [_ErshouOb setObject:model.des forKey:@"des"];
    [_ErshouOb setObject:model.photos forKey:@"photos"];
    [_ErshouOb setObject:model.comments forKey:@"comments"];
    [_ErshouOb setObject:model.location forKey:@"location"];
    [_ErshouOb setObject:model.zan forKey:@"zan"];
    [_ErshouOb setObject:model.type forKey:@"type"];
    [_ErshouOb setObject:model.price forKey:@"price"];
    
    
    if (_isEdited) {
       
        [_ErshouOb setObject:_editeModel.comments forKey:@"comments"];
        [_ErshouOb setObject:_editeModel.buyers forKey:@"buyers"];
        
        
        [_ErshouOb updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            
            if (isSuccessful) {
                
                
                [MyProgressHUD dismiss];
                
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    
                    
                    if ([vc isKindOfClass:[ErShouListTVC class]]) {
                        
                        
                        [self.navigationController popToViewController:vc animated:YES];
                        
                        
                    }
                }
              
                
                
                
                
            }
            
        }];
        
        
    }
    else
    {
        [_ErshouOb saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            
            
            if (isSuccessful) {
                
                
                [MyProgressHUD dismiss];
                
                [self.navigationController popViewControllerAnimated:YES];
                
                
                
                
            }
            
        }];
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

- (void)showActionSheet
{

    [self.view endEditing:YES];
    
}





- (IBAction)typeAction:(id)sender {
    
    
    ErShouTypeTVC *typeTVC = [[ErShouTypeTVC alloc]initWithStyle:UITableViewStylePlain];
    
    typeTVC.selectedType = _type;
    
    [typeTVC setBlock:^(BOOL success, NSString *typeString) {
        
        _type = typeString;
        
        [_typeButton setTitle:_type forState:UIControlStateNormal];
        
    }];
    
    
    [self.navigationController pushViewController:typeTVC animated:YES];
    
    
}


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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
