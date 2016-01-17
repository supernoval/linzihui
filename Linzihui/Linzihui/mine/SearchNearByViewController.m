//
//  SearchNearByViewController.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/1/16.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "SearchNearByViewController.h"

@interface SearchNearByViewController ()<BMKPoiSearchDelegate,UITableViewDataSource,UITableViewDelegate,BMKCloudSearchDelegate,BMKGeoCodeSearchDelegate,UISearchBarDelegate,UITextFieldDelegate>
{
    BMKPoiSearch *_searcher;
    
    BMKCloudSearch *_cloudSearcher;
    
    BMKGeoCodeSearch *_geoSearch;
    
    UISearchBar *_mySearchBar;
    
    UITextField *_xiaoquTF;
    
    UITableView *_xiaoquTableView;
    
    NSMutableArray *_dataSource;
    
    
}
@end

@implementation SearchNearByViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"小区";
    
    
    _dataSource = [[NSMutableArray alloc]init];
    

    
    UIBarButtonItem *baocun = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAddress)];
    
    self.navigationItem.rightBarButtonItem = baocun;
    
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, 44)];
    headView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:headView];
    
    _xiaoquTF = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, ScreenWidth - 20, 44)];
    
    _xiaoquTF.delegate = self;
    
    _xiaoquTF.backgroundColor = [UIColor whiteColor];
    

    _xiaoquTF.placeholder = @"输入小区或者从下方选择小区";
    
    _xiaoquTF.returnKeyType = UIReturnKeyDone;
    
    [headView addSubview:_xiaoquTF];
    
    
    _xiaoquTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 110, ScreenWidth, ScreenHeight - 110)];
    
    
    
    _xiaoquTableView.delegate = self;
    _xiaoquTableView.dataSource = self;
    
    _xiaoquTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _xiaoquTableView.backgroundColor = kBackgroundColor;
    
    
    [self.view addSubview:_xiaoquTableView];

    
    
    _searcher = [[BMKPoiSearch alloc]init];
    
    _searcher.delegate = self;
    
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    
    option.pageIndex = 0;
    
    option.pageCapacity = 20;
    
    CGFloat lat = [[NSUserDefaults standardUserDefaults] floatForKey:kCurrentLatitude];
    
    CGFloat lon = [[NSUserDefaults standardUserDefaults]  floatForKey:kCurrentLongitude ] ;
    
    option.location = CLLocationCoordinate2DMake(lat, lon);
    option.sortType = BMK_POI_SORT_BY_DISTANCE;
    option.radius = 5000;
    
    option.keyword = @"小区,公寓";
    
    BOOL flag = [_searcher poiSearchNearBy:option];
    
    if (flag) {
        
        NSLog(@"周边检索成功");
        
    }
    else
    {
        NSLog(@"周边检索失败");
        
    }
    
//    BMKBoundSearchOption *boundOption = [[BMKBoundSearchOption alloc]init];
//    
//    boundOption.leftBottom = CLLocationCoordinate2DMake(lat - 0.001, lon - 0.001);
//    boundOption.rightTop = CLLocationCoordinate2DMake(lat + 0.001, lon + 0.001);
//    boundOption.keyword = @"馨宁公寓";
//    boundOption.pageCapacity = 50;
//    
//    boundOption.pageIndex = 1;
//    
//    BOOL success = [_searcher poiSearchInbounds:boundOption];
    
    
    //cloud search
//    _cloudSearcher = [[BMKCloudSearch alloc]init];
//    
//    _cloudSearcher.delegate =self;
//    
//    BMKCloudNearbySearchInfo *searchInfo = [[BMKCloudNearbySearchInfo alloc]init];
//    
//    searchInfo.location = [NSString stringWithFormat:@"%.3f,%.3f",lat,lon];
//    
//    searchInfo.radius = 5000;
//    
//    searchInfo.keyword = @"公寓";
//    
//    if ([_cloudSearcher  nearbySearchWithSearchInfo:searchInfo]) {
//        
//        
//        NSLog(@"sss");
//    }
//    else
//    {
//        
//        NSLog(@"fff");
//        
//    }
    
    
    
    //反编码
    _geoSearch = [[BMKGeoCodeSearch alloc]init];
    _geoSearch.delegate = self;
    
    BMKReverseGeoCodeOption *reveOption = [[BMKReverseGeoCodeOption alloc]init];
    
    reveOption.reverseGeoPoint = CLLocationCoordinate2DMake(lat, lon);
    
    if ([_geoSearch reverseGeoCode:reveOption]) {
        
        NSLog(@"成功");
    }
    
    
    
    
    
    
}


-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *blankView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    
    blankView.backgroundColor =[UIColor clearColor];
    
    
    return blankView;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 44;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellId"];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellId"];
        
        
    }
    
    BMKPoiInfo *info = [_dataSource objectAtIndex:indexPath.section];
    
    cell.textLabel.text = info.name;
    
  
    
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
     BMKPoiInfo *info = [_dataSource objectAtIndex:indexPath.section];
    
    if (_block) {
        
        if (info.name) {
            
            _block(info.name);
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



-(void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode
{
    
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        
       
        NSArray *list = poiResult.poiInfoList;
        
        if (list) {
            
            [_dataSource addObjectsFromArray:list];
            
            
            [_xiaoquTableView reloadData];
            
        }
        
    }
    else if (errorCode == BMK_SEARCH_AMBIGUOUS_KEYWORD)
    {
        NSLog(@"未找到结果");
        
    }
    else
    {
        NSLog(@"未找到结果");
        
    }
}


- (void)onGetCloudPoiResult:(NSArray*)poiResultList searchType:(int)type errorCode:(int)error
{
    
    if (poiResultList) {
        
        [_dataSource addObjectsFromArray:poiResultList];
        
        [_xiaoquTableView reloadData];
        
    }
}


-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    
    BMKAddressComponent *addressDetail = result.addressDetail;
    
    NSString *city = addressDetail.city;
    
    NSString *distrit = addressDetail.district;
    
    if (!city) {
        
        city = @"";
        
    }
    
    if (!distrit) {
        
        distrit = addressDetail.streetName;
    }
    
    if (!distrit) {
        
        distrit = @"";
    }
    
    NSString *area = [NSString stringWithFormat:@"%@ %@",city,distrit];
    
    
    [BmobHelper updateBmobWithKey:@"area" value:area object:[BmobUser getCurrentUser] result:^(BOOL isSuccess) {
        
        if (isSuccess) {
            
      
            
            
        }else
        {
            
            
        }
    }];
    
}
-(void)setBlock:(SearchBlock)block
{
    _block = block;
    
    
}

#pragma mark - UISearchBarDelegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    [searchBar resignFirstResponder];
    
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    
    searchBar.text = nil;
    
    [searchBar resignFirstResponder];
    
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
    
}

#pragma mark - UITextFieldDelegate 

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    
    
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    
}

#pragma mark - 保存
-(void)saveAddress
{
    if (_xiaoquTF.text.length == 0) {
        
        [CommonMethods showDefaultErrorString:@"请输入小区或者选择小区名称"];
        
        return;
    }
    
    
    if (_block) {
        
        if (_xiaoquTF.text) {
            
            _block(_xiaoquTF.text);
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
