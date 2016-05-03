//
//  LinjinShangJiaListVC.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/4/26.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "LinjinShangJiaListVC.h"
#import "ShangjiaListCell.h"
#import "RegistShangjiaTVC.h"
#import "ShangJiaModel.h"
#import "TypeTableViewController.h"

@interface LinjinShangJiaListVC ()
{
    NSInteger pageSize;
    NSInteger pageIndex;
    
    NSMutableArray *_dataSource;
    
    UIButton *allButton;
    UIButton *myButton;
    
    BOOL isShowMine;
    
    BOOL isShowHistory;
    
    
    
    
    
    
}
@property (nonatomic,strong) UIView*footerView;
@property (nonatomic,strong) UIView *allHeaderView;  //全部商家 header
@property (nonatomic,strong) UIButton *typeButton;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) UIButton *distanceButton;

@property (nonatomic,strong) UIView *myHeaderView; //我的 header




@end

@implementation LinjinShangJiaListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"商家列表";
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    
    _dataSource = [[NSMutableArray alloc]init];
    
    UserModel *getmodel = [BmobHelper getCurrentUserModel];
    
    if (!getmodel.isShangJia) {
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"注册商家" style:UIBarButtonItemStylePlain target:self action:@selector(registShangjia)];
        
        self.navigationItem.rightBarButtonItem = item;
        
        
    }
    
    
    pageSize = 10;
    pageIndex = 0;
    
    
    self.tableView.tableHeaderView = self.allHeaderView;
    
    [self addHeaderRefresh];
    
    [self addFooterRefresh];
    
 
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
       [self.tableView.header beginRefreshing];
    
    [self.navigationController.view addSubview:self.footerView];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.footerView removeFromSuperview];
    
}

-(UIView*)myHeaderView
{
    if (!_myHeaderView) {
        
        
        _myHeaderView  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
        
        _myHeaderView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        UIButton *sellButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/2, 50)];
        
        [sellButton setTitle:@"我出售" forState:UIControlStateNormal];
        [sellButton setTitleColor:kBlueBackColor forState:UIControlStateNormal];
        
        [sellButton addTarget:self action:@selector(showMySell) forControlEvents:UIControlEventTouchUpInside];
        
        [_myHeaderView addSubview:sellButton];
        
        
        UIButton *buyButton = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth/2,0 , ScreenWidth/2, 50)];
        [buyButton setTitle:@"我购买" forState:UIControlStateNormal];
        
        [buyButton setTitleColor:kBlueBackColor forState:UIControlStateNormal];
        
        [buyButton addTarget:self action:@selector(showMyBuy) forControlEvents:UIControlEventTouchUpInside];
        
        [_myHeaderView addSubview:buyButton];
    
        
        
        
    }
    
    return _myHeaderView;
    
    
}

#pragma makr- 显示我出售
-(void)showMySell
{
    isShowHistory = NO;
    
    
    [self.tableView.header beginRefreshing];
    
    
    
    
}

#pragma mark - 显示我购买
-(void)showMyBuy
{
    isShowHistory = YES;
    
   [self.tableView.header beginRefreshing];
    
}


-(UIView*)allHeaderView
{
    if (!_allHeaderView) {
        
        
        _allHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
        _allHeaderView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        
        _typeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth/2, 50)];
        
        [_typeButton setTitle:@"  分类:" forState:UIControlStateNormal];
        
        [_typeButton addTarget:self action:@selector(showType) forControlEvents:UIControlEventTouchUpInside];
        
        _typeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        [_typeButton setTitleColor:kBlueBackColor forState:UIControlStateNormal];
        
        [_allHeaderView addSubview:_typeButton];
        
        
        _distanceButton = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth/2, 0, ScreenWidth/2, 50)];
        
        [_distanceButton setTitle:@"距离" forState:UIControlStateNormal];
        
        [_distanceButton addTarget:self action:@selector(filterDistance) forControlEvents:UIControlEventTouchUpInside];
        
        [_distanceButton setTitleColor:kBlueBackColor forState:UIControlStateNormal];
        
        [_allHeaderView addSubview:_distanceButton];
        
        
        
        
        
        
    }
    
    return _allHeaderView;
    
}
-(void)filterDistance
{
    
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
    BmobQuery *query = [BmobQuery queryWithClassName:kShangJia];
    
    query.limit = pageSize;
    
    query.skip = pageSize *pageIndex;
    
    CGFloat latitude = [[NSUserDefaults standardUserDefaults] floatForKey:kCurrentLatitude];
    
    CGFloat longitude = [[NSUserDefaults standardUserDefaults] floatForKey:kCurrentLongitude];
    
    BmobGeoPoint *point = [[BmobGeoPoint alloc]init];
    
    point.latitude = latitude;
    
    point.longitude = longitude;
    
    
    if (_type.length > 0 && !isShowMine) {
        
        [query whereKey:@"type" equalTo:_type];
        
    }
    
    if (isShowMine && !isShowHistory) {
        
        [query whereKey:@"username" equalTo:[BmobUser getCurrentUser].username];
        
    }
    
    if (isShowHistory && isShowMine) {
        
        UserModel *currentUser = [BmobHelper getCurrentUserModel];
        
        if (currentUser.buyHistory.count == 0) {
            
            [_dataSource removeAllObjects];
            
            [self endFooterRefresh];
            [self endHeaderRefresh];
            
            [self.tableView reloadData];
            
            return;
            
            
        }
        else
        {
            [query whereKey:@"username" containedIn:currentUser.buyHistory];
            
        }
        
        
    }
    
    
    
    
    [query includeKey:@"publisher"];
    
    [query whereKey:@"location" nearGeoPoint:point withinKilometers:3.0];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
       
        [self endFooterRefresh];
        [self endHeaderRefresh];
        
        if (pageIndex == 0) {
            
            [_dataSource removeAllObjects];
            
            
        }
        
        if (array.count > 0) {
            
        
            
            for (int i = 0; i< array.count; i++) {
                
                BmobObject *Ob = [array objectAtIndex:i];
                
                ShangJiaModel *model = [[ShangJiaModel alloc]init];
                
                NSDictionary *dataDic = [Ob valueForKey:kBmobDataDic];
                 BmobGeoPoint *location = [Ob objectForKey:@"location"];
                [model setValuesForKeysWithDictionary:dataDic];
                model.location = location;
                
                [_dataSource addObject:model];
                
            }
        
            
        }
           [self.tableView reloadData];
        
    }];
}

#pragma mark - 显示全部 或者我的
-(void)showAll:(UIButton*)sender
{
    
    [_typeButton setTitle:@"  分类:" forState:UIControlStateNormal];
    
    _type = @"";
    
    
    
    if (sender.tag == 0) {
        
        
        self.tableView.tableHeaderView = self.allHeaderView ;
        [allButton setTitleColor:kBlueBackColor forState:UIControlStateNormal];
        
        [myButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
        
        
        isShowMine = NO;
        
        isShowHistory = NO;
        
        
        
    }
    else
    {
        
        
        self.tableView.tableHeaderView = self.myHeaderView;
        
        [allButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
        
        [myButton setTitleColor:kBlueBackColor forState:UIControlStateNormal];
        
        
        isShowMine = YES;
        
        
        
        
    }
    
    [self.tableView.header beginRefreshing];
}



-(void)showType
{
    TypeTableViewController *_typeSelecteTVC = [[TypeTableViewController alloc]initWithStyle:UITableViewStyleGrouped];
    
    _typeSelecteTVC.showType = 1;
    
    [_typeSelecteTVC setblock:^(NSString *type,NSInteger showType) {
        
        
        _type = type;
        
        [_typeButton setTitle:[NSString stringWithFormat:@"  分类: %@",type] forState:UIControlStateNormal];
        
        
        
        
    }];
    
    
    [self.navigationController pushViewController:_typeSelecteTVC animated:YES];
}
-(void)registShangjia
{
    RegistShangjiaTVC *_registShangJiaTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RegistShangjiaTVC"];
    
    
    [self.navigationController pushViewController:_registShangJiaTVC animated:YES];
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50;
    
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    
    view.backgroundColor = [UIColor clearColor];
    
    
    return view;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 92;
    
}



-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ShangjiaListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShangjiaListCell"];
    
    ShangJiaModel *model = [_dataSource objectAtIndex:indexPath.section];
    
    [cell.photoView sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:kDefaultHeadImage];
    
    cell.nameLabel.text = model.name;
    
    cell.typeLabel.text = model.type;
    
    BmobGeoPoint *point = model.location;
    
    cell.distanceLabel.text = [CommonMethods distanceStringWithLatitude:point.latitude longitude:point.longitude];
    
    
    cell.startViewConstant.constant = model.star/5 *100.0;
    
    
    
    
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
     ShangJiaModel *model = [_dataSource objectAtIndex:indexPath.section];
    ShangJiaDetailVC *_shagnjiaDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ShangJiaDetailVC"];
    
    _shagnjiaDetailVC.model = model;
    
    
    [self.navigationController pushViewController:_shagnjiaDetailVC animated:YES ];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}





@end
