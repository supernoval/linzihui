//
//  WodeHuodongTVC.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/12/20.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "WodeHuodongTVC.h"
#import "HuoDongDetailTVC.h"

@interface WodeHuodongTVC ()
{
    NSMutableArray *_dataSource;
    
    NSInteger skip;
    NSInteger size;
    
    BOOL isMyActity;
    
}
@end

@implementation WodeHuodongTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的活动";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.headerView.frame = CGRectMake(0, 0, ScreenWidth, 40);
    _dataSource = [[NSMutableArray alloc]init];
    
    skip = 0;
    size = 10;
    
    [self addHeaderRefresh];
    
    [self addFooterRefresh];
    
    isMyActity = NO;
    
    [self.tableView.header beginRefreshing];
    
//    BmobQuery *queryMy = [BmobQuery queryForUser];
//    
//    [queryMy whereKey:@"objectId" equalTo:[BmobUser getCurrentUser].]
    
    
    
}

-(void)headerRefresh
{
    skip = 0;
    
    [self getMyAttendData];
    
    
}

-(void)footerRefresh
{
    skip ++;
    
    [self getMyAttendData];
    
}
-(void)getMyAttendData
{
    BmobUser *currentUser = [BmobUser getCurrentUser];
    
    BmobQuery *query = [BmobQuery queryWithClassName:kHuoDongTableName];
    
    if (isMyActity) {
        
        [query whereKey:@"starter" equalTo:currentUser];
        
        
    }
    else
    {
        
    NSArray *attends = [currentUser objectForKey:@"attendActivities"];
    
        if (!attends) {
            
            attends = @[];
            
        }
    [query whereKey:@"objectId" containedIn:attends];
        
    
        
    }
    
    [query includeKey:@"starter"];
    
    query.skip = skip*size;
    
    query.limit = size;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
       
        [self endHeaderRefresh];
        [self endFooterRefresh];
        
        if (skip == 0) {
            
            [_dataSource removeAllObjects];
            
        }
        
        
        if (!error && array.count > 0) {
            
        
                for (BmobObject *ob in array) {
                    
                    HuoDongModel *model = [[HuoDongModel alloc]init];
                    
                    NSDictionary *dataDic = [ob valueForKey:kBmobDataDic];
                    
                    [model setValuesForKeysWithDictionary:dataDic];
                    
                    NSDate *startTime = [ob objectForKey:@"startTime"];
                    
                    model.startTime = startTime;
                    
                    NSDate *endDate = [ob objectForKey:@"endTime"];
                    NSDate *endRegistTime = [ob objectForKey:@"endRegistTime"];
                    
                  
                    model.objectId = ob.objectId;
                   
                    model.endTime = endDate;
                    model.endRegistTime = endRegistTime;
                
                    
                    
                    [_dataSource addObject:model];
                    
                }
                
                
            
           
        }
        
         [self.tableView reloadData];
        
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
    
    
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 1;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellId"];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        UILabel *titleLabel = (UILabel*)[cell viewWithTag:100];
        
        UILabel *timeLabel = (UILabel*)[cell viewWithTag:101];
        
        if (_dataSource.count > indexPath.section) {
            
            HuoDongModel *model = [_dataSource objectAtIndex:indexPath.section];
            
            titleLabel.text = model.title;
            
          
            
            timeLabel.text = [CommonMethods getYYYYMMddhhmmDateStr: model.startTime];
            
            
            
            
        }
        
        
    });
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HuoDongModel *model = [_dataSource objectAtIndex:indexPath.section];
    
    HuoDongDetailTVC *_detail = [self.storyboard instantiateViewControllerWithIdentifier:@"HuoDongDetailTVC"];
    
    _detail.huodong = model;
    
    
    [self.navigationController pushViewController:_detail animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (IBAction)switchAction:(id)sender {
    
   
    isMyActity = !isMyActity;
    
    [_dataSource removeAllObjects];
    
    [self.tableView.header beginRefreshing];
    
    
}
@end
