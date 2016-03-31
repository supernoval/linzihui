//
//  ErShouDetailTVC.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/3/31.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "ErShouDetailTVC.h"
#import "PersonInfoViewController.h"

@interface ErShouDetailTVC ()
{
    NSMutableArray *comments;
    
    UIToolbar *_myToolBar;
    
    
}
@end

@implementation ErShouDetailTVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"详情";
    
     _myToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, ScreenHeight - 44, ScreenWidth, 44)];
    
    [self initBottomView];
    
    
    
    
    
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
-(void)setModel:(ErShouModel *)model
{
    _model = model;
    
    comments = [[NSMutableArray alloc]init];
    
    [comments addObjectsFromArray:_model.comments];
    
    
}

#pragma mark - UITableViewDataSource
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
        return 0;
        
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
        
        [_erShouCell.replayButton addTarget:self action:@selector(replay:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        
        
        return _erShouCell;
        
    }
    
   else
   {
       
       
       
       ErShouCommentCell *_commentCell = [tableView dequeueReusableCellWithIdentifier:@"ErShouCommentCell"];
       
       
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


#pragma mark - 评论
-(void)replay:(UIButton*)sender
{
//    ErShouModel *model = [_dataSource objectAtIndex:sender.tag];
    
    
    
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




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
