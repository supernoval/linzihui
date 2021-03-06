//
//  HuodongTVCViewController.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/26.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "HuodongTVCViewController.h"
#import "PublishActivity.h"
#import "HuoDongCell.h"
#import "PhotoCell.h"
#import "PersonCell.h"
#import "HuoDongDetailTVC.h"



static NSString *huodongCellID = @"HuoDongCell";
static NSString *photoCellID = @"photoCell";
static NSString *personCellID = @"PersonCell";
static NSString *headerCellID = @"headerCell";

@interface HuodongTVCViewController ()
{
    NSInteger pageSize;
    
    NSInteger skip;
    
    NSInteger huodongType; // 0 全部活动   1 我的活动
    
    UIButton *allButton;
    UIButton *myButton;
    
    UIButton *startButton;  //我的发起
    UIButton *attendButton; //我参与的
    
    BOOL isMyActity;//是否查询我发起的活动
    
    
}

@property (nonatomic) UIView *footerView;
@property (nonatomic)UIView *headerView;


@end

@implementation HuodongTVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    
    self.title = @"邻近活动";
    
   
    
    pageSize = 10;
    skip = 0;

    
  
    UIBarButtonItem *_item = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(gotoPublishActivity)];
    
    self.navigationItem.rightBarButtonItem = _item;
    
  
    if (_isFromYaoYiYao) {
        
        
    }
    else
    {
        
        
        
        
        huodongType = 0;
        
         _dataSource = [[NSMutableArray alloc]init];
        
        [self addHeaderRefresh];
        
        [self addFooterRefresh];
        
        
        
    }

    
   
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_isFromYaoYiYao) {
        
        
    }
    else
    {
      
      [self.tableView.header beginRefreshing];
        
      [self.navigationController.view addSubview:self.footerView];
        
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
    [self.footerView removeFromSuperview];
    
    
    
}

-(UIView*)headerView
{
    if (!_headerView) {
        
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
        _headerView.backgroundColor = [UIColor whiteColor];
        
        startButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/2, 50)];
        
        [startButton setTitle:@"我的发起" forState:UIControlStateNormal];
        
        [startButton setTitleColor:kBlueBackColor
                          forState:UIControlStateNormal];
        
        [startButton addTarget:self action:@selector(showMyStart) forControlEvents:UIControlEventTouchUpInside];
        
        [_headerView addSubview:startButton];
        
        
        attendButton = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth/2, 0, ScreenWidth/2, 50)];
        
        [attendButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
        
        [attendButton setTitle:@"我的参与" forState:UIControlStateNormal];
        
        [attendButton addTarget:self action:@selector(showMyAttend) forControlEvents:UIControlEventTouchUpInside];
        
        
        [_headerView addSubview:attendButton];
        
        isMyActity = YES;
        
        
        
    }
    
    return _headerView;
    
}

-(void)showMyStart
{
    [startButton setTitleColor:kBlueBackColor
                      forState:UIControlStateNormal];
    [attendButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    
    isMyActity = YES;
    
    [self headerRefresh];
    
    
    
}
-(void)showMyAttend
{
    [startButton setTitleColor:kDarkGrayColor
                      forState:UIControlStateNormal];
    [attendButton setTitleColor:kBlueBackColor forState:UIControlStateNormal];
    
    isMyActity = NO;
    
     [self headerRefresh];
    
    
}
-(UIView*)footerView
{
    if (!_footerView) {
        
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 44, ScreenWidth, 44)];
        
        _footerView.backgroundColor = [UIColor whiteColor];
        
        
        allButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/2, 44)];
        
        [allButton setTitle:@"全部活动" forState:UIControlStateNormal];
        
        [allButton setTitleColor:kBlueBackColor forState:UIControlStateNormal];
        
        allButton.tag = 0;
        
        [allButton addTarget:self action:@selector(huodongTypeSwitch:) forControlEvents:UIControlEventTouchUpInside];
        
        [_footerView addSubview:allButton];
        
        
        myButton = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth/2, 0, ScreenWidth/2, 44)];
        
        [myButton setTitle:@"我的活动" forState:UIControlStateNormal];
        
        [myButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
        
        myButton.tag = 1;
        
        [myButton addTarget:self action:@selector(huodongTypeSwitch:) forControlEvents:UIControlEventTouchUpInside];
        
        [_footerView addSubview:myButton];
        
       
      
    }
    
    return _footerView;
    
    
}
-(void)headerRefresh
{
    skip = 0;
    [self getData];
    
    
}

-(void)footerRefresh
{
    skip ++;
    [self getData];
    
    
}

-(void)huodongTypeSwitch:(UIButton*)sender
{
    if (sender.tag == 0) {
        
        [allButton setTitleColor:kBlueBackColor forState:UIControlStateNormal];
        
        [myButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
        
        huodongType = 0;
        
        self.tableView.tableHeaderView = nil;
        
    }
    else
    {
        [allButton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
        
        [myButton setTitleColor:kBlueBackColor forState:UIControlStateNormal];
        huodongType = 1;
        
        
        self.tableView.tableHeaderView = self.headerView;
        
        
    }
    
    [self headerRefresh];
    
}

-(void)getData
{
    BmobQuery *query = [BmobQuery queryWithClassName:kHuoDongTableName];
    
    query.skip = skip *pageSize;
    
    query.limit = pageSize;
    
    [query  orderByDescending:@"updatedAt"];
    
    [query includeKey:@"starter"];
    
    
    if (huodongType == 1) { 
        
       
        
        if (isMyActity) {
            
           
             [query whereKey:@"starter" equalTo:[BmobUser getCurrentUser]];
            
        }
        else
        {
              BmobUser *currentUser = [BmobUser getCurrentUser];
             NSArray *attends = [currentUser objectForKey:@"attendActivities"];
            
            if (!attends) {
                
                attends = @[];
                
            }
            [query whereKey:@"objectId" containedIn:attends];
            
            
            
        }
        
        
     }
    
    if (_isShowGroupActivity) {
        
        [query whereKey:@"groupId" equalTo:_groupId];
        
        
    }
    
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
       
        [self endHeaderRefresh];
        [self endFooterRefresh];
        
        if (skip == 0) {
            
            [_dataSource removeAllObjects];
            
            
        }
        
        if (!error && array.count > 0) {
            
            
            
            for (BmobObject *ob in array) {
                
                HuoDongModel *model = [[HuoDongModel alloc]init];
                
                NSDate *startDate = [ob objectForKey:@"startTime"];
                NSDate *endDate = [ob objectForKey:@"endTime"];
                NSDate *endRegistTime = [ob objectForKey:@"endRegistTime"];
                
                NSDictionary *dataDict = [ob valueForKey:kBmobDataDic];
                
                [model setValuesForKeysWithDictionary:dataDict];
                
                model.objectId = ob.objectId;
                model.startTime = startDate;
                model.endTime = endDate;
                model.endRegistTime = endRegistTime;
                model.OB = ob;
              
                
                
                [_dataSource addObject:model];
                
                
             }
            
           
            
            
    
            
        }
        
        
         [self.tableView reloadData];
        
        
        
    }];
   
 }

#pragma mark - 发布活动
-(void)gotoPublishActivity
{
    
    PublishActivity *_publish = [self.storyboard instantiateViewControllerWithIdentifier:@"PublishActivity"];
    
    if (_isShowGroupActivity) {
        
        _publish.groupId = self.groupId;
        
    }
    
    [self.navigationController pushViewController:_publish animated:YES];
    
}


#pragma mark  - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    
    if (indexPath.row == 0) {
        
        return 362;
        
    }
    if (indexPath.row == 2) {
        
        return 40;
    }
    

    
    return 50;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    if (section == _dataSource.count -1) {
        
        return 54;
        
    }
    return 20;
    
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *blankView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    
    
    blankView.backgroundColor = [UIColor clearColor];
    
    return blankView;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
//   HuoDongModel *model = [_dataSource objectAtIndex:section];
//    
//    if (model.AttendUsers.count > 0) {
//        
//        return 3 + model.AttendUsers.count;
//        
//    }
//    
    
    return 1 ;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    
    return _dataSource.count ;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HuoDongModel *model = [_dataSource objectAtIndex:indexPath.section];
    
    
    if (indexPath.row == 0) {
        
        HuoDongCell *_huodongCell = [tableView dequeueReusableCellWithIdentifier:huodongCellID];
        
        _huodongCell.titleLabel.text = model.title;
        
        _huodongCell.addressLabel.text = model.address;
        
        _huodongCell.timeLabel.text =  [CommonMethods getYYYYMMddhhmmDateStr:model.startTime];
        
        _huodongCell.feeLabel.text =  [NSString stringWithFormat:@"%@元",model.feeNum];
        
        NSString *photoURL = model.backImage;
        
        
        [_huodongCell.ImageView sd_setImageWithURL:[NSURL URLWithString:photoURL] placeholderImage:nil];
        
        
        
//        _huodongCell.publisherLabel.text = model.realName;
        
        _huodongCell.distanceLabel.text = [CommonMethods distanceStringWithLatitude:[[model.location valueForKey:@"latitude"]floatValue] longitude:[[model.location valueForKey:@"longitude"]floatValue]];
        
        _huodongCell.attendNumLabel.text = [NSString stringWithFormat:@"%ld人已参加",(long)model.AttendUsers.count];
        
       
//        _huodongCell.xiangqingLabel.text = model.content;
        
//        CGFloat xiangqingHeight = [StringHeight heightWithText:model.content font:FONT_15 constrainedToWidth:ScreenWidth - 85];
//        if (xiangqingHeight < 21) {
//            
//            xiangqingHeight = 21;
//        }
//        _huodongCell.xiangqingHeight.constant = xiangqingHeight;
//        
//        
//        _huodongCell.teDianLabel.text = model.TeDian;
//        
//        CGFloat teDianHeight = [StringHeight heightWithText:model.TeDian font:FONT_15 constrainedToWidth:ScreenWidth - 85];
//        if (teDianHeight < 21) {
//            
//            teDianHeight = 21;
//            
//        }
//        _huodongCell.tedianHeight.constant = teDianHeight;
//        
//        
//         _huodongCell.liuchengLabel.text = model.LiuCheng;
//        
        
//        CGFloat liuchengHeight = [StringHeight heightWithText:model.LiuCheng font:FONT_15 constrainedToWidth:ScreenWidth - 85];
        
//        if (liuchengHeight < 21) {
//            
//            liuchengHeight = 21;
//        }
//       
//        _huodongCell.liuchengHeight.constant = liuchengHeight;
//        
//        
//        _huodongCell.zhuyiLabel.text = model.ZhuYiShiXiang;
//        
//        CGFloat zhuyiHeight = [StringHeight heightWithText:model.ZhuYiShiXiang font:FONT_15 constrainedToWidth:ScreenWidth - 85];
//        
//        _huodongCell.zhuyiHeight.constant = zhuyiHeight;
//        
//        
//        _huodongCell.jiezhiLabel.text = [CommonMethods getYYYYMMddhhmmDateStr: model.endRegistTime];
        
        
//        _huodongCell.contentView.tag = indexPath.section;
//        
//        
//        
//        NSInteger status = [CommonMethods activityStatusWithStartTime:model.startTime endTime:model.endTime];
//        
//        if (status == 1) {
//            
//            
//            _huodongCell.statusLabel.text =[NSString stringWithFormat:@"离活动开始:%@",[CommonMethods timeStringFromNow:model.startTime]];
//            
//            
//            
//            
//        }
//        if (status == 2) {
//            
//            _huodongCell.statusLabel.text = @"活动进行中";
//        }
//        if (status == 3) {
//            
//            _huodongCell.statusLabel.text = @"活动已结束";
//            
//            
//        }
//        
//        
//        if ([self hadAttend:model]) {
//            
//            _huodongCell.attendButton.enabled = NO;
//            
//            [_huodongCell.attendButton setTitle:@"已报名" forState:UIControlStateNormal];
//            
//        }
//        
//        else
//        {
//          
//
//            
//            _huodongCell.attendButton.enabled = YES;
//            
//            [_huodongCell.attendButton setTitle:@"报名参加" forState:UIControlStateNormal];
//            
//            [_huodongCell.attendButton addTarget:self action:@selector(attendHuoDong:) forControlEvents:UIControlEventTouchUpInside];
//            
//            
//        }
//        
//       
//        NSInteger registStatus = [CommonMethods activityRegistStatus:model.endRegistTime];
//        
//        if (registStatus == 2) {
//            
//            _huodongCell.attendButton.enabled = NO;
//            
//            [_huodongCell.attendButton setTitle:@"报名已截止" forState:UIControlStateNormal];
//            
//            
//        }
//        else
//        {
//            _huodongCell.attendButton.enabled = YES;
//            
//        }
//        
        
        
        
        
        return _huodongCell;
     }
    
    
    if (indexPath.row == 1) {
        
        PhotoCell *_photoCell = [tableView dequeueReusableCellWithIdentifier:photoCellID];
        
        _photoCell.imagesView.photoItemArray = model.photoURL;
        
        
        
        
        
        return _photoCell;
     }
    
    
    // person header
    if (indexPath.row == 2) {
        
        UITableViewCell *_headerCell = [tableView dequeueReusableCellWithIdentifier:headerCellID];
        
        dispatch_async(dispatch_get_main_queue(), ^{
          
            UILabel *_peopleNumLabel = (UILabel*)[_headerCell viewWithTag:100];
            
            
            if (model.AttendUsers.count > 0) {
                
                _peopleNumLabel.text = [NSString stringWithFormat:@"%ld人",(long)model.AttendUsers.count];
                
            }
            else
            {
                _peopleNumLabel.text = nil;
                
                
            }
            
        });
 
        
        
        
        return _headerCell;
        
    }
    
    
    if (indexPath.row  > 2) {
        
        PersonCell *_personCell = [tableView dequeueReusableCellWithIdentifier:personCellID];
        
        
        NSArray *personsArray = model.AttendUsers;
        
        NSDictionary *onePerson = [personsArray objectAtIndex:indexPath.row - 3];
        
        AttendUserModel * _usermodel = [[AttendUserModel alloc]init];
        
        [_usermodel setValuesForKeysWithDictionary:onePerson];
        
        
        [_personCell.headImageView sd_setImageWithURL:[NSURL URLWithString:_usermodel.headImageURL] placeholderImage:kDefaultHeadImage];
        
        NSString *name = _usermodel.nickName;
        
        if (!name) {
            
            name = _usermodel.userName;
            
        }
        _personCell.nameLabel.text = name;
        
        _personCell.distanceLabel.text = [CommonMethods distanceStringWithLatitude:_usermodel.latitude longitude:_usermodel.longitude];
        
        
        
        
        return _personCell;
    }
    
    
    return nil;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        
         HuoDongModel *model = [_dataSource objectAtIndex:indexPath.section];
        
        HuoDongDetailTVC *_detail = [self.storyboard instantiateViewControllerWithIdentifier:@"HuoDongDetailTVC"];
        
        _detail.huodong = model;
        
        
        [self.navigationController pushViewController:_detail animated:YES];
        
    }
   
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(void)attendHuoDong:(UIButton*)sender
{
    
    NSInteger tag = [sender superview].tag;
    
    HuoDongModel *_model = [_dataSource objectAtIndex:tag];
    
    BmobObject *_ob  = [BmobObject objectWithoutDataWithClassName:kHuoDongTableName objectId:_model.objectId];
    
    
    UserModel *currentUser = [BmobHelper getCurrentUserModel];
    
    NSString *nick = currentUser.nickName;
    if (!nick) {
        
        nick = @"";
    }
    NSString *headImageURL = currentUser.headImageURL;
    
    if (!headImageURL) {
        
        headImageURL = @"";
        
    }
    BmobGeoPoint *location = currentUser.location;
    
    CGFloat latitude = [[location valueForKey:@"latitude"] floatValue];
    
    CGFloat longitude = [[location valueForKey:@"longitude"]floatValue];
    
    AttendUserModel *_attendModel = [[AttendUserModel alloc]init];
    
    _attendModel.nickName = nick;
    _attendModel.userName = currentUser.username;
    _attendModel.headImageURL = headImageURL;
    _attendModel.latitude = latitude;
    _attendModel.longitude = longitude;
    
    NSDictionary *param = [_attendModel toDictionary];
    
    
    [_ob addObjectsFromArray:@[param] forKey:@"AttendUsers"];
    
    [_ob updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
       
        if (isSuccessful) {
            
            NSLog(@"updateSuccess");
            
            [CommonMethods showDefaultErrorString:@"报名成功"];
            
            
            NSMutableArray *_muarray = [[NSMutableArray alloc]initWithArray:_model.AttendUsers];
            
            [_muarray addObject:param];
            
            
            _model.AttendUsers = _muarray;
            
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:tag] withRowAnimation:UITableViewRowAnimationNone];
            
            
            
            
            
        }
        else
        {
            NSLog(@"error:%@",error);
            
             [CommonMethods showDefaultErrorString:@"报名失败"];
            
        }
    }];
    

    
}


-(BOOL)hadAttend:(HuoDongModel*)model
{
      BOOL hadAttend = NO;
    NSArray *dataArray = model.AttendUsers;
    
    BmobUser *currentUser = [BmobUser getCurrentUser];
    
    
    for (NSDictionary *dict in dataArray) {
        
        AttendUserModel *_attendmodel = [[AttendUserModel alloc]init];
        
        [_attendmodel setValuesForKeysWithDictionary:dict];
        
        
        if ([currentUser.username isEqualToString:_attendmodel.userName]) {
           
            hadAttend = YES;
            
        
        }
    }
    
  
    
    
    
    
    return hadAttend;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
