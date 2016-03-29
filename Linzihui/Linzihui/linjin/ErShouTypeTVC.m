//
//  ErShouTypeTVC.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/3/29.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "ErShouTypeTVC.h"

@interface ErShouTypeTVC ()
{
    NSArray *typeArray;
    
}
@end

@implementation ErShouTypeTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    typeArray = @[@"女装",@"男装",@"鞋包配饰",@"手机",@"相机/摄像机",@"电脑/电脑配件",@"数码3C产品",@"奢侈品转让",@"服装/服饰",@"美容/美颜/香水",@"家居/日用品",@"食品/保健品",@"家用电器/影音设备",@"母婴/儿童用品/玩具",@"宠物/宠物用品",@"生活服务/票务/卡券",@"书刊音像/问题用品",@"二手汽车",@"汽摩/电动车/自行车"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return typeArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ershoutypeCell" ];
  
    if (!cell) {
        
        
     cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ershoutypeCell"];
        
        
        
        
    }
    
    NSString *type = [typeArray objectAtIndex:indexPath.section];
    
    cell.textLabel.text = [typeArray objectAtIndex:indexPath.section];
    
    
    if ([type isEqualToString:_selectedType]) {
        
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    _selectedType = [typeArray objectAtIndex:indexPath.section];
    
    
    if (_block) {
       
        _block(YES,_selectedType);
        
        
    }
    [self.navigationController popViewControllerAnimated:YES];
    
    
  
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(void)setBlock:(ErShouTypeBlock)block
{
    _block = block;
    
}
@end
