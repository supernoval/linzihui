//
//  LinJinHuZhuListTVC.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/4/21.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "LinJinHuZhuListTVC.h"
#import "HongBaoModel.h"
#import "PublishHuZhuTVC.h"
#import "PersonInfoViewController.h"



@interface LinJinHuZhuListTVC ()
{
    NSMutableArray *_huzhuDataSource;
    
    NSInteger pageSize;
    NSInteger pageIndex;
    
}
@end

@implementation LinJinHuZhuListTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _huzhuDataSource = [[NSMutableArray alloc]init];
    
    self.title = @"邻近互助";
      UIBarButtonItem *publishButton = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(publishHuZhu)];
    
    self.navigationItem.rightBarButtonItem = publishButton;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    pageSize = 10;
    pageIndex = 0;
    
    [self addHeaderRefresh];
    [self addFooterRefresh];
    

    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView.header beginRefreshing];
}

-(void)publishHuZhu
{
    PublishHuZhuTVC *_publish = [self.storyboard instantiateViewControllerWithIdentifier:@"PublishHuZhuTVC"];
    
    
    [self.navigationController pushViewController:_publish animated:YES ];
    
    
}

-(void)headerRefresh
{
    
    pageIndex = 0;
    
    [self loadData];
    
    
}

-(void)footerRefresh
{
    pageIndex ++;
    
    [self loadData];
    
}

-(void)loadData
{
    BmobQuery*query  = [BmobQuery queryWithClassName:kLinJinHuZhu];
    
    query.limit = pageSize;
    
    query.skip = pageSize *pageIndex;
    
    [query includeKey:@"publisher"];
    
    [query orderByDescending:@"createdAt"];
    
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
       
        [self endHeaderRefresh];
        [self endFooterRefresh];
        
        if (array.count > 0) {
            
            if (pageIndex == 0) {
                
                [_huzhuDataSource removeAllObjects];
                
            }
            
            
            for (int i = 0 ; i < array.count; i++) {
                
                
                BmobObject *Ob = [array objectAtIndex:i];
                
                NSDictionary *dic = [Ob valueForKey:kBmobDataDic];
                
                HongBaoModel *model = [[HongBaoModel alloc]init];
                
                [model setValuesForKeysWithDictionary:dic];
                
                BmobGeoPoint *location = [Ob objectForKey:@"location"];
                
                model.location = location;
                model.updatedAt = Ob.updatedAt;
                model.createdAt = Ob.createdAt;
                
                [_huzhuDataSource addObject:model];
                
                
            }
            
            [self.tableView reloadData];
            
            
        }
        
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _huzhuDataSource.count;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HongBaoModel *model = [_huzhuDataSource objectAtIndex:indexPath.section];
    
    
    CGFloat textHeight = [StringHeight heightWithText:model.content font:FONT_15 constrainedToWidth:ScreenWidth - 20];
    
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
    
    HongBaoModel *model = [_huzhuDataSource objectAtIndex:indexPath.section];
    
    CGFloat textHeight = [StringHeight heightWithText:model.content font:FONT_15 constrainedToWidth:ScreenWidth - 20];
    
    CGFloat photoViewHeight = 0;
    
    NSArray *imgs = model.photos;
    
    long imageCount = imgs.count;
    int perRowImageCount = ((imageCount == 4) ? 2 : 3);
    CGFloat perRowImageCountF = (CGFloat)perRowImageCount;
    int totalRowCount = ceil(imageCount / perRowImageCountF);
    
    photoViewHeight = 80 * totalRowCount;
    
    
    
    cell.contentLabelHeight.constant = textHeight;
    
    cell.photoViewHeight.constant = photoViewHeight;
    
    
    
    cell.contentLabel.text = model.content;
    
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
    
    //价格
    cell.pirceLabel.text = [NSString stringWithFormat:@"%.0f元",model.hongbaoNum];
    
    //zan
//    if (model.zan.count == 0) {
//        
//        cell.likeNumLabel.text = nil;
//    }
//    else
//    {
//        cell.likeNumLabel.text = [NSString stringWithFormat:@"%ld",(long)model.zan.count];
//        
//    }
    
//    NSString *currentUsername = [BmobUser getCurrentUser].username;
//    
//    BOOL hadZan = NO;
//    
//    for (int i = 0; i < model.zan.count; i++) {
//        
//        NSString *username = [model.zan objectAtIndex:i];
//        
//        
//        if ([username isEqualToString:currentUsername]) {
//            
//            hadZan = YES;
//            
//            
//        }
//        
//    }
//    
//    if (hadZan) {
//        
//        [cell.likeButton setImage:[UIImage imageNamed:@"liked"] forState:UIControlStateNormal];
//    }
//    else
//    {
//        [cell.likeButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
//        
//    }
//    
//    cell.likeButton.tag = indexPath.section;
//    
//    [cell.likeButton addTarget:self action:@selector(zanAction:) forControlEvents:UIControlEventTouchUpInside];
//    
//    cell.replayButton.tag = indexPath.section;
//    
//    [cell.replayButton addTarget:self action:@selector(replay:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.replayNumLabel.text = [NSString stringWithFormat:@"%ld",(long)model.comments];
    
    
    return cell;
}


#pragma mark - 显示个人信息
-(void)showPersonInfo:(UIButton*)sender
{
    ErShouModel *model = [_huzhuDataSource objectAtIndex:sender.tag];
    
    NSString *username = [model.publisher objectForKey:@"username"];
    
    
    PersonInfoViewController *_personInfo = [self.storyboard instantiateViewControllerWithIdentifier:@"PersonInfoViewController"];
    
    _personInfo.username = username;
    
    
    [self.navigationController pushViewController:_personInfo animated:YES];
    
}






@end
