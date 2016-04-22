//
//  HongBaoDetailList.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/4/23.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "HongBaoDetailList.h"
#import "HongBaoDetailCell.h"
#import "HongBaoDetailVC.h"


@interface HongBaoDetailList ()
{
    NSInteger pageSize;
    NSInteger pageIndex;
    NSMutableArray *_dataSource;
    
}
@end

@implementation HongBaoDetailList

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.title = @"红包明细";
    
    _dataSource = [[NSMutableArray alloc]init];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    pageSize = 15;
    pageIndex = 0;
    
    [self addHeaderRefresh];
    
    [self addFooterRefresh];
    
    
    [self.tableView.header beginRefreshing];
    
}

-(void)headerRefresh
{
    pageIndex = 0;
    
    [self loaddata];
    
    
}

-(void)footerRefresh
{
    pageIndex ++;
    
    [self loaddata];
    
    
}

-(void)loaddata
{
    [MyProgressHUD showProgress];
    
    BmobQuery *query = [BmobQuery queryWithClassName:kAccountDetail];
    
    query.limit = pageSize;
    query.skip = pageSize*pageIndex;
    
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"username" equalTo:[BmobUser getCurrentUser].username];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
       
        [MyProgressHUD dismiss];
        
        [self endFooterRefresh];
        [self endHeaderRefresh];
        
        
        if (array.count > 0) {
            
            if (pageIndex == 0) {
                
                [_dataSource removeAllObjects];
                
                
                
            }
            
            
            [_dataSource addObjectsFromArray:array];
            
            [self.tableView reloadData];
            
            
        }else
        {
            
        }
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
    
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *clearView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    
    clearView.backgroundColor = [UIColor clearColor];
    
    return clearView;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HongBaoDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HongBaoDetailCell"];
    
    if (indexPath.section < _dataSource.count) {
        
        BmobObject*OB = [_dataSource objectAtIndex:indexPath.section];
        
        
        cell.beizhuLabel.text = [OB objectForKey:@"beizhu"];
        
        cell.timeLabel.text = [CommonMethods getYYYYMMddHHmmssDateStr:OB.createdAt];
        
        BOOL isincome = [[OB objectForKey:@"isincome"]boolValue];
        
        CGFloat num = [[OB objectForKey:@"num"]floatValue];
        
        if (isincome) {
            
            cell.moneyLabel.text = [NSString stringWithFormat:@"+%.2f",num];
            
            cell.moneyLabel.textColor = kBlueBackColor;
        }
        else
        {
            cell.moneyLabel.text = [NSString stringWithFormat:@"-%.2f",num];
            
            cell.moneyLabel.textColor = [UIColor blackColor];
        }
        
        
        
    }

    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    BmobObject *ob = [_dataSource objectAtIndex:indexPath.section];
    
    HongBaoDetailVC *_detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HongBaoDetailVC"];
    _detailVC.OB = ob;
    
    [self.navigationController pushViewController:_detailVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



@end
