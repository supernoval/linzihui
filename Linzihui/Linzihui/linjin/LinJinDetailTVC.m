//
//  LinJinDetailTVC.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/4/21.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "LinJinDetailTVC.h"
#import "PersonInfoViewController.h"
#import "ChatViewController.h"
#import "WechatShareController.h"


@interface LinJinDetailTVC ()<UITextFieldDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{
    
    UIView *_uiview_comment;
    
       UIToolbar *_myToolBar;
    UITextField *_textField_comment;
    UIAlertView *_jubaoAlertView;
    
}
@property (nonatomic,strong) UILabel *headLabel; //回复头部label

@end

@implementation LinJinDetailTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"互助详情";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self initCommentView];
    
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
     _myToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, ScreenHeight - 44, ScreenWidth, 44)];
    
    [self initBottomView];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    
    [self.navigationController.view addSubview:_myToolBar];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_uiview_comment removeFromSuperview];
    
    [_myToolBar removeFromSuperview];
    
}


-(void)initBottomView
{
    
    UIBarButtonItem *zixun = [[UIBarButtonItem alloc]initWithTitle:@"咨询" style:UIBarButtonItemStylePlain target:self action:@selector(ask)];
    

    
    UIBarButtonItem *common = [[UIBarButtonItem alloc]initWithTitle:@"回复" style:UIBarButtonItemStylePlain target:self action:@selector(coment)];
    
    UIBarButtonItem *fenxiang = [[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(fenxiang)];
    
    UIBarButtonItem *jubao  = [[UIBarButtonItem alloc]initWithTitle:@"举报"style:UIBarButtonItemStylePlain target:self action:@selector(jubao)];
    
    
    UIBarButtonItem *flex = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *flex1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *flex2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *flex3 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *flex4 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    
    
    _myToolBar.items = @[flex,zixun,flex3,common,flex1,fenxiang,flex2,jubao,flex4];
    
    _myToolBar.tintColor = kBlueBackColor;
}

#pragma mark - 举报
- (void)jubao
{
    _jubaoAlertView = [[UIAlertView alloc]initWithTitle:nil message:@"确认要举报该用户吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"举报", nil];
    
    [_jubaoAlertView show];
    
    
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


#pragma mark - 咨询
-(void)ask
{
    
    
    UserModel *model = [[UserModel alloc]init];
    
    
    NSString *nickName = [_model.publisher objectForKey:@"nickName"];
    NSString *username = [_model.publisher objectForKey:@"username"];
    
    
    if ([username isEqualToString:[BmobUser getCurrentUser].username]) {
        
        [CommonMethods showDefaultErrorString:@"您自己发布的信息，无法与自己聊天"];
        
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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 0;
    }
    return 50;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
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



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        CGFloat textHeight = [StringHeight heightWithText:_model.content font:FONT_15 constrainedToWidth:ScreenWidth - 20];
        
        CGFloat photoViewHeight = 0;
        
        NSArray *imgs = _model.photos;
        
        long imageCount = imgs.count;
        int perRowImageCount = ((imageCount == 4) ? 2 : 3);
        CGFloat perRowImageCountF = (CGFloat)perRowImageCount;
        int totalRowCount = ceil(imageCount / perRowImageCountF);
        
        photoViewHeight = 80 * totalRowCount;
        
        
        
        return 160 + textHeight + photoViewHeight;
    }
    
    else //评论
    {
        
        NSDictionary *oneBuyer = [_model.comments objectAtIndex:indexPath.row];
        
        UserModel *temModel = [[UserModel alloc]init];
        
        [temModel setValuesForKeysWithDictionary:oneBuyer];
        
        CGFloat messageHeigh = [StringHeight heightWithText:temModel.message font:FONT_15 constrainedToWidth:ScreenWidth - 130];
        
        return 120 + messageHeigh;
        
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 1;
    }
    
    return _model.comments.count;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        ErShouCell *_erShouCell = [tableView dequeueReusableCellWithIdentifier:@"ErShouCell"];
        CGFloat textHeight = [StringHeight heightWithText:_model.content font:FONT_15 constrainedToWidth:ScreenWidth - 20];
        
        CGFloat photoViewHeight = 0;
        
        NSArray *imgs = _model.photos;
        
        long imageCount = imgs.count;
        int perRowImageCount = ((imageCount == 4) ? 2 : 3);
        CGFloat perRowImageCountF = (CGFloat)perRowImageCount;
        int totalRowCount = ceil(imageCount / perRowImageCountF);
        
        photoViewHeight = 80 * totalRowCount;
        
        
        
        _erShouCell.contentLabelHeight.constant = textHeight;
        
        _erShouCell.photoViewHeight.constant = photoViewHeight;
        
        
        _erShouCell.contentLabel.text = _model.content;
        
        _erShouCell.photoView.photoItemArray = _model.photos;
        
        [_erShouCell.headButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[_model.publisher objectForKey:@"headImageURL"]] forState:UIControlStateNormal placeholderImage:kDefaultHeadImage];
        
        _erShouCell.headButton.tag = indexPath.section;
        
        [_erShouCell.headButton addTarget:self action:@selector(showPublisherPersonInfo) forControlEvents:UIControlEventTouchUpInside];
        
        
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
        
        //红包金额
        _erShouCell.pirceLabel.text = [NSString stringWithFormat:@"红包:%.0f元",_model.hongbaoNum];
        
        _erShouCell.pirceLabel.adjustsFontSizeToFitWidth = YES;
        
        //到期时间
        _erShouCell.validateLabel.text = [CommonMethods getYYYYMMddhhmmDateStr:_model.validate];
        

        
        [_erShouCell.replayButton addTarget:self action:@selector(coment) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        
        
        return _erShouCell;
        
    }
    else  //回复
    {
        ErShouBuyerCell *_buyerCell = [tableView dequeueReusableCellWithIdentifier:@"ErShouBuyerCell"];
        
        if (indexPath.row < _model.comments.count) {
            
            NSDictionary *oneBuyer = [_model.comments objectAtIndex:indexPath.row];
            
            UserModel *temModel = [[UserModel alloc]init];
            
            [temModel setValuesForKeysWithDictionary:oneBuyer];
            
            
            [_buyerCell.headImageButton sd_setImageWithURL:[NSURL URLWithString:temModel.headImageURL] forState:UIControlStateNormal placeholderImage:kDefaultHeadImage];
            
            _buyerCell.nameLabel.text = temModel.nickName;
            
            _buyerCell.timeLabel.text = temModel.createdAt;
            


            _buyerCell.messageLabel.text = temModel.message;
            
            CGFloat messageHeigh = [StringHeight heightWithText:temModel.message font:FONT_15 constrainedToWidth:ScreenWidth - 130];
            
            _buyerCell.messageLabelHeigh.constant = messageHeigh;
            
            
            [_buyerCell.headImageButton addTarget:self action:@selector(showCommentPersonInfo:) forControlEvents:UIControlEventTouchUpInside];
            
            _buyerCell.distanceLabel.text = [NSString stringWithFormat:@"距离:%@",[CommonMethods distanceStringWithLatitude:temModel.latitude longitude:temModel.longitude]];
            
            NSString *currentUserObjectId = [BmobUser getCurrentUser].objectId;
            
            NSString *publisherObjectId = [_model.publisher objectForKey:@"objectId"];
            
            
            //如果是发布者查看
            if ([currentUserObjectId isEqualToString:publisherObjectId]) {
                
                
                
                if (_model.hasDisbuted ||[currentUserObjectId isEqualToString:temModel.objectId]) {
                    
                    _buyerCell.acceptButton.hidden = YES;
                }
                else
                {
                _buyerCell.acceptButton.hidden = NO;
                
                _buyerCell.acceptButton.tag = indexPath.row;
                
                [_buyerCell.acceptButton addTarget:self action:@selector(giveMoney:) forControlEvents:UIControlEventTouchUpInside];
                
                }
            }
            else //回复者查看
            {
                
                
                //是否超过24小时
                
                NSDate *createdDate = _model.createdAt;
                
                NSDate *after24 = [createdDate dateByAddingTimeInterval:24*60*60];
                
                BOOL isUp24 = NO;
                
                if ( [after24 isEqualToDate:[after24 earlierDate:[NSDate date]]]) {
                    
                    isUp24 = YES;
                    
                }
                
                
                //如果已超过24小时，并且是自己的回复，并且没有领取，并且自己是在有效期内回复
                if (isUp24 && [currentUserObjectId isEqualToString:temModel.objectId] && !temModel.hadAccepted && temModel.isWithinValidate)
                {
                
                  
                    _buyerCell.acceptButton.tag = indexPath.row;
                    
                     [_buyerCell.acceptButton setTitle:@"领赏" forState:UIControlStateNormal];
                        
                     _buyerCell.acceptButton.hidden = NO;
                    
                    
                    [_buyerCell.acceptButton addTarget:self action:@selector(acceptMoney:) forControlEvents:UIControlEventTouchUpInside];
                    
                
                    
                    
                }
                else
                {
                    _buyerCell.acceptButton.hidden = YES;
                    
                }
                
                
                
            
            
                
                
            }
            
            //如果已经领取红包，则显示领取的数量
            if (temModel.hadAccepted) {
                
                _buyerCell.priceLabel.text = [NSString stringWithFormat:@"已领取:%.2f元",temModel.hongbaoNum];
                _buyerCell.priceLabel.adjustsFontSizeToFitWidth = YES;
                
            }
            else
            {
                _buyerCell.priceLabel.text = nil;
                
            }
            
            
            
            //等级
            [BmobHelper getOtherLevelWithUserName:temModel.username result:^(NSString *levelStr) {
                
                _buyerCell.levelLabel.text =  [NSString stringWithFormat:@"等级:%@",levelStr];
                
            }];
            
            
        }
        
        return _buyerCell;
        
        
        
    }
}

#pragma mark - 发红包
-(void)giveMoney:(UIButton*)sender
{
    NSDictionary *dic = [_model.comments objectAtIndex:sender.tag];
    
    UserModel *temUser = [[UserModel alloc]init];
    
    [temUser setValuesForKeysWithDictionary:dic];
    
    temUser.hadAccepted = YES;
    
    temUser.hongbaoNum = _model.hongbaoNum;
    
    
    [self saveHongbao:temUser withtag:sender.tag isSend:YES];
    
    
    
    
    
    
}

#pragma mark - 邻红包
-(void)acceptMoney:(UIButton*)sender
{
    NSDictionary *dic = [_model.comments objectAtIndex:sender.tag];
    
    UserModel *temUser = [[UserModel alloc]init];
    
    [temUser setValuesForKeysWithDictionary:dic];
    
    temUser.hadAccepted = YES;
    
    
    NSInteger temNum = 0;
    
    for (int i = 0 ; i < _model.comments.count; i++) {
        
        NSDictionary *temDic = [_model.comments objectAtIndex:i];
        
        UserModel *temModel = [[UserModel alloc]init];
        
        [temModel setValuesForKeysWithDictionary:temDic];
        
        NSString *username = [temDic objectForKey:@"username"];
        
        NSString *pubUsername = [_model.publisher objectForKey:@"username"];
        
        
        if (![username isEqualToString:pubUsername] && temModel.isWithinValidate ) {
        
            temNum ++;
            
        }
        
        
    }
    
    CGFloat num =(CGFloat)temNum;
    
    
    temUser.hongbaoNum = _model.hongbaoNum/num;
    
    
    [self saveHongbao:temUser withtag:sender.tag isSend:NO];
    
}

//保存红包
-(void)saveHongbao:(UserModel*)temUser withtag:(NSInteger)tag isSend:(BOOL)issend
{
    NSDictionary *finalDic = [temUser toDictionary];
    
    NSMutableArray *muArray = [[NSMutableArray alloc]init];
    
    [muArray addObjectsFromArray:_model.comments];
    
    [muArray replaceObjectAtIndex:tag withObject:finalDic];
    
    _model.comments = muArray;
    
    _model.hasDisbuted =issend;
    
    [self.tableView reloadData];
    
    
    BmobObject *ob = [BmobObject objectWithoutDatatWithClassName:kLinJinHuZhu objectId:_model.objectId];
    
    [ob setObject:muArray forKey:@"comments"];
    
    [ob setObject:@YES forKey:@"hasDisbuted"];
    
    
   
    
    [ob updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        
        if (isSuccessful) {
            
            NSLog(@"发送红包成功");
        
        
            NSString *beizhu = [NSString stringWithFormat:@"领取%@的红包",[_model.publisher objectForKey:@"nickName"]];
            [BmobHelper saveAccountDetail:temUser.username num:temUser.hongbaoNum isincome:YES beizhu:beizhu isDraw:NO alipayAccount:nil];
            
            
        }
        else
        {
            NSLog(@"error:%@",error);
            
        }
    }];
}



#pragma mark -回复
- (void)coment
{
    
    
    
//    isReplay = NO;
    
    
    
    _textField_comment.placeholder = @"请输入评论内容";
    [self.navigationController.view addSubview:_uiview_comment];
    
    if ([_textField_comment becomeFirstResponder])
    {
        NSLog(@"sdgfafg");
        
        
        
    }
    
    
    
    
}

-(void)showPublisherPersonInfo
{
    NSString *username = [_model.publisher objectForKey:@"username"];
    
    [self showPersonInfo:username];
    
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
    NSDictionary *dict = [_model.comments objectAtIndex:sender.tag];
    
    CommentModel *model = [[CommentModel alloc]init];
    
    [model setValuesForKeysWithDictionary:dict];
    
    [self showPersonInfo:model.username];
    
}

#pragma mark - 提交评论
-(void)sendComment
{
    
    if (_textField_comment.text.length == 0) {
        
        [CommonMethods showDefaultErrorString:@"请输入回复内容"];
        
        return;
        
    }
    
    
    [_textField_comment resignFirstResponder];
    
    [self.view endEditing:YES];
    
    
    UserModel *currentUserModel = [BmobHelper getCurrentUserModel];
    
    BmobObject *ob = [BmobObject objectWithoutDatatWithClassName:kLinJinHuZhu objectId:_model.objectId];

    currentUserModel.message = _textField_comment.text;
    currentUserModel.latitude = [[NSUserDefaults standardUserDefaults] floatForKey:kCurrentLatitude];
    
    currentUserModel.longitude = [[NSUserDefaults standardUserDefaults] floatForKey:kCurrentLongitude];
    
    if ([[NSDate date] isEqualToDate:[_model.validate earlierDate:[NSDate date]]] && ![_model.objectId isEqualToString:currentUserModel.objectId]) {
        
        currentUserModel.isWithinValidate = YES;
    }
    else
    {
        currentUserModel.isWithinValidate = NO;
        
    }
    
    NSDictionary *dic = [currentUserModel toDictionary];
    
    NSMutableArray *temArray = [[NSMutableArray alloc]init];
    
    [temArray addObjectsFromArray:_model.comments];
    
    [temArray addObject:dic];
    _model.comments = temArray;
    
    [ob addObjectsFromArray:@[dic] forKey:@"comments"];
    
    
    [self.tableView reloadData];
    
    [MyProgressHUD showProgress];
    
    [ob updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
       
        [MyProgressHUD dismiss];
        
        if (isSuccessful) {
            
            
        }
        else
        {
            NSLog(@"error:%@",error);
            
        }
    }];
    
}


#pragma mark - 是否已经领取了红包
-(BOOL)hadAcceptMoney:(NSString*)username
{
    BOOL hadAccept = NO;
    
    for (int i= 0 ; i < _model.comments.count; i++) {
        
        
        NSString *temUsername = [_model.comments objectAtIndex:i];
        
        if ([username isEqualToString:temUsername]) {
            
            hadAccept = YES;
            
        }
    }
    
    return hadAccept;
    
    
    
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









@end
