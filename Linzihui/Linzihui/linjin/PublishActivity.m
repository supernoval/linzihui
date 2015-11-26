//
//  PublishActivity.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/26.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "PublishActivity.h"

@interface PublishActivity ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
     UIActionSheet *_pickPhotoActionSheet;
    
    NSMutableArray *_image_list;
    
    NSInteger _select_imageview_index;
    
    UIImage *addImage;
    
    UITapGestureRecognizer *_tapGesture;
    
    
    
    NSArray *_photoImageURLs;
    
    NSArray *_titlesArray;
    
    
    
    
    
}
@end

@implementation PublishActivity

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"发布活动";
    
    self.photoFooterView.frame = CGRectMake(0, 0, ScreenWidth, 124);
    
    
    addImage  = [UIImage imageNamed:@"tianjiazhaopian"];
    
    
    _titlesArray = @[@{@"title":@"活动标题",@"content":@""},
                     @{@"title":@"活动时间",@"content":@""},
                     @{@"title":@"活动地址",@"content":@""},
                     @{@"title":@"活动详情",@"content":@""},
                     @{@"title":@"真实姓名",@"content":@""},
                     @{@"title":@"手机号",@"content":@""},
                     @{@"title":@"截止报名时间",@"content":@""},
                     @{@"title":@"需要家庭数",@"content":@""},
                     @{@"title":@"年龄要求",@"content":@""},
                     @{@"title":@"费用情况",@"content":@""},
                     @{@"title":@"活动特点",@"content":@""},
                     @{@"title":@"活动流程",@"content":@""},
                     @{@"title":@"注意事项",@"content":@""},];
    
    
}

#pragma mark - UITableViewDataSource 
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 44;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _titlesArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
    
}



- (IBAction)photoButtonAction:(id)sender {
    
    

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
    for (UIButton *button in _photoFooterView.subviews) {
        
        if (button.tag == tag +1 ) {
            
            [button setImage:image forState:UIControlStateNormal];
            
        }
    }
}

-(void)setButtonEnAble
{
    for (UIButton *button in _photoFooterView.subviews) {
        
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
