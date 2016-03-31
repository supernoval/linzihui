//
//  ErShouListTVC.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/3/30.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "ErShouListTVC.h"
#import "ErShouCell.h"
#import "PublishErShouVC.h"
#import "PersonInfoViewController.h"
#import "ErShouDetailTVC.h"



@interface ErShouListTVC ()<UITextFieldDelegate>
{
    NSMutableArray *_dataSource;
    
    BOOL isShowMine; //是否显示 “我的”
    
    UIButton *allButton;
    UIButton *myButton;
    
    NSInteger pageIndex;
    
    UIView *_uiview_comment;
    
    UITextField *_textField_comment;
    
    ErShouModel *_toCommentModel;  //被评论的
    NSString * _toReplayNick; // 回复哪行
    BOOL isReplay;
    
    NSInteger commentSection ; //评论的 section
    
}
@property (nonatomic,strong) UIView*footerView;

@end

@implementation ErShouListTVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
   
    self.title = @"邻近二手";
    _dataSource = [[NSMutableArray alloc]init];
    
    UIBarButtonItem *publishButton = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(publish)];
    
    self.navigationItem.rightBarButtonItem = publishButton;
    
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    
    pageIndex = 0;
    
    
    [self addHeaderRefresh];
    [self addFooterRefresh];
    

    
  
    
    [self loadDataErShou];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
     [self.navigationController.view addSubview:self.footerView];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.footerView removeFromSuperview];
    
    
}

-(void)headerRefresh
{
    pageIndex = 0;
    
    [self loadDataErShou];
    
    
    
}

-(void)footerRefresh
{
    pageIndex ++;
    
    [self loadDataErShou];
    
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
-(UIView*)footerView
{
    if (!_footerView) {
        
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 44, ScreenWidth, 44)];
        
        _footerView.backgroundColor = [UIColor whiteColor];
        
        
        allButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/2, 44)];
        
        [allButton setTitle:@"全部" forState:UIControlStateNormal];
        
        [allButton setTitleColor:kBlueBackColor forState:UIControlStateNormal];
        
        allButton.tag = 0;
        
        [allButton addTarget:self action:@selector(showAll:) forControlEvents:UIControlEventTouchUpInside];
        
        [_footerView addSubview:allButton];
        
        
        myButton = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth/2, 0, ScreenWidth/2, 44)];
        
        [myButton setTitle:@"我的" forState:UIControlStateNormal];
        
        [myButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
        
        myButton.tag = 1;
        
        [myButton addTarget:self action:@selector(showAll:) forControlEvents:UIControlEventTouchUpInside];
        
        [_footerView addSubview:myButton];
        
        
        
    }
    
    return _footerView;
    
    
}


#pragma mark - 显示全部 或者我的
-(void)showAll:(UIButton*)sender
{
    if (sender.tag == 0) {
        
        [allButton setTitleColor:kBlueBackColor forState:UIControlStateNormal];
        
        [myButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
        
  
        isShowMine = NO;
        
       
        
        
    }
    else
    {
        [allButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
        
        [myButton setTitleColor:kBlueBackColor forState:UIControlStateNormal];
    
        
        isShowMine = YES;
        
   
        
        
    }
    
    [self.tableView.header beginRefreshing];
}



#pragma mark-发布
-(void)publish
{
    PublishErShouVC *_publishErShou = [self.storyboard instantiateViewControllerWithIdentifier:@"PublishErShouVC"];
    
    _publishErShou.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:_publishErShou animated:YES];
    
    
}
-(void)loadDataErShou
{
    BmobQuery *query = [BmobQuery queryWithClassName:kErShou];
    
    
    [query orderByAscending:@"createdAt"];
    
    [query includeKey:@"publisher"];
    
    query.limit = 10;
    query.skip = 10*pageIndex;
    
    
    if (isShowMine) {
        
        [query whereKey:@"publisher" equalTo:[BmobUser getCurrentUser]];
        
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
       
        [self endHeaderRefresh];
        [self endFooterRefresh];
        
        if (pageIndex == 0) {
            
            [_dataSource removeAllObjects];
            
        }
        
        if (!error && array.count > 0) {
            
            
            for (int i = 0 ; i < array.count; i++) {
                
                BmobObject *Ob = [array objectAtIndex:i];
                
                NSDictionary *dic = [Ob valueForKey:kBmobDataDic];
                
                ErShouModel *model = [[ErShouModel alloc]init];
                
                [model setValuesForKeysWithDictionary:dic];
                
                BmobGeoPoint *location = [Ob objectForKey:@"location"];
                
                model.location = location;
                model.updatedAt = Ob.updatedAt;
                model.createdAt = Ob.createdAt;
                
                [_dataSource addObject:model];
                
                
            }
            
            
      
            
            
            
        }
             [self.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30;
    
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    footerView.backgroundColor = [UIColor clearColor];
    
    
    return footerView;
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ErShouModel *model = [_dataSource objectAtIndex:indexPath.section];
    
    
    CGFloat textHeight = [StringHeight heightWithText:model.des font:FONT_15 constrainedToWidth:ScreenWidth - 20];
    
    CGFloat photoViewHeight = 0;
    
    NSArray *imgs = model.photos;
    
    long imageCount = imgs.count;
    int perRowImageCount = ((imageCount == 4) ? 2 : 3);
    CGFloat perRowImageCountF = (CGFloat)perRowImageCount;
    int totalRowCount = ceil(imageCount / perRowImageCountF);
    
    photoViewHeight = 80 * totalRowCount;
    
    
    
    return 160 + textHeight + photoViewHeight;
    
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    ErShouCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"ErShouCell"];
    
     ErShouModel *model = [_dataSource objectAtIndex:indexPath.section];
    
    CGFloat textHeight = [StringHeight heightWithText:model.des font:FONT_15 constrainedToWidth:ScreenWidth - 20];
    
    CGFloat photoViewHeight = 0;
    
    NSArray *imgs = model.photos;
    
    long imageCount = imgs.count;
    int perRowImageCount = ((imageCount == 4) ? 2 : 3);
    CGFloat perRowImageCountF = (CGFloat)perRowImageCount;
    int totalRowCount = ceil(imageCount / perRowImageCountF);
    
    photoViewHeight = 80 * totalRowCount;
    
    
    
    cell.contentLabelHeight.constant = textHeight;
    
    cell.photoViewHeight.constant = photoViewHeight;
    
    

    cell.contentLabel.text = model.des;
    
    cell.photoView.photoItemArray = model.photos;
    
    [cell.headButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[model.publisher objectForKey:@"headImageURL"]] forState:UIControlStateNormal placeholderImage:kDefaultHeadImage];
    
    cell.headButton.tag = indexPath.section;
    
    [cell.headButton addTarget:self action:@selector(showPersonInfo:) forControlEvents:UIControlEventTouchUpInside];
    
    
    cell.nameLabel.text = [model.publisher objectForKey:@"nickName"];
    
    cell.timeLabel.text = [CommonMethods getYYYYMMddHHmmssDateStr:model.createdAt];
    cell.timeLabel.adjustsFontSizeToFitWidth = YES;
    
    //等级
    [BmobHelper getOtherLevelWithUserName:[model.publisher  objectForKey:@"username"] result:^(NSString *levelStr) {
        
        cell.levelLabel.text =  [NSString stringWithFormat:@"等级:%@",levelStr];
        
    }];
    
    BmobGeoPoint *location = model.location;
    
    CGFloat latitude = [[location valueForKey:@"latitude"]floatValue];
    
    CGFloat longitude = [[location valueForKey:@"longitude"]floatValue];
    
    
    cell.distanceLabel.text = [CommonMethods distanceStringWithLatitude:latitude longitude:longitude];
    
    
    //zan
    if (model.zan.count == 0) {
        
        cell.likeNumLabel.text = nil;
    }
    else
    {
        cell.likeNumLabel.text = [NSString stringWithFormat:@"%ld",(long)model.zan.count];
        
    }
    
    NSString *currentUsername = [BmobUser getCurrentUser].username;
    
    BOOL hadZan = NO;
    
    for (int i = 0; i < model.zan.count; i++) {
        
        NSString *username = [model.zan objectAtIndex:i];
        
       
        if ([username isEqualToString:currentUsername]) {
            
            hadZan = YES;
            
            
        }
        
    }
    
    if (hadZan) {
        
        [cell.likeButton setImage:[UIImage imageNamed:@"liked"] forState:UIControlStateNormal];
    }
    else
    {
        [cell.likeButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        
    }
    
    cell.likeButton.tag = indexPath.section;
    
    [cell.likeButton addTarget:self action:@selector(zanAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.replayButton.tag = indexPath.section;
    
    [cell.replayButton addTarget:self action:@selector(replay:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ErShouModel *model = [_dataSource objectAtIndex:indexPath.section];
    
    
    ErShouDetailTVC *_erShouDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"ErShouDetailTVC"];
    
    _erShouDetail.model = model;
    
    [self.navigationController pushViewController:_erShouDetail animated:YES];
    
    
}

#pragma mark - 评论
-(void)replay:(UIButton*)sender
{
    ErShouModel *model = [_dataSource objectAtIndex:sender.tag];
    
    
    
}


#pragma mark -  赞
-(void)zanAction:(UIButton*)sender
{
    
    
    ErShouModel *model = [_dataSource objectAtIndex:sender.tag];
    
    BmobObject *ob = [BmobObject objectWithoutDatatWithClassName:kErShou objectId:model.objectId];
    
    NSString *currentUsername = [BmobUser getCurrentUser].username;
    
    BOOL hadZan = NO;
    
    for (int i = 0; i < model.zan.count; i++) {
        
        NSString *username = [model.zan objectAtIndex:i];
        
        
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
            
            NSMutableArray *muArray = [[NSMutableArray alloc]initWithArray:model.zan];
            
            if (hadZan) {
                
                [muArray removeObject:currentUsername];
                
            }
            else
            {
                [muArray addObject:currentUsername];
            }
            
            
            model.zan = muArray;
            
             [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag] withRowAnimation:UITableViewRowAnimationNone];
            
        }
        
    }];
    
}

#pragma mark - 显示个人信息
-(void)showPersonInfo:(UIButton*)sender
{
    ErShouModel *model = [_dataSource objectAtIndex:sender.tag];
    
    NSString *username = [model.publisher objectForKey:@"username"];
    
    
    PersonInfoViewController *_personInfo = [self.storyboard instantiateViewControllerWithIdentifier:@"PersonInfoViewController"];
    
    _personInfo.username = username;
    
    
    [self.navigationController pushViewController:_personInfo animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
