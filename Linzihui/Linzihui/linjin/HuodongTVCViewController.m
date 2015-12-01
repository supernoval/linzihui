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


static NSString *huodongCellID = @"HuoDongCell";
static NSString *photoCellID = @"photoCell";
static NSString *personCellID = @"PersonCell";
static NSString *headerCellID = @"headerCell";

@interface HuodongTVCViewController ()
{
    NSInteger pageSize;
    
    NSInteger skip;
    
    NSMutableArray *_dataSource;
    
    
    
    
}
@end

@implementation HuodongTVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    
    self.title = @"邻近活动";
    
    _dataSource = [[NSMutableArray alloc]init];
    
    pageSize = 10;
    skip = 0;

    
    UIBarButtonItem *_item = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(gotoPublishActivity)];
    
    self.navigationItem.rightBarButtonItem = _item;
    
    [self addHeaderRefresh];
    
    [self addFooterRefresh];
    
    [self getData];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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

-(void)getData
{
    BmobQuery *query = [BmobQuery queryWithClassName:kHuoDongTableName];
    
    query.skip = skip *pageSize;
    
    query.limit = pageSize;
    
    [query includeKey:@"starter"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
       
        [self endHeaderRefresh];
        [self endFooterRefresh];
        
        if (!error && array.count > 0) {
            
            
            if (skip == 0) {
                
                [_dataSource removeAllObjects];
                
                
            }
            
            
            for (BmobObject *ob in array) {
                
                HuoDongModel *model = [[HuoDongModel alloc]init];
                
                NSDictionary *dataDict = [ob valueForKey:@"bmobDataDic"];
                
                [model setValuesForKeysWithDictionary:dataDict];
                
                model.objectId = ob.objectId;
                
                [_dataSource addObject:model];
                
                
            }
            
           
            
            
            [self.tableView reloadData];
            
        }
        
        
        
    }];
   
}

#pragma mark - 发布活动
-(void)gotoPublishActivity
{
    
    PublishActivity *_publish = [self.storyboard instantiateViewControllerWithIdentifier:@"PublishActivity"];
    
    
    [self.navigationController pushViewController:_publish animated:YES];
    
}


#pragma mark  - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        HuoDongModel *model = [_dataSource objectAtIndex:indexPath.section];
    if (indexPath.row == 0) {
        
        CGFloat totalHeight = 440 - 21*4;
        
        
        CGFloat xiangqingHeight = [StringHeight heightWithText:model.content font:FONT_15 constrainedToWidth:ScreenWidth - 85];
        
        if (xiangqingHeight < 21) {
            
            xiangqingHeight = 21;
        }
      
        totalHeight += xiangqingHeight;
        
        
        CGFloat teDianHeight = [StringHeight heightWithText:model.TeDian font:FONT_15 constrainedToWidth:ScreenWidth - 85];
        if (teDianHeight < 21) {
            
            teDianHeight = 21;
            
        }
  
        totalHeight += teDianHeight;
        
        
        CGFloat liuchengHeight = [StringHeight heightWithText:model.LiuCheng font:FONT_15 constrainedToWidth:ScreenWidth - 85];
        
        if (liuchengHeight < 21) {
            
            liuchengHeight = 21;
        }
        totalHeight += liuchengHeight;
        
        
        CGFloat zhuyiHeight = [StringHeight heightWithText:model.ZhuYiShiXiang font:FONT_15 constrainedToWidth:ScreenWidth - 85];
        
        if (zhuyiHeight < 21) {
            
            zhuyiHeight = 21;
            
        }
        
        totalHeight += zhuyiHeight;
        
        
        
        return totalHeight;
        
        
    }
    
    if (indexPath.row == 1) {
        
        CGFloat photoViewHeight = 0;
        
        NSArray *imgs = model.photoURL;
        
        long imageCount = imgs.count;
        int perRowImageCount = ((imageCount == 4) ? 2 : 3);
        CGFloat perRowImageCountF = (CGFloat)perRowImageCount;
        int totalRowCount = ceil(imageCount / perRowImageCountF);
        
        photoViewHeight = 95 * totalRowCount;
        
        return photoViewHeight;
        
        
    }
    
    if (indexPath.row == 2) {
        
        return 40;
    }
    

    
    return 50;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 10;
    
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *blankView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    
    
    blankView.backgroundColor = [UIColor clearColor];
    
    return blankView;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
   HuoDongModel *model = [_dataSource objectAtIndex:section];
    
    if (model.AttendUsers.count > 0) {
        
        return 3 + model.AttendUsers.count;
        
    }
    
    
    return 2 ;
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
        
        _huodongCell.timeLabel.text = model.startTime;
        
        _huodongCell.feeLabel.text = model.feeNum;
        
        _huodongCell.publisherLabel.text = model.realName;
        
        _huodongCell.distanceLabel.text = [CommonMethods distanceStringWithLatitude:[[model.location valueForKey:@"latitude"]floatValue] longitude:[[model.location valueForKey:@"longitude"]floatValue]];
        
        _huodongCell.attendNumLabel.text = [NSString stringWithFormat:@"%ld人已参加",(long)model.AttendUsers.count];
        
       
        _huodongCell.xiangqingLabel.text = model.content;
        
        CGFloat xiangqingHeight = [StringHeight heightWithText:model.content font:FONT_15 constrainedToWidth:ScreenWidth - 85];
        if (xiangqingHeight < 21) {
            
            xiangqingHeight = 21;
        }
        _huodongCell.xiangqingHeight.constant = xiangqingHeight;
        
        
        _huodongCell.teDianLabel.text = model.TeDian;
        
        CGFloat teDianHeight = [StringHeight heightWithText:model.TeDian font:FONT_15 constrainedToWidth:ScreenWidth - 85];
        if (teDianHeight < 21) {
            
            teDianHeight = 21;
            
        }
        _huodongCell.tedianHeight.constant = teDianHeight;
        
        
         _huodongCell.liuchengLabel.text = model.LiuCheng;
        
        
        CGFloat liuchengHeight = [StringHeight heightWithText:model.LiuCheng font:FONT_15 constrainedToWidth:ScreenWidth - 85];
        
        if (liuchengHeight < 21) {
            
            liuchengHeight = 21;
        }
       
        _huodongCell.liuchengHeight.constant = liuchengHeight;
        
        
        _huodongCell.zhuyiLabel.text = model.ZhuYiShiXiang;
        
        CGFloat zhuyiHeight = [StringHeight heightWithText:model.ZhuYiShiXiang font:FONT_15 constrainedToWidth:ScreenWidth - 85];
        
        _huodongCell.zhuyiHeight.constant = zhuyiHeight;
        
        
        _huodongCell.jiezhiLabel.text = model.endRegistTime;
        
        
        _huodongCell.contentView.tag = indexPath.section;
        
        [_huodongCell.attendButton addTarget:self action:@selector(attendHuoDong:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        
        
        
        
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
    
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(void)attendHuoDong:(UIButton*)sender
{
    
    NSInteger tag = [sender superview].tag;
    
    HuoDongModel *_model = [_dataSource objectAtIndex:tag];
    
    BmobObject *_ob  = [BmobObject objectWithoutDatatWithClassName:kHuoDongTableName objectId:_model.objectId];
    
    
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
            
        }
        else
        {
            NSLog(@"error:%@",error);
            
             [CommonMethods showDefaultErrorString:@"报名失败"];
            
        }
    }];
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end