//
//  LinYouTableViewController.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/3.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "LinYouTableViewController.h"

static NSString *CellId  = @"CellId";

@interface LinYouTableViewController ()
{
    NSMutableArray *_muDataSource;
    
}
@end

@implementation LinYouTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    self.headView.frame = CGRectMake(0, 0, ScreenWidth, 44);
    
    _muDataSource = [self addtopContents];
    
    
    
    
}

-(NSMutableArray*)addtopContents
{
    
    NSMutableArray *muArray = [[NSMutableArray alloc]init];
    
    NSArray *topContentArray = @[@{@"image":@"newfriends",@"title":@"新朋友"},@{@"image":@"groupchat",@"title":@"群聊"},@{@"image":@"follow",@"title":@"关注"}];

    [muArray addObjectsFromArray:topContentArray];
    
    
    return muArray;
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return _muDataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        
        UIImageView *imageView = (UIImageView*)[cell viewWithTag:100];
        
        UILabel*titleLabel = (UILabel*)[cell viewWithTag:101];
        
        
        NSDictionary *oneDict = [_muDataSource objectAtIndex:indexPath.section];
        
        titleLabel.text = [oneDict objectForKey:@"title"];
        
        imageView.image = [UIImage imageNamed:[oneDict objectForKey:@"image"]];
        
        
        
        
    });
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}



@end
