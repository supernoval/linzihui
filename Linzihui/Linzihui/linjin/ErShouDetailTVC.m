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
#import "WechatShareController.h"


@interface ErShouDetailTVC ()<UITextFieldDelegate,UIAlertViewDelegate,UIActionSheetDelegate>
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
    
    UIAlertView *_buyerAlert; //填写出价 价格
    
    
    
}

@property (nonatomic,strong) UILabel *buyerHeaderLabel; //买家头部label
@property (nonatomic,strong) UILabel *headLabel; //回复头部label

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
    
    if (section > 0) {
        
        return 50;
    }
    
    return 0;
    
    
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section == 1)
    {
        
       _buyerHeaderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
        
        _buyerHeaderLabel.font = FONT_16;
        
        _buyerHeaderLabel.textColor = [UIColor darkGrayColor];
        
        _buyerHeaderLabel.textAlignment = NSTextAlignmentLeft;
        
        _buyerHeaderLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        _buyerHeaderLabel.text = [NSString stringWithFormat:@"  出价%ld人",(long)_model.buyers.count];
        
        
        return _buyerHeaderLabel;
        
    }
    
    if (section == 2) {
        
        _headLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
        
        _headLabel.font = FONT_16;
        
        _headLabel.textColor = [UIColor darkGrayColor];
        
        _headLabel.textAlignment = NSTextAlignmentLeft;
        
        _headLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        _headLabel.text = [NSString stringWithFormat:@"  回复%ld条",(long)_model.comments.count];
        
        
        return _headLabel;
    }
    
    return nil;
    

    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    if (section == 2) {
        
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

    else if(indexPath.section == 1) //出价
    {
        return 120;
        
    }
    else
    {
        
        NSDictionary *dict = [comments objectAtIndex:indexPath.row];
        
        CommentModel *model = [[CommentModel alloc]init];
        
        [model setValuesForKeysWithDictionary:dict];
        
        
        CGFloat textHeight = [StringHeight heightWithText:model.content font:FONT_14 constrainedToWidth:ScreenWidth - 60];
        
        
        
        return 140 + textHeight;
        
    }
    
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0 ) {
        
        return 1;
    }
    
    else if (section == 1)
    {
       
        return _model.buyers.count;
        
    }
    else
    {
         return comments.count;
    }
  
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
    
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
        
        //价格
        _erShouCell.pirceLabel.text = [NSString stringWithFormat:@"%@元",_model.price];
        
        
        
        
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
    else if (indexPath.section == 1) //出价者列表
    {
        ErShouBuyerCell *_buyerCell = [tableView dequeueReusableCellWithIdentifier:@"ErShouBuyerCell"];
        
        if (indexPath.row < _model.buyers.count) {
            
            NSDictionary *oneBuyer = [_model.buyers objectAtIndex:indexPath.row];
            
            UserModel *temModel = [[UserModel alloc]init];
            
            [temModel setValuesForKeysWithDictionary:oneBuyer];
            
            
            [_buyerCell.headImageButton sd_setImageWithURL:[NSURL URLWithString:temModel.headImageURL] forState:UIControlStateNormal placeholderImage:kDefaultHeadImage];
            
            _buyerCell.nameLabel.text = temModel.nickName;
            
            _buyerCell.timeLabel.text = temModel.createdAt;
            
            _buyerCell.priceLabel.text = [NSString stringWithFormat:@"出价:%@元",temModel.price];
            
            [_buyerCell.headImageButton addTarget:self action:@selector(showCommentPersonInfo:) forControlEvents:UIControlEventTouchUpInside];
            
            _buyerCell.distanceLabel.text = [NSString stringWithFormat:@"距离:%@",[CommonMethods distanceStringWithLatitude:temModel.latitude longitude:temModel.longitude]];
            
            NSString *currentUserObjectId = [BmobUser getCurrentUser].objectId;
            
            NSString *publisherObjectId = [_model.publisher objectForKey:@"objectId"];
            
            if ([currentUserObjectId isEqualToString:publisherObjectId]) {
                
                
                _buyerCell.acceptButton.hidden = NO;
                
                _buyerCell.acceptButton.tag = indexPath.row;
                
                [_buyerCell.acceptButton addTarget:self action:@selector(accept:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            else
            {
                _buyerCell.acceptButton.hidden = YES;
                
            }
            
            //等级
            [BmobHelper getOtherLevelWithUserName:temModel.username result:^(NSString *levelStr) {
                
                _buyerCell.levelLabel.text =  [NSString stringWithFormat:@"等级:%@",levelStr];
                
            }];
            
            
        }
        
        return _buyerCell;
        
        
        
    }
   else
   {
       
       
       
       ErShouCommentCell *_commentCell = [tableView dequeueReusableCellWithIdentifier:@"ErShouCommentCell"];
       
       NSDictionary *dict = [comments objectAtIndex:indexPath.row];
       
       CommentModel *model = [[CommentModel alloc]init];
       
       [model setValuesForKeysWithDictionary:dict];
       
       
       [_commentCell.headButton sd_setImageWithURL:[NSURL URLWithString:model.headImageURL] forState:UIControlStateNormal placeholderImage:kDefaultHeadImage] ;
       
       _commentCell.nameLabel.text = model.nick;
       
       _commentCell.comentLabel.text = model.content;
       
       _commentCell.headButton.tag = indexPath.row;
       
       [_commentCell.headButton addTarget:self action:@selector(showCommentPersonInfo:) forControlEvents:UIControlEventTouchUpInside];
       
       //等级
       [BmobHelper getOtherLevelWithUserName:model.username result:^(NSString *levelStr) {
           
           _commentCell.levelLabel.text =  [NSString stringWithFormat:@"等级:%@",levelStr];
           
       }];
       
       _commentCell.timeLabel.text = model.createdAt;
       
       _commentCell.distanceLabel.text = [NSString stringWithFormat:@"距离:%@",[CommonMethods distanceStringWithLatitude:model.latitude longitude:model.longitude]];
       
       return _commentCell;
       
       
       
   }
   
 
    
    
}

-(void)initBottomView
{
  
    UIBarButtonItem *zixun = [[UIBarButtonItem alloc]initWithTitle:@"咨询" style:UIBarButtonItemStylePlain target:self action:@selector(ask)];
    
    UIBarButtonItem *xiangyao = [[UIBarButtonItem alloc]initWithTitle:@"我想要" style:UIBarButtonItemStylePlain target:self action:@selector(xiangyao)];
    
    UIBarButtonItem *common = [[UIBarButtonItem alloc]initWithTitle:@"回复" style:UIBarButtonItemStylePlain target:self action:@selector(coment)];
    
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

#pragma mark - 私下交易
-(void)accept:(UIButton*)acceptButton
{
    
    
    
    NSDictionary *oneBuyer = [_model.buyers objectAtIndex:acceptButton.tag];
    
    
    UserModel *temModel = [[UserModel alloc]init];
    
    [temModel setValuesForKeysWithDictionary:oneBuyer];
    
    ChatViewController *_chat = [[ChatViewController alloc]initWithChatter:temModel.username isGroup:NO];
    
    if (temModel.nickName) {
        
        _chat.title = temModel.nickName;
    }
    else
    {
        _chat.title = temModel.username;
    }
    
    _chat.hidesBottomBarWhenPushed = YES;
    
    _chat.userModel = temModel;
    
    [self.navigationController pushViewController:_chat animated:YES];

    
    
}
#pragma mark - 咨询
-(void)ask
{
    
    UserModel *model = [[UserModel alloc]init];
    
    
    NSString *nickName = [_model.publisher objectForKey:@"nickName"];
    
    NSString *username = [_model.publisher objectForKey:@"username"];
    
    
    if ([username isEqualToString:[BmobUser getCurrentUser].username]) {
        
        [CommonMethods showDefaultErrorString:@"无法与自己聊天"];
        
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
    
    
    NSString *username = [_model.publisher objectForKey:@"username"];
    
    
    if ([username isEqualToString:[BmobUser getCurrentUser].username]) {
        
        [CommonMethods showDefaultErrorString:@"您自己发布的二手商品，无需出价"];
        
        return;
        
    }
    
    
    
    
   _buyerAlert = [[UIAlertView alloc]initWithTitle:@"填写价格" message:nil
delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    _buyerAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [_buyerAlert textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
    
    
    [_buyerAlert show];
    
    
    
}

#pragma mark -回复
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
    UIActionSheet *_actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    
    [_actionSheet addButtonWithTitle:@"分享到微信"];
    [_actionSheet addButtonWithTitle:@"分享到QQ"];
    
    [_actionSheet addButtonWithTitle:@"取消"];
    
    
    _actionSheet.cancelButtonIndex = 2;
    
    [_actionSheet showInView:self.view];
    
    
    
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
    
    _commentModel.createdAt = [CommonMethods getYYYYMMddHHmmssDateStr:[NSDate date]];
    
    _commentModel.latitude = [[NSUserDefaults standardUserDefaults] floatForKey:kCurrentLatitude];
   
    _commentModel.longitude = [[NSUserDefaults standardUserDefaults] floatForKey:kCurrentLongitude];
    
    
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
            
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
            
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

-(void)showBuyerPersonInfo:(UIButton*)sender
{
    NSDictionary *dict =[_model.buyers objectAtIndex:sender.tag];
    
    UserModel *model = [[UserModel alloc]init];
    
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
    
    
    if (alertView == _buyerAlert && buttonIndex == 1) {
        
        UITextField *inputTF = [alertView textFieldAtIndex:0];
        
        if (inputTF.text.length  == 0) {
            
            [CommonMethods showDefaultErrorString:@"请输入抢购金额"];
            
            
        }else
        {
            
            [MyProgressHUD showProgress];
            
            
            CGFloat jinEr = [inputTF.text floatValue];
            
           BmobObject *ob = [BmobObject objectWithoutDatatWithClassName:kErShou objectId:_model.objectId];
            
            UserModel *model = [BmobHelper getCurrentUserModel];
            
           
            
            if (jinEr == 0) {
                
                model.price = [NSString stringWithFormat:@"%.0f",jinEr];
            }
            else
            {
                model.price = [NSString stringWithFormat:@"%.2f",jinEr];
            }
            
            model.createdAt = [CommonMethods getYYYYMMddHHmmssDateStr:[NSDate date]];
            
            model.latitude = [[NSUserDefaults standardUserDefaults] floatForKey:kCurrentLatitude];
            
            model.longitude = [[NSUserDefaults standardUserDefaults] floatForKey:kCurrentLongitude];
            
            
            
             NSDictionary *dic = [model toDictionary];
            
            
  
            
            [ob addObjectsFromArray:@[dic] forKey:@"buyers"];
            
            [ob updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
               
                [MyProgressHUD dismiss];
                
                
                if (isSuccessful) {
                    
                    
                    NSMutableArray *muArray = [[NSMutableArray alloc]init];
                    
                    [muArray addObjectsFromArray:_model.buyers];
                    
                    [muArray addObject:dic];
                    
                    _model.buyers = muArray;
                    
                    [self.tableView reloadData];
                    
                
                }
                
                
            }];
        }
        
        
        
     }
}

#pragma mark -  UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex < 2) {
        
        WechatShareController *_shareVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WechatShareController"];
        
        _shareVC.hidesBottomBarWhenPushed = YES;
        _shareVC.shareType = buttonIndex + 1;
        
        [self.navigationController pushViewController:_shareVC animated:YES];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
