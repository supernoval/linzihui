//
//  ShangPinTVC.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/5/2.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "ShangPinTVC.h"
#import "ShangPinTVC.h"
#import "PublishShangPinVC.h"

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
    
    
   
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [self loadData];
    
}
-(void)publishShangpin
{
    PublishShangPinVC *_publishVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PublishShangPinVC"];
    _publishVC.model = _model;
    
    [self.navigationController pushViewController:_publishVC animated:YES];
    
}

-(void)loadData
{
    [MyProgressHUD showProgress];
    
    
    BmobQuery *query = [BmobQuery queryWithClassName:kShangPin];
    
    [query orderByDescending:@"createdAt"];
    
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
    return 100;
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
    
    cell.nameLabel.text = [dict objectForKey:@"des"];
    
    cell.priceLabel.text = [NSString stringWithFormat:@"价格:%@",[dict objectForKey:@"price"]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *username = [_model.publisher objectForKey:@"username"];
    NSString *myusername = [BmobUser getCurrentUser].username;
    
    if ([username isEqualToString:myusername]) {
        
        cell.buyButton.hidden = YES;
        
    }
    else
    {
        cell.buyButton.tag = indexPath.row ;
        
        [cell.buyButton addTarget:self action:@selector(buy:) forControlEvents:UIControlEventTouchUpInside ];
    }

    
    
    
    
    return cell;
    
    


}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark - 购买
-(void)buy:(UIButton*)sender{
    
    
    
}




@end