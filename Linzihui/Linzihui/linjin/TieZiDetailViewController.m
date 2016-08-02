//
//  TieZiDetailViewController.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/6/1.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "TieZiDetailViewController.h"
#import "TieZiDetailCellTableViewCell.h"
#import "ChatViewController.h"
#import "TieZiReplayCell.h"
#import "PersonInfoViewController.h"
#import "WechatShareController.h"



@interface TieZiDetailViewController ()<UITextFieldDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{
    UIView *_uiview_comment;
    
    
    UITextField *_textField_comment;
    
    ErShouModel *_toCommentModel;  //被评论的
    
    NSString * _toReplayNick; // 回复哪行
    
    BOOL isReplay;
    
    UIAlertView *_jubaoAlertView;
    
}


@property (nonatomic,strong) UIToolbar *myToolBar;


@end

@implementation TieZiDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"帖子详情";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
  
    [self initCommentView];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.view addSubview:self.myToolBar];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.myToolBar removeFromSuperview];
    
}

-(UIToolbar*)myToolBar
{
    if (!_myToolBar) {
        
        
        _myToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, ScreenHeight - 44, ScreenWidth, 44)];
        
        UIBarButtonItem *zixun = [[UIBarButtonItem alloc]initWithTitle:@"联系" style:UIBarButtonItemStylePlain target:self action:@selector(connect)];
        
        UIBarButtonItem *xiangyao = [[UIBarButtonItem alloc]initWithTitle:@"关注" style:UIBarButtonItemStylePlain target:self action:@selector(follow)];
        
        UIBarButtonItem *common = [[UIBarButtonItem alloc]initWithTitle:@"回复" style:UIBarButtonItemStylePlain target:self action:@selector(replay)];
        
        UIBarButtonItem *fenxiang = [[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(share)];
        
        UIBarButtonItem *jubao  = [[UIBarButtonItem alloc]initWithTitle:@"举报"style:UIBarButtonItemStylePlain target:self action:@selector(jubao)];
        
        
        UIBarButtonItem *flex = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *flex1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *flex2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *flex3 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *flex4 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        
        
        _myToolBar.items = @[flex,zixun,flex,xiangyao,flex3,common,flex1,fenxiang,flex2,jubao,flex4];
        
        _myToolBar.tintColor = kBlueBackColor;
        
        
        
    }
    
    return _myToolBar;
    
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
    
    [sendButton addTarget:self action:@selector(summitReplay) forControlEvents:UIControlEventTouchUpInside];
    
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    
    sendButton.backgroundColor = kNavigationBarColor;
    
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [sendButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    
    sendButton.clipsToBounds = YES;
    
    sendButton.layer.cornerRadius = 5;
    
    [_uiview_comment addSubview:sendButton];
    
    
    
    
    
    
}


#pragma mark- 联系
-(void)connect
{
    
    NSString *username = [_model.publisher objectForKey:@"username"];
    
    if ([username isEqualToString:[BmobUser getCurrentUser].username]) {
        
        [CommonMethods showDefaultErrorString:@"不能和自己聊天"];
        
        return;
        
    }
    else
    {
        ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:[_model.publisher objectForKey:@"username"] isGroup:NO];
        
        
        chatVC.subTitle = [_model.publisher objectForKey:@"nickName"] ;
        
        
        
        chatVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:chatVC animated:YES];
    }
 
}

#pragma mark - 关注
-(void)follow
{
     NSString *username = [_model.publisher objectForKey:@"username"];
       if ([username isEqualToString:[BmobUser getCurrentUser].username])
       {
           
           [CommonMethods showDefaultErrorString:@"不能关注自己"];
           
           return;
       }
    
    UserModel *model = [[UserModel alloc]init];
    
    NSDictionary *dict = (NSDictionary *)_model.publisher;
    
    [model setValuesForKeysWithDictionary:dict ];
    
    
    [BmobHelper addFollowWithFollowedUserModel:model result:^(BOOL success) {
        
        if (success) {
            
            [CommonMethods showDefaultErrorString:@"关注成功"];
            
        }
        
    }];
}

#pragma mark - 回复
-(void)replay
{
   
    isReplay = NO;
    
    _textField_comment.placeholder = @"请输入评论内容";
    
    [self.navigationController.view addSubview:_uiview_comment];
    
    if ([_textField_comment becomeFirstResponder])
    {
        NSLog(@"sdgfafg");
        
        
    }
}

#pragma mark - 转发
-(void)share
{
    UIActionSheet *_actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    
    [_actionSheet addButtonWithTitle:@"分享到微信"];
    [_actionSheet addButtonWithTitle:@"分享到QQ"];
    
    [_actionSheet addButtonWithTitle:@"取消"];
    
    
    _actionSheet.cancelButtonIndex = 2;
    
    [_actionSheet showInView:self.view];
}

#pragma mark - 举报
-(void)jubao
{

    _jubaoAlertView = [[UIAlertView alloc]initWithTitle:nil message:@"确认要举报该用户吗?" delegate:self
                                      cancelButtonTitle:@"取消" otherButtonTitles:@"举报", nil];
        
    [_jubaoAlertView show];
        
        
    
}

#pragma mark - 回复提交
-(void)summitReplay
{
    
    [_textField_comment resignFirstResponder];
    
    
    if (_textField_comment.text.length == 0) {
        
        [CommonMethods showDefaultErrorString:@"请输入回复内容"];
        
        return;
    }
    
    UserModel *model = [BmobHelper getCurrentUserModel];
    
    model.message = _textField_comment.text;
    
    CGFloat latitude = [[NSUserDefaults standardUserDefaults] floatForKey:kCurrentLatitude];
    CGFloat longitude = [[NSUserDefaults standardUserDefaults] floatForKey:kCurrentLongitude];
    
    BmobGeoPoint *point = [[BmobGeoPoint alloc]init];
    
    point.latitude = latitude;
    point.longitude = longitude;
    
    model.location = point;
    
    model.createdAt = [CommonMethods getYYYYMMddHHmmssDateStr:[NSDate date]];
    
    
    NSDictionary *dict = [model toDictionary];
    
    NSMutableArray *muArray = [[NSMutableArray alloc]init];
    [muArray addObjectsFromArray:_model.replay];
    
    [muArray addObject:dict];
    
    _model.replay = muArray;
    
    [self.tableView reloadData];
    
    //上传
    BmobObject *ob = [BmobObject objectWithoutDataWithClassName:kTieZi objectId:_model.objectId];
    
    [ob addObjectsFromArray:@[dict] forKey:@"replay"];
    
    [ob updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
       
        
        if (isSuccessful) {
            
            NSLog(@"回复成功");
        }
        else
        {
            NSLog(@"回复失败:%@",error);
            
        }
    }];
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 40;
        
    }
    
    if (section == _model.replay.count) {
        
        return 50;
        
    }
    return 20;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    if (section == 0) {
        
        UILabel *replayLabel = [CommonMethods labelWithText:@"  回复内容:" textColor:[UIColor blackColor] font:FONT_15 textAligment:NSTextAlignmentLeft frame:CGRectMake(0,0,ScreenWidth,40)];
        
        return replayLabel;
        
        
        
    }
    
    if (section == _model.replay.count) {
        
        UIView *blankView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
        
        blankView.backgroundColor = [UIColor clearColor];
        
        return blankView;
    }
    
    
    UIView *blankView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    
    blankView.backgroundColor = [UIColor clearColor];
    
    return blankView;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
     return _model.replay.count +1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        CGFloat height = [StringHeight heightWithText:_model.content font:FONT_15 constrainedToWidth:ScreenWidth - 40];
        
        if (height < 40) {
            
            height = 40;
            
        }
        
        NSInteger num = _model.photos.count /3 + 1;
        
        
      
        return 205 + 80 *num +height;
        
    }
    else
    {
        
        NSDictionary *dict = [_model.replay objectAtIndex:indexPath.section -1];
        
        UserModel *model = [[UserModel alloc]init];
        
        [model setValuesForKeysWithDictionary:dict];
        
        CGFloat textHeight = [StringHeight heightWithText:model.message font:FONT_15 constrainedToWidth:ScreenWidth - 30];
        
        if (textHeight < 21) {
            
            textHeight = 21;
        }
        
        return 128 + textHeight;
        
    }

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        
        TieZiDetailCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TieZiDetailCellTableViewCell"];
        
        
        [cell.headButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[_model.publisher objectForKey:@"headImageURL"] ] forState:UIControlStateNormal];
        
        [cell.headButton addTarget:self action:@selector(showpublisherInfo) forControlEvents:UIControlEventTouchUpInside];
        
        cell.nameLabel.text = [_model.publisher objectForKey:@"nickName"];
        
        cell.timeLabel.text = [CommonMethods getYYYYMMddhhmmDateStr:_model.createdAt];
        
        cell.titleLabel.text = _model.title;
        
        cell.distanceLabel.text = [CommonMethods distanceStringWithLatitude:_model.location.latitude longitude:_model.location.longitude];
        
        [BmobHelper getOtherLevelWithUserName:[_model.publisher objectForKey:@"username" ] result:^(NSString *levelStr) {
            
            cell.levelLabel.text = levelStr;
            
        }];
        
        CGFloat height = [StringHeight heightWithText:_model.content font:FONT_15 constrainedToWidth:ScreenWidth - 40];
        
        if (height < 40) {
            
            height = 40;
            
        }
        cell.contentHeightConstant.constant = height;
        
        cell.contentLabel.text = _model.content;
        
        cell.photosView.photoItemArray = _model.photos;
    
        
        return cell;
        
        
    }
    else
    {
        NSDictionary *dict = [_model.replay objectAtIndex:indexPath.section -1];
        
        UserModel *model = [[UserModel alloc]init];
        
        [model setValuesForKeysWithDictionary:dict];
        
        CGFloat textHeight = [StringHeight heightWithText:model.message font:FONT_15 constrainedToWidth:ScreenWidth - 30];
        
        if (textHeight < 21) {
            
            textHeight = 21;
        }
        
       
        TieZiReplayCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"TieZiReplayCell"];
        
        [cell.headButton sd_setBackgroundImageWithURL:[NSURL URLWithString:model.headImageURL] forState:UIControlStateNormal];
        
        cell.headButton.tag = indexPath.section -1;
        
        [cell.headButton addTarget:self action:@selector(showReplayerInfo:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        cell.nameLabel.text = model.nickName;
        
        [BmobHelper getOtherLevelWithUserName:model.username result:^(NSString *levelStr) {
           
            cell.levelLabel.text = levelStr;
        }];
        
        
        CGFloat latitude = [[[dict objectForKey:@"location"] objectForKey:@"latitude"]floatValue];
        
        CGFloat longitude = [[[dict objectForKey:@"location"] objectForKey:@"longitude"]floatValue];
        
        NSString *disString = [CommonMethods distanceStringWithLatitude:latitude longitude:longitude];
        
        cell.distanceLabel.text = disString;
        
        cell.timeLabel.text = model.createdAt;
        
        cell.contentLabel.text = model.message  ;
        
        
        
        return cell;
        
    }

    
    
 
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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


-(void)showReplayerInfo:(UIButton*)sender
{
    NSDictionary *dict = [_model.replay objectAtIndex:sender.tag];
    
    NSString *string = [dict objectForKey:@"username"];
    
    [self showPersonInfo:string];
    
}

-(void)showpublisherInfo
{
    NSString *username = [_model.publisher objectForKey:@"username"];
    
    [self showPersonInfo:username];
    
}

#pragma mark - 显示个人资料
-(void)showPersonInfo:(NSString *)username
{
    
    UIStoryboard *SB = [UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
    
    
    PersonInfoViewController*_personInfoVC = [SB instantiateViewControllerWithIdentifier:@"PersonInfoViewController"];
    
    _personInfoVC.username = username;
    _personInfoVC.isShowed = YES;
    
    
    [self.navigationController pushViewController:_personInfoVC animated:YES];
}

#pragma mark - UITextFieldDelegate
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [_textField_comment resignFirstResponder];
    
    return YES;
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

#pragma mark- UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == _jubaoAlertView && buttonIndex == 1) {
        
        
        
        BmobObject *ob = [BmobObject objectWithoutDataWithClassName:kTieZi objectId:_model.objectId];
        
        [ob addObjectsFromArray:@[[BmobUser getCurrentUser].username] forKey:@"jubao"];
        
        [ob updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            
            if (isSuccessful) {
                
                [CommonMethods showDefaultErrorString:@"举报成功"];
                
                
            }
        }];
        
    }
    
    
    
}


@end
