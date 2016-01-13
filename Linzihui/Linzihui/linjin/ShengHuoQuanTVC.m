//
//  ShengHuoQuanTVC.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/18.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "ShengHuoQuanTVC.h"
#import "SendWXViewController.h"
#import "ShengHuoModel.h"

static NSString *contentCell = @"ShenghuoQuanCell";
static NSString *commentCellID = @"CommentCell";


@interface ShengHuoQuanTVC ()<UITextFieldDelegate>
{
    NSInteger page;
    NSInteger limit;
    
    NSMutableArray *_dataSource;
    
    UIView *_uiview_comment;
    
    UITextField *_textField_comment;
    
    ShengHuoModel *_toCommentModel;  //被评论的
    NSString * _toReplayNick; // 回复哪行
    BOOL isReplay;
    
    NSInteger commentSection ; //评论的 section
    
    BmobGeoPoint *_currentPoint;  // 当前位置
    
    NSMutableArray *_shurenUserNameArray;
    
    
    
    
}


@end

@implementation ShengHuoQuanTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
  
    
    page = 0;
    limit = 10;
    
    _dataSource = [[NSMutableArray alloc]init];
    _shurenUserNameArray = [[NSMutableArray alloc]init];
    
    
    if (_isShuRenQuan == 1) {
        
        self.title = @"熟人圈";
        NSArray *buddyList = [[EaseMob sharedInstance].chatManager buddyList];
        
        
        for (EMBuddy *buddy in buddyList) {
            
            [_shurenUserNameArray addObject:buddy.username];
            
            
            
        }
        
        
        [_shurenUserNameArray addObject:[BmobUser getCurrentUser].username];
        
    }
    else if (_isShuRenQuan == 0)
    {
          self.title = @"生活圈";
    }
    else 
    {
        self.title = @"相册";
        
        self.navigationItem.rightBarButtonItem = nil;
        
    }

    
    self.tableView.backgroundColor = kBackgroundColor;
    
    CGFloat latitude = [[NSUserDefaults standardUserDefaults] floatForKey:kCurrentLatitude];
    CGFloat longitude = [[NSUserDefaults standardUserDefaults] floatForKey:kCurrentLongitude];
    
    _currentPoint = [[BmobGeoPoint alloc]initWithLongitude:longitude WithLatitude:latitude];
    
    
    
    
    [self addHeaderRefresh];
    
    [self addFooterRefresh];
    
    
  
    
    
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    [self initCommentView];
    
    
    
 
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView.header beginRefreshing];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
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
    
    [sendButton addTarget:self action:@selector(sendComment) forControlEvents:UIControlEventTouchUpInside];
    
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    
    sendButton.backgroundColor = kNavigationBarColor;
    
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [sendButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    
    sendButton.clipsToBounds = YES;
    
    sendButton.layer.cornerRadius = 5;
    
    [_uiview_comment addSubview:sendButton];
    
    
    
    
    
    
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

-(void)headerRefresh
{
    page = 0;
    
    [self getData];
    
}

-(void)footerRefresh
{
    page ++;
    
    [self getData];
    
    
}



-(void)getData
{
    
    BmobQuery *query = [BmobQuery queryWithClassName:kShengHuoQuanTableName];
    
    [query includeKey:@"publisher"];
    
    [query setLimit:limit];
    
    query.skip = page *limit;
    [query orderByDescending:@"createdAt"];
    
    if (_isShuRenQuan ==1) {
        
         [query whereKey:@"username" containedIn:_shurenUserNameArray];
        
        [query whereKey:@"type" equalTo:@1];
        
    }
    else if(_isShuRenQuan == 0)
    {
        [query whereKey:@"type" equalTo:@0];
        //    附近 3公里 条件限制
        [query whereKey:@"location" nearGeoPoint:_currentPoint  withinKilometers:3.0];
        
    }
    
    else if (_isShuRenQuan == 2)
    {
        
        [query whereKey:@"username" equalTo:[BmobUser getCurrentUser].username];
        
        
    }
    else if (_isShuRenQuan == 3)
    {
        
        NSArray *friendList = [[EaseMob sharedInstance].chatManager fetchBuddyListWithError:nil];
        
        NSLog(@"friendUserNames:%@",friendList);
        
        BOOL isFriend = NO;
        
        for (EMBuddy *buddy in friendList) {
            
            if ([buddy.username isEqualToString:_username]) {
                
                isFriend = YES;
                
            }
        }
        
        if (!isFriend) {
            
             [query whereKey:@"type" equalTo:@0];
        }
        
        [query whereKey:@"username" equalTo:_username];
        
        
    }
    
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
       
        [self endHeaderRefresh];
        [self endFooterRefresh];
        
        
        if (!error) {
            
            if (array.count > 0) {
                
                if (page == 0) {
                    
                    [_dataSource removeAllObjects];
                    
                }
                for (int i = 0; i < array.count; i++) {
                    
                    BmobObject *ob = [array objectAtIndex:i];
                     NSDictionary *dataDict = [ob valueForKey:@"bmobDataDic"];
                    
                    ShengHuoModel *model = [[ShengHuoModel alloc]init];
                    
                    [model setValuesForKeysWithDictionary:dataDict];
                    
                    model.objectId = ob.objectId;
                    model.createdAt = ob.createdAt;
                    model.updatedAt = ob.updatedAt;
                    
                    NSString *username = [[ob objectForKey:@"publisher"]valueForKey:@"username"];
                    
                    model.beizhu = [BmobHelper getBeizhu:username];
                    
                    [_dataSource addObject:model];
                    
                    
                }
                
               
                [self.tableView reloadData];
                
                
                
                
            }
            
        }
        
        else
        {
            NSLog(@"获取生活圈数据失败:%@",error);
            
            
            
        }
        
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 15;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *blankView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 15)];
    
    blankView.backgroundColor = [UIColor clearColor];
    
    
    
    return blankView;
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   
    
    return _dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ShengHuoModel *oneModel = [_dataSource objectAtIndex:section];
    
    return oneModel.comment.count + 1;
    
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (indexPath.row == 0) {
        ShengHuoModel *oneModel = [_dataSource objectAtIndex:indexPath.section];
        
        CGFloat photoViewHeight = 0;
        
        NSArray *imgs = oneModel.image_url;
        
        long imageCount = imgs.count;
        int perRowImageCount = ((imageCount == 4) ? 2 : 3);
        CGFloat perRowImageCountF = (CGFloat)perRowImageCount;
        int totalRowCount = ceil(imageCount / perRowImageCountF);
        
        photoViewHeight = 95 * totalRowCount;
        
        
        
        CGFloat textHeight = 0;
        
        
        NSString *text =oneModel.text;
        
        
        textHeight = [StringHeight heightWithText:text font:FONT_17 constrainedToWidth:ScreenWidth - 25];
        
        if (textHeight < 30)
        {
            
            textHeight = 30;
            
            
        }
        
        
        
        return 158 + photoViewHeight + textHeight;
        
    }
    else
    {
         ShengHuoModel *oneModel = [_dataSource objectAtIndex:indexPath.section];
        
        NSDictionary *oneComment = [oneModel.comment objectAtIndex:indexPath.row -1];
        
        NSString *text = [oneComment objectForKey:@"content"];
        
        
       CGFloat  textHeight = [StringHeight heightWithText:text font:FONT_16 constrainedToWidth:ScreenWidth - 144];
        
        
        if (textHeight > 37) {
            
            
            return 50 + textHeight - 37;
        }
        else
        {
            return 50;
        }
       
        
    }

    
 
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
   
    
    if (indexPath.section < _dataSource.count) {
        
        ShengHuoModel *oneModel = [_dataSource objectAtIndex:indexPath.section];
        
        BmobUser *user = oneModel.publisher;
        
        if (indexPath.row == 0)  //生活圈内容
        {
            
            
        ShenghuoQuanCell *cell = [tableView dequeueReusableCellWithIdentifier:contentCell];
        
            
        //时间
        NSString *timeStr = [CommonMethods timeStringFromNow:oneModel.createdAt];
            
        cell.timeLabel.text = [NSString stringWithFormat:@"%@前",timeStr];
            
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[user objectForKey:@"headImageURL"]]
                              placeholderImage:kDefaultHeadImage];
        
        
       //等级
         [BmobHelper getLevel:^(NSString *levelStr) {
             
             cell.levelLabel.text =  [NSString stringWithFormat:@"等级:%@",levelStr];
             
        }];
            
            CGFloat photoViewHeight = 0;
            
            NSArray *imgs = oneModel.image_url;
            
            long imageCount = imgs.count;
            int perRowImageCount = ((imageCount == 4) ? 2 : 3);
            CGFloat perRowImageCountF = (CGFloat)perRowImageCount;
            int totalRowCount = ceil(imageCount / perRowImageCountF);
            
            photoViewHeight = 95 * totalRowCount;
            
            
            
            CGFloat textHeight = 0;
            
            
            NSString *text =oneModel.text;
            
            
            textHeight = [StringHeight heightWithText:text font:FONT_17 constrainedToWidth:ScreenWidth - 25];
            
            if (textHeight < 30)
            {
                
                textHeight = 30;
                
                
            }
            
            
            //设置 photoview 和 textlabel 的高度
            cell.photoViewHeight.constant = photoViewHeight;
            
            cell.textLabelHeight.constant = textHeight;
            
            
            
            
       
        cell.nickNameLabel.text = oneModel.beizhu;
            
        if (!cell.nickNameLabel.text) {
                 cell.nickNameLabel.text = [user objectForKey:@"nickName"];
                
        }
        if (!cell.nickNameLabel.text) {
            
            cell.nickNameLabel.text = [user objectForKey:@"username"];
            
        }
        
        cell.photoView.photoItemArray = oneModel.image_url;
        
        cell.contentextLabel.text = oneModel.text;
        
        if (oneModel.comment.count > 0) {
           
            cell.commentNumLabel.text = [NSString stringWithFormat:@"%ld",oneModel.comment.count];
           
            }
            else
            {
                cell.commentNumLabel.text = @"";
                
            }
            
            if (oneModel.zan.count > 0) {
                
                cell.zanNumLabel.text = [NSString stringWithFormat:@"%ld",oneModel.zan.count];
                
            }
            else
            {
                cell.zanNumLabel.text =@"";
                
            }
        
        if ([[oneModel.location valueForKey:@"latitude"]floatValue] > 0 ) {
            
            NSString *distanceStr = [CommonMethods distanceStringWithLatitude:[[oneModel.location valueForKey:@"latitude"]floatValue] longitude:[[oneModel.location valueForKey:@"longitude"]floatValue]];
            
            
            cell.distanceLabel.text = distanceStr;
            
            
        }
       else
       {
           cell.distanceLabel.text = @"";
           
       }
        
        
        cell.contentView.tag = indexPath.section;
        
        
        [cell.zanButton addTarget:self action:@selector(zan:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.replayButton addTarget:self action:@selector(comment:) forControlEvents:UIControlEventTouchUpInside];
            
        
            
            //检测是否赞过
        
            BmobUser *currentUser = [BmobUser getCurrentUser];
            
            BOOL hadZan = NO;
            
            for (NSString *uid in oneModel.zan) {
                
                if ([uid isEqualToString:currentUser.username]) {
                    
                    hadZan = YES;
                    
                    
                    
                }
             
            }
            
            if (hadZan) {
                
                [cell.zanButton setImage:[UIImage imageNamed:@"liked"] forState:UIControlStateNormal];
            }
            else
            {
                [cell.zanButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
            }
        
         return cell;
        
        }
        
        else  //评论内容
        {
            
            NSDictionary *oneComment = [oneModel.comment objectAtIndex:indexPath.row -1];
            
            CommentModel *_model_comment = [[CommentModel alloc]init];
            [_model_comment setValuesForKeysWithDictionary:oneComment];
            
            CommentCell *_commentCell = [tableView dequeueReusableCellWithIdentifier:commentCellID];
            
            [_commentCell.headButton sd_setImageWithURL:[NSURL URLWithString:_model_comment.headImageURL] forState:UIControlStateNormal placeholderImage:kDefaultHeadImage];
            
            _commentCell.nameLabel.text = _model_comment.nick;
            
            if (!_model_comment.nick) {
                
                _commentCell.nameLabel.text = _model_comment.username;
                
            }
            
            NSString *content = nil;
            
            if (_model_comment.replayToNick.length > 0) {
                
                content = [NSString stringWithFormat:@"回复:%@ %@",_model_comment.replayToNick,_model_comment.content];
            }
            else
            {
                content = _model_comment.content;
                
            }
            _commentCell.commentLabel.text = content;
            
            
          
            
            
            return _commentCell;
            
            
            
        }
        
    }
    
    
    return nil;
    
    
    
   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        
        return;
    }
    
    commentSection = indexPath.section;
    
    _toCommentModel = [_dataSource objectAtIndex:indexPath.section];
  
    
    isReplay = YES;
    
    NSDictionary *replayDict = [_toCommentModel.comment objectAtIndex:indexPath.row -1];
    
    _toReplayNick = [replayDict objectForKey:@"nick"];
    
    if (!_toReplayNick) {
        
        _toReplayNick = [replayDict objectForKey:@"username"];
        
    }
    _textField_comment.placeholder = [NSString stringWithFormat:@"回复:%@",_toReplayNick];
    
    [self.navigationController.view addSubview:_uiview_comment];
    
    if ([_textField_comment becomeFirstResponder])
    {
        NSLog(@"sdgfafg");
        
        
        
    }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (IBAction)publishAction:(id)sender {
    

    
    
        
        _uiview_comment.frame = CGRectMake(0, ScreenHeight - 50, ScreenWidth, 50);
        
        [_uiview_comment removeFromSuperview];
            
 
    SendWXViewController *_sendVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SendWXViewController"];
    
    
    _sendVC.type = 0;
    
    _sendVC.isShuRenQuan = _isShuRenQuan;
    
    
    [self.navigationController pushViewController:_sendVC animated:YES];
    
    
    
}



#pragma mark - 点赞
-(void)zan:(UIButton*)sender
{
    NSInteger tag = [sender superview].tag ;
    
    ShengHuoModel *oneModel = [_dataSource objectAtIndex:[sender superview].tag];
    
    BmobUser *currentUser = [BmobUser getCurrentUser];
    
    BOOL hadZan = NO;
    
    for (NSString *uid in oneModel.zan) {
        
        if ([uid isEqualToString:currentUser.username]) {
            
            hadZan = YES;
            
        }
    }
    BmobObject *_ob = [BmobObject objectWithoutDatatWithClassName:kShengHuoQuanTableName objectId:oneModel.objectId];
    
    if (hadZan) {
        
        [_ob removeObjectsInArray:@[currentUser.username] forKey:@"zan"];
        
    }
    else
    {
        [_ob addObjectsFromArray:@[currentUser.username] forKey:@"zan"];
        
    }
    
    [_ob updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
       
        if (isSuccessful) {
            
            NSMutableArray *muArray = [[NSMutableArray alloc]initWithArray:oneModel.zan];
            
            if (hadZan) {
                
                [muArray removeObject:currentUser.username];
                
            }
            else
            {
                [muArray addObject:currentUser.username];
            }
            
            
            oneModel.zan = muArray;
            
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:tag] withRowAnimation:UITableViewRowAnimationNone];
            
            
            
        }
        else
        {
            NSLog(@"点赞 error:%@",error);
            
        }
    }];
    
    
}

#pragma mark -  评论
-(void)comment:(UIButton*)sender
{
    
    commentSection = [sender superview].tag ;
                      
    isReplay = NO;
    
    _toCommentModel = [_dataSource objectAtIndex:[sender superview].tag];
    
    _textField_comment.placeholder = @"请输入评论内容";
    [self.navigationController.view addSubview:_uiview_comment];
    
    if ([_textField_comment becomeFirstResponder])
    {
        NSLog(@"sdgfafg");
        
        
        
    }
    
    
    
}


#pragma mark - UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    
    return YES;
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
    
    BmobObject *shenghuoOB = [BmobObject objectWithoutDatatWithClassName:kShengHuoQuanTableName objectId:_toCommentModel.objectId];
    
    [shenghuoOB addObjectsFromArray:@[_dict] forKey:@"comment"];
    
    [shenghuoOB updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
       
        [MyProgressHUD dismiss];
        
        if (isSuccessful) {
            
            
            _textField_comment.text = nil;
            _toReplayNick = nil;
            
            NSMutableArray *muArray = [[NSMutableArray alloc]initWithArray:_toCommentModel.comment];
            
            [muArray addObject:_dict];
            
            _toCommentModel.comment = muArray;
            
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:commentSection] withRowAnimation:UITableViewRowAnimationNone];
            
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


-(void)dealloc
{
    
    [[NSNotificationCenter defaultCenter ]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [_uiview_comment removeFromSuperview];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
