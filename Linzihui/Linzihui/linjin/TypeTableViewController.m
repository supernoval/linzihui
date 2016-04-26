//
//  TypeTableViewController.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/4/27.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "TypeTableViewController.h"

@interface TypeTableViewController ()
{
    NSArray *_types;
    
}
@end

@implementation TypeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    if (_showType == 1) {
        
        self.title = @"经营类型";
        _types = @[@"餐饮美食",@"养生SPA",@"超市百货",@"宠物服务",@"家政保洁",@"教育培训",@"美发美甲",@"美容美妆",@"母婴亲子",@"摄影打字",@"维修",@"棋牌室",@"洗衣",@"游乐场",@"瑜伽",@"健身",@"医院",@"药店",@"宠物",@"服饰鞋包",@"汽车服务",@"水果生鲜",@"鲜花蛋糕",@"邻近",@"外卖",@"快递",@"旅游",@"金融",@"其它"];
    }
    else
    {
        self.title = @"覆盖范围";
        _types = @[@"3",@"5",@"8",@"10",@"15",@"20"];
        
    }
   
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    return _types.count;
    
}




-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
        
        
    }
    
    if (_showType == 1) {
        
        cell.textLabel.text = [_types objectAtIndex:indexPath.row];
    }
   
    else
    {
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@千米",[_types objectAtIndex:indexPath.row]];
        
        
    }
    
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSString *selectedtype = [_types objectAtIndex:indexPath.row];
    
    
    if (_block) {
        
        _block(selectedtype,_showType);
        
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


-(void)setblock:(TypePickBlock)block
{
    _block = block;
    
    
}



@end
