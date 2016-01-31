//
//  PublishActivity.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/26.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "PublishActivity.h"
#import "LocationViewController.h"
#import "HuodongTVCViewController.h"
#import "ActivityDetailViewController.h"



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
    
    
    UIImage *backGroundImage;
    
    BOOL isPickBackImage;
    
    
   

    
    UIView *_view_pickDate;
    
    UIDatePicker *_picker;
    
    NSInteger pickIndex;
    
    BOOL hadShowedPicker;
    
    BmobObject *_huodongOB;
    
    BOOL hadShowedImage;
    
    BOOL hadChangedDetailImage;
    
    BOOL hadChangeBackGroundImage;
    
    
   
    
    
    
}
@end

@implementation PublishActivity

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
  
    
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    

    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
    [self cancelPickDate];
    
  
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"发布活动";
    
    self.view.backgroundColor = kBackgroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    _image_list = [[NSMutableArray alloc]init];
    
    self.headerView.frame = CGRectMake(0, 0, ScreenWidth, 70);
    
    

    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navbar_return_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
    
//    UITapGestureRecognizer *_tag = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
//    
//    [self.tableView addGestureRecognizer:_tag];

    
    
    addImage  = [UIImage imageNamed:@"tianjiazhaopian"];

    
    
    if (_isEdited) {
       
        _huodongOB = [BmobObject objectWithoutDatatWithClassName:kHuoDongTableName objectId:_huodongModel.objectId];
        
        
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(publishHuoDong)];
        
        self.navigationItem.rightBarButtonItem = barButton;
        
        
        
        NSString *locationStr = [NSString stringWithFormat:@"纬度:%.2f 经度:%.2f",[[_huodongModel.location valueForKey:@"latitude"]floatValue],[[_huodongModel.location valueForKey:@"longitude"]floatValue]];
        
        
        _titlesArray = @[ @{@"title":@"组织者实名",@"content":_huodongModel.realName,@"placeHolder":@"请输入真实姓名",@"key":@"realName"},
                          @{@"title":@"手机号",@"content":_huodongModel.phoneNum,@"placeHolder":@"请输入手机号码",@"key":@"phoneNum"},@{@"title":@"活动标题",@"content":_huodongModel.title,@"key":@"title"},
                          @{@"title":@"开始时间",@"content":_huodongModel.startTime,@"key":@"startTime"},
                          @{@"title":@"结束时间",@"content":_huodongModel.endTime,@"key":@"endTime"},
                          @{@"title":@"活动地址",@"content":_huodongModel.address,@"placeHolder":@"请输入地址",@"key":@"address"},
                          @{@"title":@"地图位置",@"content":locationStr,@"placeHolder":@"请输入地址",@"key":@"location"},
                          @{@"title":@"活动详情",@"content":_huodongModel.content,@"key":@"content"},
                          
                          @{@"title":@"截止报名时间",@"content":_huodongModel.endRegistTime,@"key":@"endRegistTime"},
                          @{@"title":@"需要家庭数",@"content":_huodongModel.needFamilyNum,@"placeHolder":@"家庭数",@"key":@"needFamilyNum"},
                          @{@"title":@"年龄要求",@"content":_huodongModel.ageRequest,@"placeHolder":@"年龄要求",@"key":@"ageRequest"},
                          @{@"title":@"费用情况",@"content":_huodongModel.feeNum,@"placeHolder":@"请输入费用",@"key":@"feeNum"}];
        
         [_backGroundImageButton sd_setImageWithURL:[NSURL URLWithString:_huodongModel.backImage] forState:UIControlStateNormal placeholderImage:kDefaultLoadingImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
             
             backGroundImage = image;
             
         }];
        
      
        BmobGeoPoint *point = [[BmobGeoPoint alloc]initWithLongitude:[[_huodongModel.location valueForKey:@"longitude"]floatValue] WithLatitude:[[_huodongModel.location valueForKey:@"latitude"]floatValue]];
        
        point.latitude = [[_huodongModel.location valueForKey:@"latitude"]floatValue];
        point.longitude = [[_huodongModel.location valueForKey:@"longitude"]floatValue];
        
        
        if ([[_huodongModel.location valueForKey:@"latitude"]floatValue] > 0) {
            
            [_huodongOB setObject:point forKey:@"location"];
            
        }
        
        
    }
    else
    {

         _huodongOB = [BmobObject objectWithClassName:kHuoDongTableName];
        
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(publishHuoDong)];
        
        self.navigationItem.rightBarButtonItem = barButton;
        
        
    _titlesArray = @[ @{@"title":@"组织者实名",@"content":@"",@"placeHolder":@"请输入真实姓名",@"key":@"realName"},
                    @{@"title":@"手机号",@"content":@"",@"placeHolder":@"请输入手机号码",@"key":@"phoneNum"},@{@"title":@"活动标题",@"content":@"",@"key":@"title"},
                     @{@"title":@"开始时间",@"content":@"",@"key":@"startTime"},
                      @{@"title":@"结束时间",@"content":@"",@"key":@"endTime"},
                     @{@"title":@"活动地址",@"content":@"",@"placeHolder":@"请输入地址",@"key":@"address"},
                      @{@"title":@"地图位置",@"content":@"",@"placeHolder":@"请输入地址",@"key":@"location"},
                     @{@"title":@"活动详情",@"content":@"",@"key":@"content"},
                  
                     @{@"title":@"截止报名时间",@"content":@"",@"key":@"endRegistTime"},
                     @{@"title":@"需要家庭数",@"content":@"",@"placeHolder":@"家庭数",@"key":@"needFamilyNum"},
                     @{@"title":@"年龄要求",@"content":@"",@"placeHolder":@"年龄要求",@"key":@"ageRequest"},
                     @{@"title":@"费用情况",@"content":@"",@"placeHolder":@"请输入费用",@"key":@"feeNum"}];
    
    
        
        
      
        
       
        
    }
    
   
    [self initPickDateView];
    
    
}

-(void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
    
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
    
    
    //活动结束时间 要在活动给开始之后
    if ( pickIndex == 4 ) {
        
        NSMutableDictionary *muDict = [[NSMutableDictionary alloc]initWithDictionary:[_titlesArray objectAtIndex:3]];
        
        NSDate *  date = [muDict objectForKey:@"content"];
        
        _picker.minimumDate = date;
        
        
    }
    
    
    //报名截止时间要在开始之后 结束之前
    if (pickIndex == 8) {
        
        NSMutableDictionary *muDict = [[NSMutableDictionary alloc]initWithDictionary:[_titlesArray objectAtIndex:3]];
        
        NSDate *  date = [muDict objectForKey:@"content"];
        
        _picker.minimumDate = date;
        
        
        NSMutableDictionary *endDict = [[NSMutableDictionary alloc]initWithDictionary:[_titlesArray objectAtIndex:4]];
        
        NSDate *  endDate = [endDict objectForKey:@"content"];
        
        
        _picker.maximumDate = endDate;
        
        
    }
    
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
    
//    NSString *_strDate = [CommonMethods getYYYYMMddhhmmDateStr:_date];
    
    NSMutableArray *muArray = [[NSMutableArray alloc]initWithArray:_titlesArray];
    
    NSMutableDictionary *muDict = [[NSMutableDictionary alloc]initWithDictionary:[muArray objectAtIndex:pickIndex]];
    
    
    [muDict setObject:_date forKey:@"content"];
    
    
    
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
    
    [self.view endEditing:YES];
    
    
    if (!backGroundImage) {
        
        [CommonMethods showDefaultErrorString:@"请上传活动背景图片"];
        
        return;
        
    }

    for (int i = 0 ; i < _titlesArray.count; i++) {
        
        NSDictionary *dict = [_titlesArray objectAtIndex:i];
        
        NSString *title = [dict objectForKey:@"title"];
          NSString *key = [dict objectForKey:@"key"];
//        NSString *content = [dict objectForKey:@"content"];
        

        
        id   content =  [dict objectForKey:@"content"];
        
        
        
        if ([key isEqualToString:@"startTime"] || [key isEqualToString:@"endTime"] || [key isEqualToString:@"endRegistTime"])
        {
            
            if (!content) {
                
                 [CommonMethods showDefaultErrorString:[NSString stringWithFormat:@"请填写%@",title]];
                
            }
            
        }
        else
        {
            NSString * temcontent  = [dict objectForKey:@"content"];
            
            if (temcontent.length== 0) {
                
                [CommonMethods showDefaultErrorString:[NSString stringWithFormat:@"请填写%@",title]];
                
                return;
            }
            
            
            
        }
    
        
        
    }
   
    
    if (_isEdited) {
        
        if (_image_list.count > 0) {
            
            [MyProgressHUD showProgress];
            
            
            if (hadChangeBackGroundImage) {
                
                //先上传背景图片
                [self upLoadBackGroundImage];
                
            }
            else
            {
                //直接跳到活动详情
                [self upLoadDetailImage:nil];
                
            }
            
            
        }
        else
        {
            [CommonMethods showDefaultErrorString:@"请上传活动图片"];
            
            return;
            
            
        }
    }
    
    else
    {
        
   
    if (_image_list.count > 0) {
        
         [MyProgressHUD showProgress];
        
        
        
        //先上传背景图片
        [self upLoadBackGroundImage];
        
        
     
    }
    else
    {
        [CommonMethods showDefaultErrorString:@"请上传活动图片"];
        
        return;
        
        
    }
        
    }
    
    
    
    
    
    
   
}

#pragma mark - 上传活动详情图片
-(void)upLoadDetailImage:(NSString*)backGroundImageURL
{
    
    
    //如果是编辑状态
    if (_isEdited) {
        
        
        //没有修改详情图片
        if (!hadChangedDetailImage) {
            
            
            [self upLoadData:nil backImageURL:backGroundImageURL];
            
            return;
            
        }
    }

 
    
    [CommonMethods upLoadPhotos:_image_list resultBlock:^(BOOL success, NSArray *results) {
        
        if (success) {
            
            
            [self upLoadData:results backImageURL:backGroundImageURL];
            

            
        }
        else
        {
            [MyProgressHUD dismiss];
            
            [CommonMethods showDefaultErrorString:@"图片上传失败，请重试"];
            
        }
        
    }];
}
#pragma mark -  上传背景图片
-(void)upLoadBackGroundImage
{
    
    NSArray *backArray = @[backGroundImage];
    
    
    [CommonMethods upLoadPhotos:backArray resultBlock:^(BOOL success, NSArray *results) {
        
        if (success) {
            
            
            if (results.count > 0) {
                
                NSString *backImageStr = [results firstObject];
                
                //然后上传活动详情图片
                [self upLoadDetailImage:backImageStr];
                
            }
            else
            {
                [MyProgressHUD dismiss];
                
                [CommonMethods showDefaultErrorString:@"图片上传失败，请重试"];
            }
        }
        else
        {
            [MyProgressHUD dismiss];
            
            [CommonMethods showDefaultErrorString:@"图片上传失败，请重试"];
            
        }
        
    }];
}

-(void)upLoadData:(NSArray*)imageURLs    backImageURL:(NSString*)backImageURL
{
    for (int i = 0 ; i < _titlesArray.count; i++) {
        
        NSDictionary *dict = [_titlesArray objectAtIndex:i];
        
        NSString *title = [dict objectForKey:@"title"];
         NSString *key = [dict objectForKey:@"key"];
        
        id   content =  [dict objectForKey:@"content"];
        
        
        
        if ([key isEqualToString:@"startTime"] || [key isEqualToString:@"endTime"] || [key isEqualToString:@"endRegistTime"])
        {
            
            
            
        }
        else
        {
          NSString * temcontent  = [dict objectForKey:@"content"];
            
            if (temcontent.length== 0) {
                
                [CommonMethods showDefaultErrorString:[NSString stringWithFormat:@"请填写%@",title]];
                
                return;
            }
            
        
            
        }
        
       
        
    
        
        if (![key isEqualToString:@"location"]) {
            
            [_huodongOB setObject:content forKey:key];
        }
        
        
        
        
    }
    
    [_huodongOB setObject:[BmobUser getCurrentUser] forKey:@"starter"];
    
    //如果是群发起来的加 groupId
    if (_groupId.length > 0) {
        
        [_huodongOB setObject:_groupId forKey:@"groupId"];
        
    }
    
    
    if (imageURLs.count > 0) {
        
        [_huodongOB setObject:imageURLs forKey:@"photoURL"];
        
    }
    
    //背景图片地址
    if (backImageURL.length > 0) {
        
        [_huodongOB setObject:backImageURL forKey:@"backImage"];
        
        
    }
  
    
    
    //如果是编辑
    if (_isEdited) {
        
        
        [_huodongOB updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
           
            if (isSuccessful) {
                
                [MyProgressHUD showError:@"保存成功"];
                
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    
                    if ([vc isKindOfClass:[HuodongTVCViewController class]]) {
                        
                         [self.navigationController popToViewController:vc animated:YES];
                        
                    }
                }
               
                
            }
            
        }];
    }
    else
    {
        [_huodongOB saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            
            [MyProgressHUD dismiss];
            
            if (isSuccessful) {
                
                NSLog(@"发布成功");
                
                [MyProgressHUD showError:@"发布成功"];
                
                
                [self createMessageWithOB:_huodongOB];
                
                
                
            }
            else
            {
                NSLog(@"发布失败:%@",error);
                
                [CommonMethods showDefaultErrorString:@"发布失败，请重试"];
            }
        }];
    }
    

}


#pragma mark - 创建活动消息

-(void)createMessageWithOB:(BmobObject*)ob
{
    
    NSString *message = @"您参加了该活动";
    NSString *username = [BmobUser getCurrentUser].username;
    NSString *title = nil;
    
    
    
    for (int i = 0 ; i < _titlesArray.count; i++) {
        
        NSDictionary *dict = [_titlesArray objectAtIndex:i];
        
   
        NSString *key = [dict objectForKey:@"key"];
        
        id   content =  [dict objectForKey:@"content"];
        
        if ([key isEqualToString:@"title"]) {
            
            title = content;
            
        }
        
    }
 
    [BmobHelper createHuodongMessage:ob message:message status:MessageStatusPublish username:username title:title result:^(BOOL success) {
       
        if (success) {
            
            NSLog(@"messageCreat success");
            
        }
        else
        {
            NSLog(@"message create failed");
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
        
        
    }];
}

-(void)hideKeyboard
{
    [self.view endEditing:YES];
    
}
#pragma mark - UITableViewDataSource 
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *blankView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    
    blankView.backgroundColor = [UIColor clearColor];
    
    
    return blankView;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 7 || indexPath.section == 12 || indexPath.section == 13 || indexPath.section == 14) {
        
        return 70;
    }
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
    
    if (indexPath.section == 3 || indexPath.section == 4 || indexPath.section == 8) {
        
        NSDate *date = [dict objectForKey:@"content"];
        
        content = [CommonMethods getYYYYMMddhhmmDateStr:date];
        
    }
    else
    {
        content = [dict objectForKey:@"content"];
    }
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
            _cellId = labelCell;
            
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
            
            if (indexPath.section == 1 || indexPath.section == 9  || indexPath.section == 11) {
                
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
        
        
        
        //如果选择截止时间和结束时间 先判断是否有开始时间
        if (indexPath.section == 4 || indexPath.section == 8) {
            
            NSMutableDictionary *muDict = [[NSMutableDictionary alloc]initWithDictionary:[_titlesArray objectAtIndex:3]];
            
            id  date = [muDict objectForKey:@"content"];
            
            if (![date isKindOfClass:[NSDate class]]) {
                
                
                [CommonMethods showDefaultErrorString:@"请先选择活动开始时间"];
                
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                
                return;
            }
            
        }
        
        
        
        pickIndex = indexPath.section;
        
        if (!hadShowedPicker) {
            
            [self showPickView];
            
        }
        
    }
    
    if (indexPath.section == 6) {
        
        LocationViewController *_locateVC = [LocationViewController defaultLocation];
        
        _locateVC.delegate = self;
        _locateVC.showSearchBar = YES;
        
        
        [self.navigationController pushViewController:_locateVC animated:YES];
        
        
    }
    
    if (indexPath.section == 7) {
        
        ActivityDetailViewController *_detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivityDetailViewController"];
        
        _detailVC.hidesBottomBarWhenPushed = YES;
        
        [_detailVC setBlock:^(NSMutableArray *imagesArray, NSString *detail) {
           
            if (imagesArray.count > 0) {
                
                hadChangedDetailImage = YES;
                
            }
            [_image_list removeAllObjects];
        
            [_image_list addObjectsFromArray:imagesArray];
            
            
            NSMutableArray *muArray = [[NSMutableArray alloc]initWithArray:_titlesArray];
            
            NSInteger tag = 7;
            
            NSDictionary *dict = [muArray objectAtIndex:tag];
            
            NSMutableDictionary *muDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
            
            if (detail.length > 0) {
                
                [muDict setObject:detail forKey:@"content"];
            }
            
            [muArray replaceObjectAtIndex:tag withObject:muDict];
            
            _titlesArray = [NSArray arrayWithArray:muArray];
            
            [self.tableView reloadData];
            
            
        }];
        
        NSDictionary *dict = [_titlesArray objectAtIndex:7];
        _detailVC.detailStr = [dict objectForKey:@"content"];
        _detailVC.image_list = _image_list;
        
        if (_isEdited) {
            
            _detailVC.photoURLs = _huodongModel.photoURL;
            
        }
        [self.navigationController pushViewController:_detailVC animated:YES];
        
        
    }
    
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (IBAction)photoButtonAction:(id)sender {
    
    

    [self.view endEditing:YES];
    
    isPickBackImage = NO;
    
    
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










-(void)setButtonImageWithTag:(NSInteger)tag image:(UIImage*)image
{
    
  
    
    for (UIButton *button in _photoFooterView.subviews) {
        
        if (button.tag == tag + 1 ) {
            
            [button setImage:image forState:UIControlStateNormal];
            
        }
       
    }
}






#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
     image = [CommonMethods autoSizeImageWithImage:image];
    
    if (isPickBackImage) {
        
        hadChangeBackGroundImage = YES;
        
        backGroundImage = image;
        
        [_backGroundImageButton setImage:backGroundImage forState:UIControlStateNormal];
        
        
    }
  
    
    
    
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
        
        
   
            if (buttonIndex == 2)
            {
                
                
                if (isPickBackImage)
                {
                    
                    backGroundImage = nil;
                    
                    [_backGroundImageButton setImage:addImage forState:UIControlStateNormal];
                    
                    
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





- (IBAction)changeBackImageAction:(id)sender {
    
    
     [self.view endEditing:YES];
    
    isPickBackImage = YES;
    
    _pickPhotoActionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    
    [_pickPhotoActionSheet addButtonWithTitle:@"相册图片描述"];
    [_pickPhotoActionSheet addButtonWithTitle:@"手机拍照描述"];
    [_pickPhotoActionSheet addButtonWithTitle:@"删除"];
    
    [_pickPhotoActionSheet addButtonWithTitle:@"取消"];
    
    _pickPhotoActionSheet.cancelButtonIndex = 3;
    
    [_pickPhotoActionSheet showInView:self.view];
    
    
    
    
}
@end
