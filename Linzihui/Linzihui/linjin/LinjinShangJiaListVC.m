//
//  LinjinShangJiaListVC.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/4/26.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "LinjinShangJiaListVC.h"
#import "ShangjiaListCell.h"
#import "RegistShangjiaTVC.h"

@interface LinjinShangJiaListVC ()

@end

@implementation LinjinShangJiaListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"商家列表";
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    
    
    UserModel *getmodel = [BmobHelper getCurrentUserModel  ];
    
    if (!getmodel.isShangJia) {
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"注册商家" style:UIBarButtonItemStylePlain target:self action:@selector(registShangjia)];
        
        self.navigationItem.rightBarButtonItem = item;
        
        
        
    }
    
    
    
    [self addHeaderRefresh];
    
    [self addFooterRefresh];
    
    
}

-(void)headerRefresh
{
    
}
-(void)footerRefresh
{
    
}

-(void)registShangjia
{
    RegistShangjiaTVC *_registShangJiaTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RegistShangjiaTVC"];
    
    
    [self.navigationController pushViewController:_registShangJiaTVC animated:YES];
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 92;
    
}



-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ShangjiaListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShangjiaListCell"];
    
    
    
    return cell;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
