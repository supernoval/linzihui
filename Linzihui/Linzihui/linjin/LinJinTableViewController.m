//
//  LinJinTableViewController.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/2.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "LinJinTableViewController.h"
#import "ShengHuoQuanTVC.h"
#import "HuodongTVCViewController.h"
#import "MygroupListTVC.h"
#import "WodeHuodongTVC.h"
#import "PublishErShouVC.h"
#import "ErShouListTVC.h"
#import "PublishHuZhuTVC.h"
#import "LinJinHuZhuListTVC.h"
#import "LinjinShangJiaListVC.h"





static NSString *CellID = @"CellID";



@interface LinJinTableViewController ()
{
    NSArray *_titlesArray;
}



@end

@implementation LinJinTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//   _titlesArray = @[@{@"title":@"邻近动态",@"image":@"llni"},@{@"title":@"邻近活动",@"image":@"dss"},@{@"title":@"邻近群组",@"image":@"lingjids"},@{@"title":@"邻近二手",@"image":@"linjinershou"},@{@"title":@"邻近互助",@"image":@"linjinhuzhu"},@{@"title":@"邻近商家",@"image":@"lingjids"},@{@"title":@"红包大战",@"image":@"lingjids"},@{@"title":@"互助买卖房",@"image":@"lingjids"},@{@"title":@"团购新房",@"image":@"lingjids"}];
    
     _titlesArray = @[@{@"title":@"邻近动态",@"image":@"llni"},@{@"title":@"邻近活动",@"image":@"dss"},@{@"title":@"邻近群组",@"image":@"lingjids"},@{@"title":@"邻近二手",@"image":@"linjinershou"},@{@"title":@"邻近互助",@"image":@"linjinhuzhu"},@{@"title":@"邻近商家",@"image":@"linjinshangjia"}];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return _titlesArray.count;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        UIImageView *headImageView = (UIImageView*)[cell viewWithTag:100];
        UILabel *titlelabel = (UILabel*)[cell viewWithTag:101];
        
        NSDictionary *oneDict = [_titlesArray objectAtIndex:indexPath.section];
        
        NSString *title = [oneDict objectForKey:@"title"];
        NSString *image = [oneDict objectForKey:@"image"];
        
        titlelabel.text = title;
        
        headImageView.image = [UIImage imageNamed:image];
        
       
        
        
        
        
    });
    
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *blankView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    
    blankView.backgroundColor = [UIColor clearColor];
    
    return blankView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    return 1;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section == 0) // 生活圈
    {
        
        ShengHuoQuanTVC *_shengHuoquan = [self.storyboard instantiateViewControllerWithIdentifier:@"ShengHuoQuanTVC"];
        
        
        _shengHuoquan.isShuRenQuan = 0;
        
        _shengHuoquan.hidesBottomBarWhenPushed = YES;
        
        
        [self.navigationController pushViewController:_shengHuoquan animated:YES];
        
        

        
    
        
        
    }
    
    
    if (indexPath.section == 1)//邻近活动
    {
        
   
        HuodongTVCViewController *_huodongTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HuodongTVCViewController"];
        
        _huodongTVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:_huodongTVC animated:YES];
        
        
        
    }

    if (indexPath.section == 2) //领近群组
    {
        
        MygroupListTVC *_groupList = [self.storyboard instantiateViewControllerWithIdentifier:@"MygroupListTVC"];
        
        
        _groupList.hidesBottomBarWhenPushed = YES;
        
        _groupList.isNearGroup = YES;
        
        
        [self.navigationController pushViewController:_groupList animated:YES];
        
        
    }
    
    if (indexPath.section == 3) //邻近二手
    {
        ErShouListTVC *erShouListTVC =[self.storyboard instantiateViewControllerWithIdentifier:@"ErShouListTVC"];
        
        erShouListTVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:erShouListTVC animated:YES];
        
        

        
        
        
        
    }
    
    if (indexPath.section == 4)//邻近互助
    {
      
        LinJinHuZhuListTVC *_linjinHuZhu = [self.storyboard instantiateViewControllerWithIdentifier:@"LinJinHuZhuListTVC"];
        
        _linjinHuZhu.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:_linjinHuZhu animated:YES];
        
        
    
        
        
    }
    
    if (indexPath.section == 5)  //邻近商家
    {
        LinjinShangJiaListVC *_shangjiaVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LinjinShangJiaListVC"];
        
        _shangjiaVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:_shangjiaVC animated:YES];
        
        
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
