//
//  QunBaTypeSelectedTVC.m
//  Linzihui
//
//  Created by Haikun Zhu on 16/8/1.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "QunBaTypeSelectedTVC.h"

@interface QunBaTypeSelectedTVC ()<UITableViewDelegate,UITableViewDataSource>


@end

@implementation QunBaTypeSelectedTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _typesArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"typecell"];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"typecell"];
        
    }
    
    NSDictionary *dict = [_typesArray objectAtIndex:indexPath.row];
    NSString *text = [dict objectForKey:@"text"];
    
    cell.textLabel.text = text;
    
    if ([text isEqualToString:_selectedType]) {
        
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
    NSDictionary *dict = [_typesArray objectAtIndex:indexPath.row];
    NSString *typeString = [dict objectForKey:@"text"];
    
    
    if (selectBlock) {
    
        selectBlock(typeString);
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
}

-(void)setBlock:(QunBaTypeSelectBlock)block
{
    selectBlock = block;
    
}

@end
