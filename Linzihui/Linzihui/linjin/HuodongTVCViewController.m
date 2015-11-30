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

static NSString *huodongCellID = @"HuoDongCell";


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
    
    return 1;
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
        
        
        
        
        
        return _huodongCell;
    }
    
    return nil;
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
