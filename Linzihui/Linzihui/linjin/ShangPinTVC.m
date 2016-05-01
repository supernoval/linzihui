//
//  ShangPinTVC.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/5/2.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "ShangPinTVC.h"
#import "ShangPinTVC.h"

@interface ShangPinTVC ()
{
    NSMutableArray *_dataSource;
    
}
@end

@implementation ShangPinTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSource = [[NSMutableArray alloc]init];
    
    self.title = @"商品";
    
    NSString *username = [_model.publisher objectForKey:@"username"];
    
    NSString *currentUsername = [BmobUser getCurrentUser].username;
    
    if ([username isEqualToString:currentUsername]) {
        
        UIBarButtonItem *publishButton = [[UIBarButtonItem alloc]initWithTitle:@"发布商品" style:UIBarButtonItemStylePlain target:self action:@selector(publishShangpin)];
        
        self.navigationItem.rightBarButtonItem = publishButton;
        
    }
    
    
    [self loadData];
    
    
}

-(void)publishShangpin
{
    
}

-(void)loadData
{
    [MyProgressHUD showProgress];
    
    
    BmobQuery *query = [BmobQuery queryWithClassName:kShangPin];
    
    [query whereKey:@"shangjiaObjectId" equalTo:_model.objectId];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
       
        [MyProgressHUD dismiss];
        
        if (array.count > 0) {
            
            [_dataSource addObjectsFromArray:array];
            
            [self.tableView reloadData ];
            
        }
        else
        {
            NSLog(@"error:%@",error);
            
        }
        
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    
    view.backgroundColor = [UIColor clearColor];
    
    
    return view;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    ShangPinCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShangPinCell"];
    
    NSDictionary *dict = [_dataSource objectAtIndex:indexPath.row];
    
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"photos"]] placeholderImage:kDefaultHeadImage];
    
    cell.desLabel.text = [dict objectForKey:@"des"];
    
    cell.priceLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"price"]];
    
    
    
    return cell;
    
    


}






@end
