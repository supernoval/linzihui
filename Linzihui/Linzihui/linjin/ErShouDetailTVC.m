//
//  ErShouDetailTVC.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/3/31.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "ErShouDetailTVC.h"
#import "PersonInfoViewController.h"
#import "ChatViewController.h"


@interface ErShouDetailTVC ()<UITextFieldDelegate,UIAlertViewDelegate>
{
    NSMutableArray *comments;
    
    UIToolbar *_myToolBar;
    
    
    
    
    UIView *_uiview_comment;
    
    
    UITextField *_textField_comment;
    
    ErShouModel *_toCommentModel;  //被评论的
    
    NSString * _toReplayNick; // 回复哪行
    
    BOOL isReplay;
    
    NSInteger commentSection ; //评论的 section
    
    
    UIAlertView *_jubaoAlertView;
    
    
    
    
}

@property (nonatomic,strong) UILabel *headLabel; //头部label

@end

@implementation ErShouDetailTVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"详情";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
     _myToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, ScreenHeight - 44, ScreenWidth, 44)];
    
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self initBottomView];
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
    
    [sendButton addTarget:self action:@selector(sendComment) forControlEvents:UIControlEventTouchUpInside];
    
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    
    sendButton.backgroundColor = kNavigationBarColor;
    
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [sendButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    
    sendButton.clipsToBounds = YES;
    
    sendButton.layer.cornerRadius = 5;
    
    [_uiview_comment addSubview:sendButton];
    
    
    
    
    
    
}

-(UILabel*)headLabel
{
    if (_headLabel) {
        
        _headLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
        
        _headLabel.font = FONT_16;
        
        _headLabel.textColor = [UIColor darkGrayColor];
        
        _headLabel.textAlignment = NSTextAlignmentLeft;
        
        _headLabel.backgroundColor = [UIColor redColor];
        
        _headLabel.text = [NSString stringWithFormat:@"回复%ld条",(long)_model.comments.count];
        
        
    }
    
    return _headLabel;
    
}



-(void)setModel:(ErShouModel *)model
{
    _model = model;
    
    comments = [[NSMutableArray alloc]init];
    
    [comments addObjectsFromArray:_model.comments];
    
    
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section == 1) {
        
        return 50;
    }
    
    return 0;
    
    
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    _headLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    
    _headLabel.font = FONT_16;
    
    _headLabel.textColor = [UIColor darkGrayColor];
    
    _headLabel.textAlignment = NSTextAlignmentLeft;
    
    _headLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _headLabel.text = [NSString stringWithFormat:@"  回复%ld条",(long)_model.comments.count];
    
    
    return _headLabel;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    if (section == 1) {
        
        return 50;
    }
    
    return 0;
    
    
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    
    
    headerView.backgroundColor = [UIColor clearColor];
    
    
    return headerView;
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section == 0) {
        
        CGFloat textHeight = [StringHeight heightWithText:_model.des font:FONT_15 constrainedToWidth:ScreenWidth - 20];
        
        CGFloat photoViewHeight = 0;
        
        NSArray *imgs = _model.photos;
        
        long imageCount = imgs.count;
        int perRowImageCount = ((imageCount == 4) ? 2 : 3);
        CGFloat perRowImageCountF = (CGFloat)perRowImageCount;
        int totalRowCount = ceil(imageCount / perRowImageCountF);
        
        photoViewHeight = 80 * totalRowCount;
        
        
        
        return 160 + textHeight + photoViewHeight;
    }

    else
    {
        return 120;
        
    }
    
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0) {
        
        return 1;
    }
    else
    {
        return comments.count;
        
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        ErShouCell *_erShouCell = [tableView dequeueReusableCellWithIdentifier:@"ErShouCell"];
        CGFloat textHeight = [StringHeight heightWithText:_model.des font:FONT_15 constrainedToWidth:ScreenWidth - 20];
        
        CGFloat photoViewHeight = 0;
        
        NSArray *imgs = _model.photos;
        
        long imageCount = imgs.count;
        int perRowImageCount = ((imageCount == 4) ? 2 : 3);
        CGFloat perRowImageCountF = (CGFloat)perRowImageCount;
        int totalRowCount = ceil(imageCount / perRowImageCountF);
        
        photoViewHeight = 80 * totalRowCount;
        
        
        
        
        
        _erShouCell.contentLabelHeight.constant = textHeight;
        
        _erShouCell.photoViewHeight.constant = photoViewHeight;
        
        
        
        _erShouCell.contentLabel.text = _model.des;
        
        _erShouCell.photoView.photoItemArray = _model.photos;
        
        [_erShouCell.headButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[_model.publisher objectForKey:@"headImageURL"]] forState:UIControlStateNormal placeholderImage:kDefaultHeadImage];
        
        _erShouCell.headButton.tag = indexPath.section;
        
        [_erShouCell.headButton addTarget:self action:@selector(showPersonInfo:) forControlEvents:UIControlEventTouchUpInside];
        
        
        _erShouCell.nameLabel.text = [_model.publisher objectForKey:@"nickName"];
        
        _erShouCell.timeLabel.text = [CommonMethods getYYYYMMddHHmmssDateStr:_model.createdAt];
        _erShouCell.timeLabel.adjustsFontSizeToFitWidth = YES;
        
        //等级
        [BmobHelper getOtherLevelWithUserName:[_model.publisher  objectForKey:@"username"] result:^(NSString *levelStr) {
            
            _erShouCell.levelLabel.text =  [NSString stringWithFormat:@"等级:%@",levelStr];
            
        }];
        
        BmobGeoPoint *location = _model.location;
        
        CGFloat latitude = [[location valueForKey:@"latitude"]floatValue];
        
        CGFloat longitude = [[location valueForKey:@"longitude"]floatValue];
        
        
        _erShouCell.distanceLabel.text = [CommonMethods distanceStringWithLatitude:latitude longitude:longitude];
        
        
        //zan
        if (_model.zan.count == 0) {
            
            _erShouCell.likeNumLabel.text = nil;
        }
        else
        {
            _erShouCell.likeNumLabel.text = [NSString stringWithFormat:@"%ld",(long)_model.zan.count];
            
        }
        
        NSString *currentUsername = [BmobUser getCurrentUser].username;
        
        BOOL hadZan = NO;
        
        for (int i = 0; i < _model.zan.count; i++) {
            
            NSString *username = [_model.zan objectAtIndex:i];
            
            
            if ([username isEqualToString:currentUsername]) {
                
                hadZan = YES;
                
                
            }
            
        }
        
        if (hadZan) {
            
            [_erShouCell.likeButton setImage:[UIImage imageNamed:@"liked"] forState:UIControlStateNormal];
        }
        else
        {
            [_erShouCell.likeButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
            
        }
        
        _erShouCell.likeButton.tag = indexPath.section;
        
        [_erShouCell.likeButton addTarget:self action:@selector(zanAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _erShouCell.replayButton.tag = indexPath.section;
        
        [_erShouCell.replayButton addTarget:self action:@selector(coment) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        
        
        return _erShouCell;
        
    }
    
   else
   {
       
       
       
       ErShouCommentCell *_commentCell = [tableView dequeueReusableCellWithIdentifier:@"ErShouCommentCell"];
       
       NSDictionary *dict = [comments objectAtIndex:indexPath.row];
       
       CommentModel *model = [[CommentModel alloc]init];
       
       [model setValuesForKeysWithDictionary:dict];
       
       [_commentCell.headButton sd_setBackgroundImageWithURL:[NSURL URLWithString:model.headImageURL] forState:UIControlStateNormal placeholderImage:kDefaultHeadImage];
       
       _commentCell.nameLabel.text = model.nick;
       
       _commentCell.comentLabel.text = model.content;
       
       _commentCell.headButton.tag = indexPath.row;
       
       [_commentCell.headButton addTarget:self action:@selector(showCommentPersonInfo:) forControlEvents:UIControlEventTouchUpInside];
       
       
       
       
       return _commentCell;
       
       
       
   }
   
 
    
    
}

-(void)initBottomView
{
  
    UIBarButtonItem *zixun = [[UIBarButtonItem alloc]initWithTitle:@"咨询" style:UIBarButtonItemStylePlain target:self action:@selector(ask)];
    
    UIBarButtonItem *xiangyao = [[UIBarButtonItem alloc]initWithTitle:@"我想要" style:UIBarButtonItemStylePlain target:self action:@selector(xiangyao)];
    
    UIBarButtonItem *common = [[UIBarButtonItem alloc]initWithTitle:@"评论" style:UIBarButtonItemStylePlain target:self action:@selector(coment)];
    
    UIBarButtonItem *fenxiang = [[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(fenxiang)];
    
    UIBarButtonItem *jubao  = [[UIBarButtonItem alloc]initWithTitle:@"举报"style:UIBarButtonItemStylePlain target:self action:@selector(jubao)];
    
    
    UIBarButtonItem *flex = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *flex1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *flex2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *flex3 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *flex4 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *sign = [[UIBarButtonItem alloc]initWithTitle:@"签到" style:UIBarButtonItemStylePlain target:self action:@selector(sign)];
    
    
    _myToolBar.items = @[flex,zixun,flex,xiangyao,flex3,common,flex1,fenxiang,flex2,jubao,flex4];
    
    _myToolBar.tintColor = kBlueBackColor;
}

#pragma mark - 咨询
-(void)ask
{
    
    UserModel *model = [[UserModel alloc]init];
    
    
    NSString *nickName = [_model.publisher objectForKey:@"nickName"];
    
    NSString *username = [_model.publisher objectForKey:@"username"];
    
    
    if ([username isEqualToString:[BmobUser getCurrentUser].username]) {
        
        [CommonMethods showDefaultErrorString:@"您自己发布的活动，无法与自己聊天"];
        
        return;
        
    }
    
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

#pragma mark - 我想要
- (void)xiangyao
{
    
}

#pragma mark -评论
- (void)coment
{
    

    
    isReplay = NO;
    
  
    
    _textField_comment.placeholder = @"请输入评论内容";
    [self.navigationController.view addSubview:_uiview_comment];
    
    if ([_textField_comment becomeFirstResponder])
    {
        NSLog(@"sdgfafg");
        
        
        
    }
    

    

}

#pragma mark - 分享
- (void)fenxiang
{
    
}

#pragma mark - 举报
- (void)jubao
{
    _jubaoAlertView = [[UIAlertView alloc]initWithTitle:nil message:@"确认要举报改用户吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"举报", nil];
    
    [_jubaoAlertView show];
    
    
}




#pragma mark - 提交评论
-(void)sendComment
{
    
    if (_textField_comment.text.length == 0) {
        
        [CommonMethods showDefaultErrorString:@"请输入评论内容"];
        
        return;
        
    }
    
    
    [_textField_comment resignFirstResponder];
    
    [self.view endEditing:YES];
    
    
    UserModel *currentUserModel = [BmobHelper getCurrentUserModel];
    
    CommentModel *_commentModel = [[CommentModel alloc]init];
    
    _commentModel.headImageURL = currentUserModel.headImageURL;
    
    _commentModel.nick = currentUserModel.nickName;
    
    _commentModel.username = currentUserModel.username;
    
    _commentModel.content = _textField_comment.text;
    
    if (isReplay) {
        
        _commentModel.replayToNick = _toReplayNick;
        
    }
    else
    {
        _commentModel.replayToNick = @"";
        
    }
    
    
    
    NSDictionary *_dict = [_commentModel toDictionary];
    
    
    
    [MyProgressHUD showProgress];
    
    BmobObject *shenghuoOB = [BmobObject objectWithoutDatatWithClassName:kErShou objectId:_model.objectId];
    
    [shenghuoOB addObjectsFromArray:@[_dict] forKey:@"comments"];
    
    [shenghuoOB updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        
        [MyProgressHUD dismiss];
        
        if (isSuccessful) {
            
            
            _textField_comment.text = nil;
            _toReplayNick = nil;
            
            NSMutableArray *muArray = [[NSMutableArray alloc]initWithArray:_model.comments];
            
            [muArray addObject:_dict];
            
            _model.comments = muArray;
            
            comments = muArray;
            
            _headLabel.text = [NSString stringWithFormat:@"回复%ld条",(long)_model.comments.count];
            
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            
            NSLog(@"评论成功");
            
            //            [CommonMethods showDefaultErrorString:@"评论成功"];
            
        }
        else
        {
            NSLog(@"评论失败:%@",error);
            
            [CommonMethods showDefaultErrorString:@"评论失败,请重试"];
            
            
        }
    }];
    
    
    
    
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

#pragma mark -  赞
-(void)zanAction:(UIButton*)sender
{
    
    
    
    
    BmobObject *ob = [BmobObject objectWithoutDatatWithClassName:kErShou objectId:_model.objectId];
    
    NSString *currentUsername = [BmobUser getCurrentUser].username;
    
    BOOL hadZan = NO;
    
    for (int i = 0; i < _model.zan.count; i++) {
        
        NSString *username = [_model.zan objectAtIndex:i];
        
        
        if ([username isEqualToString:currentUsername]) {
            
            hadZan = YES;
            
        }
        
    }
    
    
    if (hadZan)
    {
        
        [ob removeObjectsInArray:@[currentUsername] forKey:@"zan"];
        
        
    }
    else
    {
        [ob addObjectsFromArray:@[currentUsername] forKey:@"zan"];
        
    }
    
    
    [ob updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        
        if (isSuccessful) {
            
            NSMutableArray *muArray = [[NSMutableArray alloc]initWithArray:_model.zan];
            
            if (hadZan) {
                
                [muArray removeObject:currentUsername];
                
            }
            else
            {
                [muArray addObject:currentUsername];
            }
            
            
            _model.zan = muArray;
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag] withRowAnimation:UITableViewRowAnimationNone];
            
        }
        
    }];
    
}
//显示个人信息
-(void)showPersonInfo:(NSString*)username
{
    PersonInfoViewController *_personInfo = [self.storyboard instantiateViewControllerWithIdentifier:@"PersonInfoViewController"];
    
    _personInfo.username = username;
    
    
    [self.navigationController pushViewController:_personInfo animated:YES];
    
}

//显示评论者个人信息
-(void)showCommentPersonInfo:(UIButton*)sender
{
    NSDictionary *dict = [comments objectAtIndex:sender.tag];
    
    CommentModel *model = [[CommentModel alloc]init];
    
    [model setValuesForKeysWithDictionary:dict];
    
    [self showPersonInfo:model.username];
    
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [_textField_comment resignFirstResponder];
    
    return YES;
}

#pragma mark- UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == _jubaoAlertView && buttonIndex == 1) {
        
        
        
         BmobObject *ob = [BmobObject objectWithoutDatatWithClassName:kErShou objectId:_model.objectId];
        
        [ob addObjectsFromArray:@[[BmobUser getCurrentUser].username] forKey:@"jubao"];
        
        [ob updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
           
            if (isSuccessful) {
                
                [CommonMethods showDefaultErrorString:@"举报成功"];
                
                
            }
        }];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
