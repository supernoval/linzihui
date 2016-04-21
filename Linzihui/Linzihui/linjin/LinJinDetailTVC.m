//
//  LinJinDetailTVC.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/4/21.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "LinJinDetailTVC.h"
#import "PersonInfoViewController.h"

@interface LinJinDetailTVC ()<UITextFieldDelegate>
{
    
    UIView *_uiview_comment;
    
    
    UITextField *_textField_comment;
}
@end

@implementation LinJinDetailTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"互助详情";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self initCommentView];
    
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_uiview_comment removeFromSuperview];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    if (section == 0) {
        
        return 40;
    }
    
    return 0;
    
    
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    
    
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
        _erShouCell.pirceLabel.text = [NSString stringWithFormat:@"%.0f元",_model.hongbaoNum];
        
        
        
        
//        //zan
//        if (_model.zan.count == 0) {
//            
//            _erShouCell.likeNumLabel.text = nil;
//        }
//        else
//        {
//            _erShouCell.likeNumLabel.text = [NSString stringWithFormat:@"%ld",(long)_model.zan.count];
//            
//        }
//        
//        NSString *currentUsername = [BmobUser getCurrentUser].username;
//        
//        BOOL hadZan = NO;
//        
//        for (int i = 0; i < _model.zan.count; i++) {
//            
//            NSString *username = [_model.zan objectAtIndex:i];
//            
//            
//            if ([username isEqualToString:currentUsername]) {
//                
//                hadZan = YES;
//                
//                
//            }
//            
//        }
//        
//        if (hadZan) {
//            
//            [_erShouCell.likeButton setImage:[UIImage imageNamed:@"liked"] forState:UIControlStateNormal];
//        }
//        else
//        {
//            [_erShouCell.likeButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
//            
//        }
        
//        _erShouCell.likeButton.tag = indexPath.section;
//        
//        [_erShouCell.likeButton addTarget:self action:@selector(zanAction:) forControlEvents:UIControlEventTouchUpInside];
//        
//        _erShouCell.replayButton.tag = indexPath.section;
        
        [_erShouCell.replayButton addTarget:self action:@selector(coment) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        
        
        return _erShouCell;
        
    }
    else  //评论
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


@end
