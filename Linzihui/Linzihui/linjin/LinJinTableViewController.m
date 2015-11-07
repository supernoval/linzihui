//
//  LinJinTableViewController.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/2.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "LinJinTableViewController.h"

static NSString *CellID = @"CellID";



@interface LinJinTableViewController ()
{
    NSArray *_titlesArray;
}



@end

@implementation LinJinTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
   _titlesArray = @[@{@"title":@"邻近动态",@"image":@"llni"},@{@"title":@"邻近活动",@"image":@"dss"},@{@"title":@"邻近群组",@"image":@"lingjids"}];
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    
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
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
