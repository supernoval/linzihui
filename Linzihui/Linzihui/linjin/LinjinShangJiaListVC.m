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
#import "BuyHistoryCell.h"
#import "ChatViewController.h"



@interface LinjinShangJiaListVC ()
{
    NSInteger pageSize;
    NSInteger pageIndex;
    
    NSMutableArray *_dataSource;
    
    UIButton *allButton;
    UIButton *myButton;
    
    BOOL isShowMine;
    
    BOOL isShowHistory;
    
    
    BmobObject *buyShangpinOB; //要付款的商品
    
    NSInteger atcionStatus; // 1付款  2确认收货  3评价
    
    UIButton *sellButton;
    
    UIButton *buyButton;
    
    BmobObject *myShangjia; //我的商家
    
    NSMutableArray *_muHistoryArray;
    
    
    
    
    
    
    
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
    _muHistoryArray = [[NSMutableArray alloc]init];
    
    UserModel *getmodel = [BmobHelper getCurrentUserModel];
    

    
    if (!getmodel.isShangJia) {
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"注册商家" style:UIBarButtonItemStylePlain target:self action:@selector(registShangjia)];
        
        self.navigationItem.rightBarButtonItem = item;
        
        
    }
    else
    {
        
        [self getMyShangjia];
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"我的商家" style:UIBarButtonItemStylePlain target:self action:@selector(showMyShangJia)];
        
        self.navigationItem.rightBarButtonItem = item;
    }
    
    pageSize = 10;
    pageIndex = 0;
    
    
    self.tableView.tableHeaderView = self.allHeaderView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buySuccess) name:kPaySucessNotification object:nil];
    
    
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


#pragma mark - 获取最近成交
-(void)getCurrentBuy
{
    BmobQuery *queryhist = [BmobQuery queryWithClassName:kBuyShangPin];
    
    [queryhist whereKey:@"shangjia" equalTo:myShangjia];
    [queryhist includeKey:@"address,buyer"];

    
    [queryhist whereKey:@"status" greaterThan:[NSNumber numberWithInt:0]];
    
    
    [queryhist findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        [MyProgressHUD dismiss];
        
        [self endHeaderRefresh];
        [self endFooterRefresh];
        
        if (array.count > 0) {
            
            for (int i = 0; i< array.count; i++) {
                
                BmobObject *ob = [array objectAtIndex:i];
                
                BuyShangPinModel *model = [[BuyShangPinModel alloc]init];
                
                [model setValuesForKeysWithDictionary:[ob valueForKey:kBmobDataDic]];
                
                model.createdAt = ob.createdAt;
                
                [_muHistoryArray addObject:model];
                
                
                
            }
            
         
            
            
        }
        
           [self.tableView reloadData];
        
        
    }];
}



-(void)getMyShangjia
{
     [MyProgressHUD showProgress];
    BmobQuery *query = [BmobQuery queryWithClassName:kShangJia];
    
    [query whereKey:@"username" equalTo:[BmobUser getCurrentUser].username];
    
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        
        [MyProgressHUD dismiss];
        
        if (array.count > 0) {
            
            
            myShangjia = [array objectAtIndex:0];
            
    
  
            
            
        }
        
        else{
            
        }
    }];
}
-(void)showMyShangJia
{
    
    ShangJiaModel *model = [[ShangJiaModel alloc]init];
    
    NSDictionary *dataDic = [myShangjia valueForKey:kBmobDataDic];
    BmobGeoPoint *location = [myShangjia objectForKey:@"location"];
    [model setValuesForKeysWithDictionary:dataDic];
    model.location = location;
    ShangJiaDetailVC *_shagnjiaDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ShangJiaDetailVC"];
    
    _shagnjiaDetailVC.model = model;
    
    
    [self.navigationController pushViewController:_shagnjiaDetailVC animated:YES ];
    

    
}
-(UIView*)myHeaderView
{
    if (!_myHeaderView) {
        
        
        _myHeaderView  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
        
        _myHeaderView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        sellButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/2, 50)];
        
        [sellButton setTitle:@"我出售" forState:UIControlStateNormal];
        [sellButton setTitleColor:kBlueBackColor forState:UIControlStateNormal];
        
        [sellButton addTarget:self action:@selector(showMySell) forControlEvents:UIControlEventTouchUpInside];
        
        [_myHeaderView addSubview:sellButton];
        
        
        buyButton = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth/2,0 , ScreenWidth/2, 50)];
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
    
    [sellButton setTitleColor:kBlueBackColor forState:UIControlStateNormal];
    
    [buyButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    
    
    [self.tableView.header beginRefreshing];
    
    
    
    
}

#pragma mark - 显示我购买
-(void)showMyBuy
{
    isShowHistory = YES;
    
    
    [sellButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    
    [buyButton setTitleColor:kBlueBackColor forState:UIControlStateNormal];
    
   [self.tableView.header beginRefreshing];
    
}




-(UIView*)allHeaderView
{
    if (!_allHeaderView) {
        
        
        _allHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
        _allHeaderView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        
        _typeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth/2, 50)];
        
        [_typeButton setTitle:@"分类" forState:UIControlStateNormal];
        
        [_typeButton addTarget:self action:@selector(showType) forControlEvents:UIControlEventTouchUpInside];
        
    
        
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
    
    
    if (isShowMine) {
        
          [_muHistoryArray removeAllObjects];
        
        [self getShangPin];
    }
    else
    {
        [_muHistoryArray removeAllObjects];
        
        [self loadData];
    }
   
    
}
-(void)footerRefresh
{
    pageIndex ++;
    
    [self loadData];
    
}


#pragma mark - 获取商家列表数据
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
            
        
            
            
            if (!isShowMine) {
                
                
         
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
         
            
        
        }
          [self.tableView reloadData];
        
        
    }];
}

#pragma mark - 获取购买或者出售商品
-(void)getShangPin
{
    [MyProgressHUD showProgress];
    
    BmobQuery *query = [BmobQuery queryWithClassName:kBuyShangPin];
    
    
    //获取我购买
    if (isShowHistory) {
        
        [query whereKey:@"username" equalTo:[BmobUser getCurrentUser].username];
        
        
        [query includeKey:@"shangpin"];
//        [query includeKey:@"shangjia"];
        [query includeKey:@"address"];
        
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            
            
            [self endFooterRefresh];
            [self endHeaderRefresh];
            
            
            [MyProgressHUD dismiss];
            
            
            if (pageIndex == 0) {
                
                [_dataSource removeAllObjects];
            }
            
            
            if (array.count > 0  && isShowMine) {
                
                for (BmobObject *ob in array) {
                    
                    
                    NSDictionary *data = [ob valueForKey:kBmobDataDic];
                    
                    BuyShangPinModel *model = [[BuyShangPinModel alloc]init];
                    
                    [model setValuesForKeysWithDictionary:data];
                    
                    NSDate *createdAt = [ob objectForKey:@"createdAt"];
                    
                    model.createdAt = createdAt;
                    
                    
                    [_dataSource addObject:model];
                    
                    
                    
                }
                
                
                
                
            }
            else
            {
                NSLog(@"error:%@",error);
                
            }
            
            [self.tableView reloadData];
            
            
        }];
        
        
    }
    else //获取我出售记录
    {
        
        [self getCurrentBuy];
        
//        [query whereKey:@"shangjia" equalTo:myShangjia];
        
        
    }
    

    
    
}

#pragma mark - 显示全部 或者我的
-(void)showAll:(UIButton*)sender
{
    
    [_typeButton setTitle:@"分类" forState:UIControlStateNormal];
    
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
        
        [_typeButton setTitle:[NSString stringWithFormat:@"%@",type] forState:UIControlStateNormal];
        
        
        
        
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
    
    if (isShowMine && !isShowHistory) {
        
        
        return _muHistoryArray.count;
        
    }
    return _dataSource.count;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isShowMine && !isShowHistory) {
        
        
        return 200;
        
    }
    
    return 92;
    
}



-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (isShowMine) {
        
        
        if (!isShowHistory) //显示我出售
        {
            
            BuyHistoryCell *historyCell = [tableView dequeueReusableCellWithIdentifier:@"BuyHistoryCell"];
            
            if (indexPath.row < _muHistoryArray.count) {
                
                BuyShangPinModel *model = [_muHistoryArray objectAtIndex:indexPath.section];
                
                historyCell.nameLabel.text = [model.buyer objectForKey:@"nickName"];
                
                [historyCell.nameButton setTitle:[model.buyer objectForKey:@"nickName"] forState:UIControlStateNormal];
                historyCell.nameButton.tag = indexPath.section;
                
                [historyCell.nameButton addTarget:self action:@selector(chat:) forControlEvents:UIControlEventTouchUpInside];
                
                historyCell.timeLabel.text = [CommonMethods getYYYYMMddHHmmssDateStr:model.createdAt];
                historyCell.shangpinnamelabel.text = model.shangpinName;
                historyCell.addresslabel.text = [model.address objectForKey:@"address"];
                
                NSLog(@"address%@",model.buyer);
                
//                 historyCell.addresslabel.text = @"sagdaogadf";
                historyCell.priceLabel.text = [NSString stringWithFormat:@"%.2f元",model.price];
                
                
                
            }
            
            historyCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            return historyCell;
        }
        
        
        
        //显示我购买
        ShangPinCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShangPinCell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.section < _dataSource.count) {
            
            BuyShangPinModel *model = [_dataSource objectAtIndex:indexPath.section];
            
            
            [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:model.shangpinPhoto] placeholderImage:kDefaultHeadImage];
            
            cell.nameLabel.text = model.shangpinName;
            
            cell.priceLabel.text = [NSString stringWithFormat:@"价格:%.2f元",model.price];
            
            cell.desLabel.text = [model.shangpin objectForKey:@"des"];
            
            
              cell.buyButton.tag = indexPath.section;
            
            if (isShowHistory) //显示我购买
            {
                
                
                         [cell.buyButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
                
                
                switch (model.status) {
                    case 0:
                    {
                       //未付款
                        
                        [cell.buyButton setTitle:@"付款" forState:UIControlStateNormal];
                        

                        
                        
                    }
                        break;
                    case 1:
                    {
                        //已付款
                        
                        [cell.buyButton setTitle:@"确认收货" forState:UIControlStateNormal];
                        
                   
                        
                        
                        
                    }
                        break;
                    case 2:
                    {
                        //已确认收货
                        [cell.buyButton setTitle:@"评价" forState:UIControlStateNormal];
                        
              
                    }
                        break;
                    case 3:
                    {
                        //已评价
                        cell.buyButton.hidden =YES;
                        
                        
                        
                    }
                        
                    default:
                        break;
                }
            }
            else
            {
                cell.buyButton.hidden = YES;
                
            }
            
            
        }
        
        return cell;
         
        
     }
    else
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
    
    
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (!isShowMine) {
        
        ShangJiaModel *model = [_dataSource objectAtIndex:indexPath.section];
        ShangJiaDetailVC *_shagnjiaDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ShangJiaDetailVC"];
        
        _shagnjiaDetailVC.model = model;
        
        
        [self.navigationController pushViewController:_shagnjiaDetailVC animated:YES ];
        

    
        
        
    }
    
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
    

}

-(void)buttonAction:(UIButton*)sender
{
    
    BuyShangPinModel *model = [_dataSource objectAtIndex:sender.tag];
    
    switch (model.status) {
        case 0:
        {
            atcionStatus = 1;
            
            [self payShangPin:model];
            
        }
            break;
        case 1:
        {
            atcionStatus = 2;
            
            [self confirn:model];
            
        }
            break;
        case 2:
        {
            atcionStatus = 3;
            
            [self comment:model];
            
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - 付款
-(void)payShangPin:(BuyShangPinModel*)model
{
    
   
    
    buyShangpinOB = [BmobObject objectWithoutDatatWithClassName:kBuyShangPin objectId:model.objectId];
    
    
    NSString *dateStr = [CommonMethods getNoSpaceDateStr:[NSDate date]];
    NSString *out_trade_no = [NSString stringWithFormat:@"%@%@",dateStr,[BmobUser getCurrentUser].username];
    
    
    PayOrderInfoModel *payModel = [[PayOrderInfoModel alloc]init];
    
    payModel.productName =model.shangpinName;
    
    payModel.productDescription = @"购买邻近商品";
    
    payModel.amount =  [NSString stringWithFormat:@"%.2f",model.price];
    payModel.out_trade_no = out_trade_no;
    
    [PayOrder loadALiPaySDK:payModel];
    
    
}


#pragma mark - 确认收货
-(void)confirn:(BuyShangPinModel*)model
{
    
    
    buyShangpinOB = [BmobObject objectWithoutDatatWithClassName:kBuyShangPin objectId:model.objectId];
    
    [buyShangpinOB setObject:[NSNumber numberWithInteger:2] forKey:@"status"];
    
    [buyShangpinOB updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        
        [MyProgressHUD dismiss];
        
        
        [CommonMethods showDefaultErrorString:@"确认成功"];
        
        model.status = 2;
        
        [self.tableView reloadData];
        
        
        
    }];
}

#pragma mark - 评价
-(void)comment:(BuyShangPinModel*)model
{
    
    
    PingJiaVC *pingjiaVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PingJiaVC"];
    
    
    pingjiaVC.model = model;
    pingjiaVC.shangjiausername = [model.shangjia objectForKey:@"username"];
    
    
   
    [self.navigationController pushViewController:pingjiaVC animated:YES];
    
    
    
    
}

-(void)buySuccess
{
    
    
    if (buyShangpinOB && atcionStatus == 1)
    {
        
        atcionStatus = 0;
        
        [MyProgressHUD showProgress];
        
        
        [buyShangpinOB setObject:[NSNumber numberWithInteger:1] forKey:@"status"];
        
        [buyShangpinOB updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            
            [MyProgressHUD dismiss];
            
            
            [CommonMethods showDefaultErrorString:@"购买成功"];
            
            [self.tableView.header beginRefreshing];
            
            
        }];
    }

    
    
    
    
}


-(void)chat:(UIButton*)sender
{
    
    BuyShangPinModel *shangpinModel = [_muHistoryArray objectAtIndex:sender.tag];
    
    
    UserModel *model = [[UserModel alloc]init];
    
    
    NSString *nickName = [shangpinModel.buyer objectForKey:@"nickName"];
    NSString *username =[shangpinModel.buyer objectForKey:@"username"];
    
    
    
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

-(void)sortData
{
    
}



@end
