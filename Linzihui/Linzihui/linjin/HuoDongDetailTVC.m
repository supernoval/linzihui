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
#import "PersonInfoViewController.h"
#import "InviteNewGroupMember.h"
#import "HuoDongMapView.h"
#import "SendWXViewController.h"
#import "HuodongCommentCell.h"



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
    
    _myToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, ScreenHeight - 44, ScreenWidth, 44)];
    
    
    UIBarButtonItem *attend = [[UIBarButtonItem alloc]initWithTitle:@"报名" style:UIBarButtonItemStylePlain target:self action:@selector(attendAction:)];
    
    
     UIBarButtonItem *yaoqing = [[UIBarButtonItem alloc]initWithTitle:@"邀请" style:UIBarButtonItemStylePlain target:self action:@selector(invite)];
    
     UIBarButtonItem *zixun = [[UIBarButtonItem alloc]initWithTitle:@"咨询" style:UIBarButtonItemStylePlain target:self action:@selector(ask)];
    
    UIBarButtonItem *common = [[UIBarButtonItem alloc]initWithTitle:@"记录" style:UIBarButtonItemStylePlain target:self action:@selector(coment)];
    
    UIBarButtonItem *flex = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *flex1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *flex2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *flex3 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *flex4 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *sign = [[UIBarButtonItem alloc]initWithTitle:@"签到" style:UIBarButtonItemStylePlain target:self action:@selector(sign)];
    
    
    _myToolBar.items = @[flex,attend,flex,zixun,flex3,common,flex1,sign,flex2,yaoqing,flex4];
    
    _myToolBar.tintColor = kBlueBackColor;
    
    
    
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
    
    [_uiview_comment removeFromSuperview];
    
    
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

//-(void)showCommentView
//{
//    
//    [self.navigationController.view addSubview:_uiview_comment];
//    
//    [_textField_comment becomeFirstResponder];
//    
//}

#pragma mark - 记录
-(void)coment
{
    
    
    
    SendWXViewController *_sendVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SendWXViewController"];
    
    
    _sendVC.type = 1;
    
    _sendVC.huodong = _huodong;
    
    [_sendVC setblock:^(BOOL isSuccess, id ob) {
       
        
        _huodong = ob;
        
        
        [self.tableView reloadData];
        
        
    }];
    
    
    [self.navigationController pushViewController:_sendVC animated:YES];
    
    
    
   
    
    
}

#pragma mark - 签到
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

#pragma mark - 邀请
-(void)invite
{
    

    NSString *name = [_huodong.starter objectForKey:@"nickName"];
    
    if (!name) {
        name = [_huodong.starter objectForKey:@"username"];
        
        
    }
    NSString *message = [NSString stringWithFormat:@"%@邀请您参加%@活动",name,_huodong.title];
    
    InviteNewGroupMember *_inviteMember = [[InviteNewGroupMember alloc]initWithStyle:UITableViewStylePlain];
    
    _inviteMember.type = 1;
    
    _inviteMember.huodong = _huodong.OB;
    _inviteMember.message = message;
    _inviteMember.messageTitle = _huodong.title;
    
    
    [self.navigationController pushViewController:_inviteMember animated:YES];
    
}

#pragma mark - 咨询
-(void)ask
{
    
    UserModel *model = [[UserModel alloc]init];
    
 
    NSString *nickName = [_huodong.starter objectForKey:@"nickName"];
    NSString *username = [_huodong.starter objectForKey:@"username"];
    

    model.username = username;
    model.nickName = nickName;
    
    
    ChatViewController *_chat = [[ChatViewController alloc]initWithChatter:model.username isGroup:NO];
    
    if (model.nickName) {
        
        _chat.title = model.nickName;
    }
    else
    {
        _chat.title = model.username;
    }
    
    _chat.hidesBottomBarWhenPushed = YES;
    _chat.userModel = model;
    
    [self.navigationController pushViewController:_chat animated:YES];
}
-(void)initdata
{
    
    
    CGFloat photoViewHeight = 0;
    
    NSArray *imgs = _huodong.photoURL;
    
    long imageCount = imgs.count;
    int perRowImageCount = ((imageCount == 4) ? 2 : 3);
    CGFloat perRowImageCountF = (CGFloat)perRowImageCount;
    int totalRowCount = ceil(imageCount / perRowImageCountF);
    
    photoViewHeight = 95 * totalRowCount;
    
    CGFloat detailHeight = [StringHeight heightWithText:_huodong.content font:FONT_15 constrainedToWidth:ScreenWidth - 95 ];
    
    CGFloat tedianHeight = [StringHeight heightWithText:_huodong.TeDian font:FONT_15 constrainedToWidth:ScreenWidth - 95];
    
    CGFloat liuchenHeight = [StringHeight heightWithText:_huodong.LiuCheng font:FONT_15 constrainedToWidth:ScreenWidth - 95];
    
    CGFloat zhuyiHeight = [StringHeight heightWithText:_huodong.ZhuYiShiXiang font:FONT_15 constrainedToWidth:ScreenWidth - 95];
    
    CGFloat plusHeight = 0;
    
    if (detailHeight < 21) {
        detailHeight = 21;
    }
    
    if (tedianHeight < 21) {
        
        tedianHeight = 21;
    }
    if (liuchenHeight < 21) {
        
        liuchenHeight = 21;
    }
    
    if (zhuyiHeight < 21) {
        zhuyiHeight = 21;
        
    }
    
    plusHeight = detailHeight -21 + tedianHeight -21 + liuchenHeight -21 + zhuyiHeight-21;
    
    
    _detailtitleheight.constant = detailHeight;
    
    _detailheight.constant = detailHeight;
    
    _tedianheight.constant = tedianHeight;
    _tediantitleheight.constant = tedianHeight;
    
    _liuchenheight.constant = liuchenHeight;
    _liuchentitleheight.constant = liuchenHeight;
    
    _zhuyiheight.constant = zhuyiHeight;
    _zhuyititleHeight.constant = zhuyiHeight;
    
    
    
     _headerView.frame = CGRectMake(0, 0, ScreenWidth, 440 + photoViewHeight + plusHeight);
    
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
    
//     _numLabel.text = [NSString stringWithFormat:@"%ld人已参加",(long)_huodong.AttendUsers.count];
    
    _photoHeight.constant = photoViewHeight;
    
    _photoView.photoItemArray = _huodong.photoURL;
    
   
    
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
    

    
    
    _attendButton.hidden = YES;
    
    _checkButton.hidden = YES;
    
    _numLabel.hidden = YES;
    
    

    
    
    
    
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *blanckView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    
    blanckView.backgroundColor = [UIColor clearColor];
    
    
    return blanckView;
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
 
    UILabel *label = [CommonMethods LabelWithText:@"评论" andTextAlgniment:NSTextAlignmentLeft andTextColor:[UIColor blackColor] andTextFont:FONT_16 andFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    
    if (section == 0) {
        
        if (_huodong.AttendUsers.count > 0) {
            
             label.text =[NSString stringWithFormat:@"  参与人员(%ld人已参加)",(long)_huodong.AttendUsers.count];
            
            
        }
        else
        {
            label.text = @"";
            
        }
       
    }
    
    if (section == 1) {
        
        if (_huodong.comment.count > 0) {
            
            label.text = @"  记录";
        }
        else
        {
            label.text = @"";
        }
        
    }
    if (section == 2) {
        
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
    
    if (section == 2) {
        
        return 44;
    }
    
    return 0;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

        
        return 20;
 
    
  
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
 
    if (indexPath.section == 1) {
        
        
        if (_huodong.comment.count > indexPath.row) {
            
            NSDictionary *dic = [_huodong.comment objectAtIndex:indexPath.row];
            
            CommentModel *_commentModel = [[CommentModel alloc]init];
            
            [_commentModel setValuesForKeysWithDictionary:dic];
           
            
            CGFloat photoViewHeight = 0;
            
            NSArray *imgs = _commentModel.imageURLs;
            
            long imageCount = imgs.count;
            int perRowImageCount = ((imageCount == 4) ? 2 : 3);
            CGFloat perRowImageCountF = (CGFloat)perRowImageCount;
            int totalRowCount = ceil(imageCount / perRowImageCountF);
            
            photoViewHeight = 95 * totalRowCount;
        
            
            CGFloat commentHeight = [StringHeight heightWithText:_commentModel.content font:FONT_15 constrainedToWidth:ScreenWidth - 120];
            
            if (commentHeight < 60) {
                commentHeight = 60;
                
            }
            
            return commentHeight + photoViewHeight;
            
            
        }
        
        
        
    }
 
    
    
    
    return 50;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 
    if (section == 0) {
        
      return _huodong.AttendUsers.count;
    }
    
    if (section == 1) {
        
      return _huodong.comment.count;
    }
    
    return _huodong.qiandao.count;
    
    
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    if (indexPath.section == 0) {
        
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

  
    if (indexPath.section == 1) {
        
        
    
    HuodongCommentCell *commentCel = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        if (_huodong.comment.count > indexPath.row) {
            
            NSDictionary *dic = [_huodong.comment objectAtIndex:indexPath.row];
            
            CommentModel *_commentModel = [[CommentModel alloc]init];
            
            [_commentModel setValuesForKeysWithDictionary:dic];
            
            
           
            
            
            [commentCel.headImageView sd_setImageWithURL:[NSURL URLWithString:_commentModel.headImageURL] placeholderImage:kDefaultHeadImage];
            
            commentCel.nameLabel.text = _commentModel.nick;
            
            if (!commentCel.nameLabel.text) {
                
                commentCel.nameLabel.text = _commentModel.username;
                
            }
            
            
            commentCel.commentLabel.text = _commentModel.content;
            
            commentCel.photoView.photoItemArray = _commentModel.imageURLs;
            
            
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
    
    NSString *username = nil;
    
    switch (indexPath.section) {
        case 0:
        {
            NSDictionary *onePerson = [_huodong.AttendUsers objectAtIndex:indexPath.row];
            
            AttendUserModel * _usermodel = [[AttendUserModel alloc]init];
            
            [_usermodel setValuesForKeysWithDictionary:onePerson];
            
            username = _usermodel.userName;
            
        }
            break;
        case 1:
        {
            NSDictionary *dic = [_huodong.comment objectAtIndex:indexPath.row];
            
            CommentModel *_commentModel = [[CommentModel alloc]init];
            
            [_commentModel setValuesForKeysWithDictionary:dic];
            
            username = _commentModel.username;
            
            
        }
            break;
        case 2:
        {
            NSArray *personsArray = _huodong.qiandao;
            
            NSDictionary *onePerson = [personsArray objectAtIndex:indexPath.row];
            
            AttendUserModel * _usermodel = [[AttendUserModel alloc]init];
            
            [_usermodel setValuesForKeysWithDictionary:onePerson];
            
            username = _usermodel.userName;
            
            
        }
            break;
            
            
        default:
            break;
    }
    
    
    PersonInfoViewController *_personInfoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PersonInfoViewController"];
    
    _personInfoVC.username = username;
    
    [self.navigationController pushViewController:_personInfoVC animated:YES];
    
    
    
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
    

    
    
    if ([self hadAttend:_huodong]) {
        
        [CommonMethods showDefaultErrorString:@"已报名"];
        
        return;
        
    }
    

    
    
    NSInteger registStatus = [CommonMethods activityRegistStatus:_huodong.endRegistTime];
    
    if (registStatus == 2) {
        
       
        
        [CommonMethods showDefaultErrorString:@"报名已截止"];
        
        return;
        
        
    }

    
    
    if ([[BmobUser getCurrentUser].username isEqualToString:[_huodong.starter objectForKey:@"username"]]) {
        
        [CommonMethods showDefaultErrorString:@"已报名"];
        
        return;
        
        
    }
    
    
    
    
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




- (IBAction)showMapView:(id)sender {
    
    HuoDongMapView *_mapView = [self.storyboard instantiateViewControllerWithIdentifier:@"HuoDongMapView"];
    
    _mapView.coord = CLLocationCoordinate2DMake([[_huodong.location valueForKey:@"latitude"]floatValue], [[_huodong.location valueForKey:@"longitude"]floatValue]);
    
    [self.navigationController pushViewController:_mapView animated:YES];
    
    
}
@end
