//
//  HuoDongMessageTVC.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/12/12.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "HuoDongMessageTVC.h"

static NSString *cellId = @"CellId";

@interface HuoDongMessageTVC ()
{
    
    NSMutableArray *_dataSource;
    
}
@end

@implementation HuoDongMessageTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"活动消息";
    
    _dataSource = [[NSMutableArray alloc]init];
    
    [self getData];
    
}

-(void)getData
{
    BmobQuery *query = [BmobQuery queryWithClassName:kHuoDongMessagesTableName];
    
    
    [query whereKey:@"username" equalTo:[BmobUser getCurrentUser].username];
    
    [query orderByDescending:@"createdAt"];
    
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
       
        if (!error && array) {
            
            [_dataSource addObjectsFromArray:array];
            
            
        }
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   
    

    
    return   _dataSource.count;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    BmobObject *ob = [_dataSource objectAtIndex:indexPath.section];
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        UILabel *titlelabel = (UILabel*)[cell viewWithTag:100];
        
        UILabel *contentLabel = (UILabel*)[cell viewWithTag:101];
        
        titlelabel.text = [ob objectForKey:@"title"];
        
        contentLabel.text = [ob objectForKey:@"message"];
        
        
        
        
    });
    
    return cell;
}


@end
