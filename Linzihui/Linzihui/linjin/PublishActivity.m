//
//  PublishActivity.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/26.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "PublishActivity.h"
#import "LocationViewController.h"

static NSString *textFieldCell = @"textFieldCell";
static NSString *labelCell    = @"labelCell";
static NSString *textViewCell  =@"textViewCell";
@interface PublishActivity ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,LocationViewDelegate>
{
     UIActionSheet *_pickPhotoActionSheet;
    
    NSMutableArray *_image_list;
    
    NSInteger _select_imageview_index;
    
    UIImage *addImage;
    
    UITapGestureRecognizer *_tapGesture;
    
    
    
    NSArray *_photoImageURLs;
    
    NSArray *_titlesArray;
    
   
    
    
    
    UIView *_view_pickDate;
    
    UIDatePicker *_picker;
    
    NSInteger pickIndex;
    
    BOOL hadShowedPicker;
    
    BmobObject *_huodongOB;
    
    
    
}
@end

@implementation PublishActivity

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
  
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"发布活动";
    
    self.view.backgroundColor = kBackgroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    _image_list = [[NSMutableArray alloc]init];
    
    self.photoFooterView.frame = CGRectMake(0, 0, ScreenWidth, 138);
    
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(publishHuoDong)];
    
    self.navigationItem.rightBarButtonItem = barButton;
    
//    UITapGestureRecognizer *_tag = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
//    
//    [self.tableView addGestureRecognizer:_tag];
    
    
    
     _huodongOB = [BmobObject objectWithClassName:kHuoDongTableName];
    addImage  = [UIImage imageNamed:@"tianjiazhaopian"];
    
    [_image_list addObject:addImage];
    
    [self reloadPhotoViews];
    

    _titlesArray = @[ @{@"title":@"真实姓名",@"content":@"",@"placeHolder":@"请输入真实姓名",@"key":@"realName"},
                    @{@"title":@"手机号",@"content":@"",@"placeHolder":@"请输入手机号码",@"key":@"phoneNum"},@{@"title":@"活动标题",@"content":@"",@"key":@"title"},
                     @{@"title":@"开始时间",@"content":@"",@"key":@"startTime"},
                      @{@"title":@"结束时间",@"content":@"",@"key":@"endTime"},
                     @{@"title":@"活动地址",@"content":@"",@"placeHolder":@"请输入地址",@"key":@"address"},
                      @{@"title":@"地图位置",@"content":@"",@"placeHolder":@"请输入地址",@"key":@"location"},
                     @{@"title":@"活动详情",@"content":@"",@"key":@"content"},
                  
                     @{@"title":@"截止报名时间",@"content":@"",@"key":@"endRegistTime"},
                     @{@"title":@"需要家庭数",@"content":@"",@"placeHolder":@"家庭数",@"key":@"needFamilyNum"},
                     @{@"title":@"年龄要求",@"content":@"",@"placeHolder":@"年龄要求",@"key":@"ageRequest"},
                     @{@"title":@"费用情况",@"content":@"",@"placeHolder":@"请输入费用",@"key":@"feeNum"},
                     @{@"title":@"活动特点",@"content":@"",@"key":@"TeDian"},
                     @{@"title":@"活动流程",@"content":@"",@"key":@"LiuCheng"},
                     @{@"title":@"注意事项",@"content":@"",@"key":@"ZhuYiShiXiang"}];
    
    

    
   
    [self initPickDateView];
    
    
}

-(void)initPickDateView
{
    _view_pickDate = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 250)];
    
    _view_pickDate.backgroundColor = kBackgroundColor;
    
    UIButton *sureButton = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 60, 0, 50, 40)];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    
    [sureButton setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [sureButton addTarget:self action:@selector(pickDate) forControlEvents:UIControlEventTouchUpInside];
    
    [_view_pickDate addSubview:sureButton];
    
    
    
    
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 50, 40)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(cancelPickDate) forControlEvents:UIControlEventTouchUpInside];
    [_view_pickDate addSubview:cancelButton];
    
    
    _picker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 50, ScreenWidth, 200)];
    
    _picker.datePickerMode = UIDatePickerModeDateAndTime;
    
    _picker.minimumDate = [NSDate date];
    
    [_view_pickDate addSubview:_picker];
    
    
    
}

-(void)showPickView
{
    
    [self.navigationController.view addSubview:_view_pickDate];
    hadShowedPicker = YES;
    
    [UIView animateWithDuration:0.5 animations:^{
       
        _view_pickDate.frame = CGRectMake(0, ScreenHeight - 250, ScreenWidth, 250);
        
        
    }];
}

-(void)dimissPickView
{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        _view_pickDate.frame = CGRectMake(0, ScreenHeight - 250, ScreenWidth, 250);
        
        
    }completion:^(BOOL finished) {
        
        hadShowedPicker = NO;
        
       [_view_pickDate removeFromSuperview];
    }];
    
    
    
    
}
-(void)pickDate
{
    NSDate *_date = _picker.date;
    
    NSString *_strDate = [CommonMethods getYYYYMMddhhmmDateStr:_date];
    
    NSMutableArray *muArray = [[NSMutableArray alloc]initWithArray:_titlesArray];
    
    NSMutableDictionary *muDict = [[NSMutableDictionary alloc]initWithDictionary:[muArray objectAtIndex:pickIndex]];
    
    
    [muDict setObject:_strDate forKey:@"content"];
    
    
    
    [muArray replaceObjectAtIndex:pickIndex withObject:muDict];
    
   _titlesArray = [NSArray arrayWithArray:muArray];
    
    
    [self.tableView reloadData];
    
    [self dimissPickView];
    
    
}

-(void)cancelPickDate
{
    [self dimissPickView];
    
}


#pragma mark - 发布
-(void)publishHuoDong
{
    

    for (int i = 0 ; i < _titlesArray.count; i++) {
        
        NSDictionary *dict = [_titlesArray objectAtIndex:i];
        
        NSString *title = [dict objectForKey:@"title"];
        
        NSString *content = [dict objectForKey:@"content"];
        
 
        
        if (content.length== 0) {
            
            [CommonMethods showDefaultErrorString:[NSString stringWithFormat:@"请填写%@",title]];
            
            return;
        }
    
        
        
    }
    [MyProgressHUD showProgress];
    
    if (_image_list.count > 1) {
        
        
        [CommonMethods upLoadPhotos:_image_list resultBlock:^(BOOL success, NSArray *results) {
           
            if (success) {
                
                
                [self upLoadData:results];
            }
            else
            {
                [MyProgressHUD dismiss];
                
                [CommonMethods showDefaultErrorString:@"图片上传失败，请重试"];
                
            }
            
        }];
    }
    else
    {
        [self upLoadData:nil];
        
    }
    
    

    
    
    
    
   
}

-(void)upLoadData:(NSArray*)imageURLs
{
    for (int i = 0 ; i < _titlesArray.count; i++) {
        
        NSDictionary *dict = [_titlesArray objectAtIndex:i];
        
        NSString *title = [dict objectForKey:@"title"];
        
        NSString *content = [dict objectForKey:@"content"];
        
        NSString *key = [dict objectForKey:@"key"];
        
        if (content.length== 0) {
            
            [CommonMethods showDefaultErrorString:[NSString stringWithFormat:@"请填写%@",title]];
            
            return;
        }
        
        if (![key isEqualToString:@"location"]) {
            
            [_huodongOB setObject:content forKey:key];
        }
        
        
        
        
    }
    
    [_huodongOB setObject:[BmobUser getCurrentUser] forKey:@"starter"];
    
    if (imageURLs.count > 0) {
        
        [_huodongOB setObject:imageURLs forKey:@"photoURL"];
        
    }
    [_huodongOB saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        
         [MyProgressHUD dismiss];
        
        if (isSuccessful) {
            
            NSLog(@"发布成功");
            
            [MyProgressHUD showError:@"发布成功"];
            
            [self.navigationController popViewControllerAnimated:YES];
            
            
        }
        else
        {
            NSLog(@"发布失败:%@",error);
            
            [CommonMethods showDefaultErrorString:@"发布失败，请重试"];
        }
    }];
}
-(void)hideKeyboard
{
    [self.view endEditing:YES];
    
}
#pragma mark - UITableViewDataSource 
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *blankView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 5)];
    
    blankView.backgroundColor = [UIColor clearColor];
    
    
    return blankView;
    
}
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

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    UITableViewCell *cell = nil;
    NSString *_cellId = nil;
    NSString *title = nil;
    NSString *content = nil;
    
    NSDictionary *dict = [_titlesArray objectAtIndex:indexPath.section];
    
    title = [dict objectForKey:@"title"];
    
    content = [dict objectForKey:@"content"];
    
    switch (indexPath.section) {
        case 0: //真实姓名
        {
            _cellId = textFieldCell;
          
        }
            break;
        case 1:  //手机号
        {
            _cellId = textFieldCell;
        }
            break;
            
        case 2: //活动标题
        {
            _cellId = textFieldCell;
        }
            break;
        case 3:  //开始时间
        {
            _cellId = labelCell;
        }
            break;
        case 4:  //开始时间
        {
            _cellId = labelCell;
        }
            break;
        case 5: //活动地址
        {
            _cellId = textFieldCell;
        }
            break;
        case 6: //地图位置
        {
            _cellId = labelCell;
            
        }
            break;
        case 7: //活动详情
        {
            _cellId = textViewCell;
            
        }
            break;
 
        case 8:  //截止报名时间
        {
            _cellId = labelCell;
            
        }
            break;
        case 9: //需要家庭数
        {
            _cellId = textFieldCell;
        }
            break;
        case 10:  //年龄要求
        {
            _cellId = textFieldCell;
        }
            break;
        case 11:  //费用情况
        {
            _cellId = textFieldCell;
        }
            break;
        case 12://活动特点
        {
            _cellId = textViewCell;
        }
            break;
        case 13: //活动流程
        {
            _cellId = textViewCell;
        }
            break;
        case 14:  //注意事项
        {
            _cellId = textViewCell;
            
        }
            break;
            
            
        default:
            break;
    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:_cellId];
    
    cell.contentView.tag = indexPath.section;
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        UILabel *titleLabel = (UILabel*)[cell viewWithTag:100];
        
        titleLabel.text = title;
        
        if ([[cell viewWithTag:101] isKindOfClass:[UITextField class]]) {
            
            
            UITextField *textField = (UITextField*)[cell viewWithTag:101];
            textField.delegate = self;
            
            textField.text = content;
            
            textField.placeholder = [dict objectForKey:@"placeHolder"];
            
            if (indexPath.section == 1 || indexPath.section == 9 ||  indexPath.section == 10 || indexPath.section == 11) {
                
                textField.keyboardType = UIKeyboardTypeNumberPad;
                
            }
            else
            {
                textField.keyboardType = UIKeyboardTypeDefault;
                
            }
            
        }
        
        if ([[cell viewWithTag:101] isKindOfClass:[UILabel class]]) {
            
            UILabel *contentLabel = (UILabel*)[cell viewWithTag:101];
            
            contentLabel.text = content;
        }
        
        if ([[cell viewWithTag:101] isKindOfClass:[UITextView class]]) {
            
            UITextView *textView = (UITextView*)[cell viewWithTag:101];
            
            textView.delegate = self;
            
            textView.text = content;
            

        }
        
        
        
    });
   
    
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    if (hadShowedPicker) {
        
        [self cancelPickDate];
        
    }
    
    [self.view endEditing:YES];
    
    if (indexPath.section == 3 ||  indexPath.section == 4 ||  indexPath.section == 8) {
        
        
        pickIndex = indexPath.section;
        
        if (!hadShowedPicker) {
            
            [self showPickView];
            
        }
        
    }
    
    if (indexPath.section == 6) {
        
        LocationViewController *_locateVC = [LocationViewController defaultLocation];
        
        _locateVC.delegate = self;
        
        
        [self.navigationController pushViewController:_locateVC animated:YES];
        
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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


#pragma mark - UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    

    

    
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (hadShowedPicker) {
        
        [self cancelPickDate];
        
    }
    
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSMutableArray *muArray = [[NSMutableArray alloc]initWithArray:_titlesArray];
    
    NSInteger tag = [textField superview].tag;
    
    NSDictionary *dict = [muArray objectAtIndex:tag];
    
    NSMutableDictionary *muDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
    
    if (textField.text.length > 0) {
        
        [muDict setObject:textField.text forKey:@"content"];
    }
    
    [muArray replaceObjectAtIndex:tag withObject:muDict];
    
    _titlesArray = [NSArray arrayWithArray:muArray];
    
    
    
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    
    return YES;
    
}

#pragma mark - UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (hadShowedPicker) {
        
        [self cancelPickDate];
        
    }
}
-(void)textViewDidChange:(UITextView *)textView
{
    
 
    
    NSMutableArray *muArray = [[NSMutableArray alloc]initWithArray:_titlesArray];
    
    NSInteger tag = [textView superview].tag;
    
    NSDictionary *dict = [muArray objectAtIndex:tag];
    
    NSMutableDictionary *muDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
    
    if (textView.text.length > 0) {
        
        [muDict setValue:textView.text forKey:@"content"];
    }
    
    [muArray replaceObjectAtIndex:tag withObject:muDict];
    
   _titlesArray = [NSArray arrayWithArray:muArray];
    
}


#pragma mark - LocationViewDelegate
-(void)sendLocationLatitude:(double)latitude longitude:(double)longitude andAddress:(NSString *)address
{
    BmobGeoPoint *point = [[BmobGeoPoint alloc]initWithLongitude:longitude WithLatitude:latitude];
    
    point.latitude = latitude;
    point.longitude = longitude;
    
    
    if (latitude > 0) {
        
        [_huodongOB setObject:point forKey:@"location"];
        
    }
    NSString *locationStr = [NSString stringWithFormat:@"纬度%.2f  经度%.2f",latitude,longitude];
    
    NSMutableArray *muArray = [[NSMutableArray alloc]initWithArray:_titlesArray];
    
    NSInteger tag = 6;
    
    NSDictionary *dict = [muArray objectAtIndex:tag];
    
    NSMutableDictionary *muDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
    
    if (locationStr.length > 0) {
        
        [muDict setValue:locationStr forKey:@"content"];
        
        
    }
    
    [muArray replaceObjectAtIndex:tag withObject:muDict];
    
    _titlesArray = [NSArray arrayWithArray:muArray];
    
    [self.tableView reloadData];
    
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
