//
//  HuoDongDetailTVC.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/12/18.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "HuoDongDetailTVC.h"
#import "PhotoCell.h"
#import "EaseMob.h"
#import "EMHelper.h"
#import "ChatViewController.h"

@interface HuoDongDetailTVC ()<UITextFieldDelegate>
{
    UIToolbar *_myToolBar;
    
    
    UIView *_uiview_comment;
    
    UITextField *_textField_comment;
    
}
@end

@implementation HuoDongDetailTVC

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.title = @"活动详情";
    
    _myToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, ScreenHeight - 52, ScreenWidth, 52)];
    UIBarButtonItem *common = [[UIBarButtonItem alloc]initWithTitle:@"评论" style:UIBarButtonItemStylePlain target:self action:@selector(showCommentView)];
    
    UIBarButtonItem *flex = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *flex1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *flex2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *sign = [[UIBarButtonItem alloc]initWithTitle:@"签到" style:UIBarButtonItemStylePlain target:self action:@selector(sign)];
    
    _myToolBar.items = @[flex,common,flex1,sign,flex2];
    
    
    
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
  
    [self initdata];
    
    [self initCommentView];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [self.navigationController.view addSubview:_myToolBar];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
    [_myToolBar removeFromSuperview];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}


-(void)initCommentView
{
    _uiview_comment = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 50)];
    
    _uiview_comment.backgroundColor = kBackgroundColor;
    
    _uiview_comment.layer.borderColor = kLineColor.CGColor;
    
    _textField_comment = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth - 80, 30)];
    _textField_comment.borderStyle = UITextBorderStyleRoundedRect;
    _textField_comment.backgroundColor = [UIColor whiteColor];
    
    _textField_comment.delegate = self;
    
    [_uiview_comment addSubview:_textField_comment];
    
    
    UIButton *sendButton = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 60, 10, 50, 30)];
    
    [sendButton addTarget:self action:@selector(coment) forControlEvents:UIControlEventTouchUpInside];
    
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    
    sendButton.backgroundColor = kNavigationBarColor;
    
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [sendButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    
    sendButton.clipsToBounds = YES;
    
    sendButton.layer.cornerRadius = 5;
    
    [_uiview_comment addSubview:sendButton];
    
    
    
    
    
    
}

-(void)showCommentView
{
    
    [self.navigationController.view addSubview:_uiview_comment];
    
    [_textField_comment becomeFirstResponder];
    
}

-(void)coment
{
    
    if (_textField_comment.text.length == 0) {
        
        return;
        
    }
    
    UserModel *_usermodel = [BmobHelper getCurrentUserModel];
    
    
    CommentModel *model = [[CommentModel alloc]init];
    
    model.nick = _usermodel.nickName;
    
    model.username = _usermodel.username;
    
    model.headImageURL = _usermodel.headImageURL;
    
    model.content = _textField_comment.text;
    
    if (!model.headImageURL) {
        
        model.headImageURL = @"";
        
    }
    if (!model.nick) {
        
        model.nick = @"";
        
    }
    NSDictionary *dic = [model toDictionary];
    BmobObject *_huodongOB = [BmobObject objectWithoutDatatWithClassName:kHuoDongTableName objectId:_huodong.objectId];
    
    [_huodongOB addObjectsFromArray:@[dic] forKey:@"comment"];
    
    [MyProgressHUD showProgress];
    
    
    [_textField_comment resignFirstResponder];
    
    
    
    [_huodongOB updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        
        [MyProgressHUD dismiss];
        
        
       
        if (isSuccessful) {
            
            NSMutableArray *muArray = [[NSMutableArray alloc]init];
            
            [muArray addObjectsFromArray:_huodong.comment];
            
            [muArray addObject:dic];
            
            _huodong.comment = muArray;
            
            
            [self.tableView reloadData];
            
            
            
        }
    }];
    
    
}
-(void)sign
{
    UserModel *_currentUserModel = [BmobHelper getCurrentUserModel];
    
    BOOL inside = NO;
    
    for (NSDictionary *dic in _huodong.qiandao) {
        
        NSString *username = [dic objectForKey:@"userName"];
        
        if ([username isEqualToString:_currentUserModel.username]) {
            
            inside = YES;
        }
    }
    
    if (!inside) {
        
        BmobObject *ob = [BmobObject objectWithoutDatatWithClassName:kHuoDongTableName objectId:_huodong.objectId];
        
        AttendUserModel *model = [[AttendUserModel alloc]init];
        
        model.headImageURL = _currentUserModel.headImageURL;
        
        model.nickName = _currentUserModel.nickName;
        
        model.userName = _currentUserModel.username;
        
        
        NSDictionary *dic = [model toDictionary];
        
        [ob addObjectsFromArray:@[dic] forKey:@"qiandao"];
        
        [ob updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
           
            if (isSuccessful) {
                
                NSMutableArray *muArray = [[NSMutableArray alloc]init];
                
                [muArray addObjectsFromArray: _huodong.qiandao];
                
                [muArray addObject:dic];
                
                _huodong.qiandao = muArray;
                
                [self.tableView reloadData];
                
                
                
            }
        }];
        
        
    }
}
-(void)initdata
{
    
     _headerView.frame = CGRectMake(0, 0, ScreenWidth, 450);
    
    _titleLabel.text = _huodong.title;
    
    _addressLabel.text = _huodong.address;
    
    _timeLabel.text = [CommonMethods getYYYYMMddhhmmDateStr:_huodong.startTime];
    
    _feelabel.text = _huodong.feeNum;
    
    _distanceLabel.text = [CommonMethods distanceStringWithLatitude:[[_huodong.location valueForKey:@"latitude"]floatValue] longitude:[[_huodong.location valueForKey:@"longitude"]floatValue]];
    _publisher.text = _huodong.realName ;
    
    _detailLabel.text = _huodong.content;
    
    _tedianLabel.text = _huodong.TeDian;
    
    _liuchengLabel.text = _huodong.LiuCheng;
    
    _shixianglabel.text = _huodong.ZhuYiShiXiang;
    
    _endRegistTimeLabel.text = [CommonMethods getYYYYMMddhhmmDateStr: _huodong.endRegistTime];
    
     _numLabel.text = [NSString stringWithFormat:@"%ld人已参加",(long)_huodong.AttendUsers.count];
    
    
   
    
    NSInteger status = [CommonMethods activityStatusWithStartTime:_huodong.startTime endTime:_huodong.endTime];
    
    if (status == 1) {
        
        
        _statusLabel.text =[NSString stringWithFormat:@"离活动开始:%@",[CommonMethods timeStringFromNow:_huodong.startTime]];
        
        
        
        
    }
    if (status == 2) {
        
        _statusLabel.text = @"活动进行中";
    }
    if (status == 3) {
        
        _statusLabel.text = @"活动已结束";
        
        
    }
    
    if (_huodong.groupId.length == 0) {
        
        _checkButton.hidden = YES;
        
    }
    else
    {
        _checkButton.hidden = NO;
        
        
    }
    
    
    if ([self hadAttend:_huodong]) {
        
        _attendButton.enabled = NO;
        
        [_attendButton setTitle:@"已报名" forState:UIControlStateNormal];
        
    }
    
    else
    {
        
        
        
        _attendButton.enabled = YES;
        
        [_attendButton setTitle:@"报名参加" forState:UIControlStateNormal];
        
        
      
        
        
    }
    
    
    NSInteger registStatus = [CommonMethods activityRegistStatus:_huodong.endRegistTime];
    
    if (registStatus == 2) {
        
        _attendButton.enabled = NO;
        
        [_attendButton setTitle:@"报名已截止" forState:UIControlStateNormal];
        
        
    }
    else
    {
        _attendButton.enabled = YES;
        
      
        
    }
    
    
    if ([[BmobUser getCurrentUser].username isEqualToString:[_huodong.starter objectForKey:@"username"]]) {
        
        _attendButton.enabled = NO;
        
    }
    
    
    
    
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *blanckView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 52)];
    
    blanckView.backgroundColor = [UIColor clearColor];
    
    
    return blanckView;
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        return nil;
    }
    
    UILabel *label = [CommonMethods LabelWithText:@"评论" andTextAlgniment:NSTextAlignmentLeft andTextColor:[UIColor blackColor] andTextFont:FONT_16 andFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    
    if (section == 1) {
        
        if (_huodong.AttendUsers.count > 0) {
            
             label.text = @"  参与人员";
        }
        else
        {
            label.text = @"";
            
        }
       
    }
    
    if (section == 2) {
        
        if (_huodong.comment.count > 0) {
            
            label.text = @"  评论";
        }
        else
        {
            label.text = @"";
        }
        
    }
    if (section == 3) {
        
        if (_huodong.qiandao.count > 0) {
            
           label.text = @"  签到";
        }
        else
        {
            label.text = @"";
            
        }
        
    }
    
    return label;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    if (section == 3) {
        
        return 52;
    }
    
    return 0;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1 || section == 2 || section == 3) {
        
        return 20;
    }
    
    return 0;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        CGFloat photoViewHeight = 0;
        
        NSArray *imgs = _huodong.photoURL;
        
        long imageCount = imgs.count;
        int perRowImageCount = ((imageCount == 4) ? 2 : 3);
        CGFloat perRowImageCountF = (CGFloat)perRowImageCount;
        int totalRowCount = ceil(imageCount / perRowImageCountF);
        
        photoViewHeight = 95 * totalRowCount;
        
        return photoViewHeight;
        
        
    }
    
 
    
    
    
    return 50;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 1;
    }
    if (section == 1) {
        
      return _huodong.AttendUsers.count;
    }
    
    if (section == 2) {
        
      return _huodong.comment.count;
    }
    
    return _huodong.qiandao.count;
    
    
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section == 0) {
        
        PhotoCell *_photoCell = [tableView dequeueReusableCellWithIdentifier:@"photoCell"];
        
        _photoCell.imagesView.photoItemArray = _huodong.photoURL;
        
        
        
        return _photoCell;
        
    }
    
    
    if (indexPath.section == 1) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellId"];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            NSArray *personsArray = _huodong.AttendUsers;
            
            NSDictionary *onePerson = [personsArray objectAtIndex:indexPath.row];
            
            AttendUserModel * _usermodel = [[AttendUserModel alloc]init];
            
            [_usermodel setValuesForKeysWithDictionary:onePerson];
            
            UIImageView *imageView = (UIImageView*)[cell viewWithTag:100];
            
            
            UILabel *label = (UILabel*)[cell viewWithTag:101];
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:_usermodel.headImageURL] placeholderImage:kDefaultHeadImage];
            
            
            label.text = _usermodel.nickName;
            
            if (!_usermodel.nickName) {
                
                label.text = _usermodel.userName;
                
            }
            
            
            
            
            
            
        });
        
        
        return cell;
    }

  
    if (indexPath.section == 2) {
        
        
    
    UITableViewCell *commentCel = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        if (_huodong.comment.count > indexPath.row) {
            
            NSDictionary *dic = [_huodong.comment objectAtIndex:indexPath.row];
            
            CommentModel *_commentModel = [[CommentModel alloc]init];
            
            [_commentModel setValuesForKeysWithDictionary:dic];
            
            
            UIImageView *headImageView = (UIImageView*)[commentCel viewWithTag:100];
            
            UILabel *nameLabel = (UILabel*)[commentCel viewWithTag:101];
            
            UILabel *commentlabel = (UILabel*)[commentCel viewWithTag:102];
            
            
            [headImageView sd_setImageWithURL:[NSURL URLWithString:_commentModel.headImageURL] placeholderImage:kDefaultHeadImage];
            
            nameLabel.text = _commentModel.nick;
            
            if (!nameLabel.text) {
                
                nameLabel.text = _commentModel.username;
                
            }
            
            commentlabel.text = _commentModel.content;
            
        }
      
        
        
        
    });
    
    return commentCel;
        
        }
    
    
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellId"];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        NSArray *personsArray = _huodong.qiandao;
        
        NSDictionary *onePerson = [personsArray objectAtIndex:indexPath.row];
        
        AttendUserModel * _usermodel = [[AttendUserModel alloc]init];
        
        [_usermodel setValuesForKeysWithDictionary:onePerson];
        
        UIImageView *imageView = (UIImageView*)[cell viewWithTag:100];
        
        
        UILabel *label = (UILabel*)[cell viewWithTag:101];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:_usermodel.headImageURL] placeholderImage:kDefaultHeadImage];
        
        
        label.text = _usermodel.nickName;
        
        if (!_usermodel.nickName) {
            
            label.text = _usermodel.userName;
            
        }
        
        
        
        
        
        
    });
    
    
    return cell;
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



-(BOOL)hadAttend:(HuoDongModel*)model
{
    BOOL hadAttend = NO;
    NSArray *dataArray = model.AttendUsers;
    
    BmobUser *currentUser = [BmobUser getCurrentUser];
    
    
    for (NSDictionary *dict in dataArray) {
        
        AttendUserModel *_attendmodel = [[AttendUserModel alloc]init];
        
        [_attendmodel setValuesForKeysWithDictionary:dict];
        
        
        if ([currentUser.username isEqualToString:_attendmodel.userName]) {
            
            hadAttend = YES;
            
            
        }
    }
    
    
    
    
    
    
    return hadAttend;
    
}





- (IBAction)attendAction:(id)sender {
    
    
    BmobObject *_ob  = [BmobObject objectWithoutDatatWithClassName:kHuoDongTableName objectId:_huodong.objectId];
    
    
    UserModel *currentUser = [BmobHelper getCurrentUserModel];
    
    NSString *nick = currentUser.nickName;
    if (!nick) {
        
        nick = @"";
    }
    NSString *headImageURL = currentUser.headImageURL;
    
    if (!headImageURL) {
        
        headImageURL = @"";
        
    }
    BmobGeoPoint *location = currentUser.location;
    
    CGFloat latitude = [[location valueForKey:@"latitude"] floatValue];
    
    CGFloat longitude = [[location valueForKey:@"longitude"]floatValue];
    
    AttendUserModel *_attendModel = [[AttendUserModel alloc]init];
    
    _attendModel.nickName = nick;
    _attendModel.userName = currentUser.username;
    _attendModel.headImageURL = headImageURL;
    _attendModel.latitude = latitude;
    _attendModel.longitude = longitude;
    
    NSDictionary *param = [_attendModel toDictionary];
    
    
    [_ob addObjectsFromArray:@[param] forKey:@"AttendUsers"];
    
    [_ob updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        
        if (isSuccessful) {
            
            NSLog(@"updateSuccess");
            
            [CommonMethods showDefaultErrorString:@"报名成功"];
            
            
            NSMutableArray *_muarray = [[NSMutableArray alloc]initWithArray:_huodong.AttendUsers];
            
            [_muarray addObject:param];
            
            
            _huodong.AttendUsers = _muarray;
            
            
            [self.tableView reloadData];
            
            
            
            //将objectId 添加到user表  attendAcivities
            
            BmobUser *currentUser = [BmobUser getCurrentUser];
            
            [currentUser addObjectsFromArray:@[_ob.objectId] forKey:@"attendActivities"];
            
            [currentUser updateInBackground];
            
            
            
            
        }
        else
        {
            NSLog(@"error:%@",error);
            
            [CommonMethods showDefaultErrorString:@"报名失败"];
            
        }
    }];
    
    
}


#pragma mark -加群讨论

- (IBAction)checkAction:(id)sender {
    
    
    [EMHelper joinGroup:_huodong.groupId username:nil result:^(BOOL success, EMGroup *group) {
       
        if (success) {
            
            
           [BmobHelper getGroupInfo:group.groupId result:^(BOOL sccess, GroupChatModel *model) {
              
               if (success) {
                   
                   
             
            ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:group.groupId isGroup:YES];
            if (model.subTitle) {
               
                chatVC.title =model.subTitle;
//                chatVC.subTitle = model.nickName;
            }else
            {
                chatVC.title = model.groupId;
                
//                    chatVC.subTitle = model.nickName;
                
                }
               
                chatVC.group = group;
                           
                chatVC.hidesBottomBarWhenPushed = YES;
                           
                [self.navigationController pushViewController:chatVC animated:YES];
               
                 }
           }];
            

            
            
        }
    }];
    
    
    
    
}



#pragma mark - UITextFieldDelegate
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    
    return YES;
}

-(void)keyboardShow:(NSNotification*)note
{
    NSDictionary *info = note.userInfo;
    
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _uiview_comment.frame = CGRectMake(0, ScreenHeight - kbSize.height - 50, ScreenWidth, 50);
        
        
    }];
}
-(void)keyboardHide:(NSNotification*)note
{
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _uiview_comment.frame = CGRectMake(0, ScreenHeight - 50, ScreenWidth, 50);
        
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            
            [_uiview_comment removeFromSuperview];
            
        }
    }];
    
    
}



- (IBAction)zixunAction:(id)sender {
}

- (IBAction)pinglunAction:(id)sender {
}

- (IBAction)qiandao:(id)sender {
}

- (IBAction)yaoqing:(id)sender {
}
@end
