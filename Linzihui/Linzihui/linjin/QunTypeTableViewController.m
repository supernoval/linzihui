//
//  QunTypeTableViewController.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/6/2.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "QunTypeTableViewController.h"
#import "AddTypeViewController.h"

@interface QunTypeTableViewController ()
{
    BmobObject *_qunBaOB;
    
    NSMutableArray *_typesArray;
    
    
}
@end

@implementation QunTypeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.title = @"分类管理";
    _typesArray = [[NSMutableArray alloc]init];
    
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithTitle:@"新增" style:UIBarButtonItemStylePlain target:self action:@selector(addType)];
    
    self.navigationItem.rightBarButtonItem = button;
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    [self loadData];
}


-(void)addType
{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
    
    AddTypeViewController *addtypeVC = [sb instantiateViewControllerWithIdentifier:@"AddTypeViewController"];
    
    addtypeVC.QunOB = _qunBaOB;
    
    
    [self.navigationController pushViewController:addtypeVC animated:YES];
    
    
}

-(void)loadData
{
    
    [MyProgressHUD showProgress];
    
    BmobQuery *query = [BmobQuery queryWithClassName:kQunBa];
    
    [query whereKey:@"groupId" equalTo:_groupId];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
       
        [MyProgressHUD dismiss];
        
        
        
        [_typesArray removeAllObjects];
        
        if (array.count > 0) {
            
            _qunBaOB = [array firstObject];
            
            NSArray *types =[_qunBaOB objectForKey:@"types"];
            
            
            [_typesArray addObjectsFromArray:types];
            
            
        }
        
        [self.tableView reloadData];
        
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _typesArray.count;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid"];
    
    if (cell == NULL) {
        
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellid"];
        
        
    }
    
    
    if (indexPath.row < _typesArray.count) {
        
        cell.textLabel.text = [_typesArray objectAtIndex:indexPath.row];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
    
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_typesArray removeObjectAtIndex:indexPath.row];
    
    
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
