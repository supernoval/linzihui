//
//  ChatSettingTVC.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/15.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "ChatSettingTVC.h"

@interface ChatSettingTVC ()
{
    
    NSArray *_titles;
    
}
@end

@implementation ChatSettingTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"聊天信息";
    
    
    self.footerView.frame = CGRectMake(0, 0, ScreenWidth, 100);
    
    
    _titles = @[@"群组成员",@"邀请好友",@"群聊名称",@"群二维码"];
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 44;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    
    
    return _titles.count;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellId"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        UIImageView *imageView = (UIImageView*)[cell viewWithTag:100];
        
        UILabel *titleLabel = (UILabel*)[cell viewWithTag:101];
        
        
        NSString *title = [_titles objectAtIndex:indexPath.section];
        
        titleLabel.text = title;
        
        
        imageView.image = [UIImage imageNamed:@"erweima"];
        
        if (indexPath.section == 3) {
            
            imageView.hidden = NO;
            
         
            
            
            
        }
        else
        {
            imageView.hidden = YES;
            
        }
        
    });
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
