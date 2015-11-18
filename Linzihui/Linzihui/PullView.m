//
//  PullView.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/14.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "PullView.h"

@implementation PullView

-(id)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        self.backgroundColor = kNavigationBarColor;
        
        self.frame = frame;
        
        _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 150, 225) style:UITableViewStylePlain];
        
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _listTableView.dataSource = self;
        
        _listTableView.delegate = self;
        _listTableView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:_listTableView];
        
        
       
        
        
        
    }
    
    return self;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    
    blackView.backgroundColor =[UIColor whiteColor];
    
    
    return blackView;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(10, 6, 30, 30)];
        imageview.tag = 100;
        [cell.contentView addSubview:imageview];
        
        UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 6, 100, 30)];
        contentLabel.textColor = [UIColor whiteColor];
        contentLabel.textAlignment = NSTextAlignmentLeft;
        contentLabel.font = FONT_15;
        
        contentLabel.tag = 101;
        
        [cell.contentView addSubview:contentLabel];
        
        cell.backgroundColor = [UIColor clearColor];
        
        
    }
    
  
    UIImageView *imageView = (UIImageView*)[cell viewWithTag:100];
    
    UILabel *label = (UILabel*)[cell viewWithTag:101];
    
    NSString *title = nil;
    NSString *imageName = nil;
    
    switch (indexPath.section) {
        case 0:
        {
            title = @"发起群聊";
            imageName = @"buble";
            
        }
            break;
        case 1:
        {
            title = @"添加朋友";
            imageName = @"addpeople";
        }
            break;
        case 2:
        {
            title = @"扫一扫";
            imageName = @"scan";
        }
            break;
        case 3:
        {
            title = @"摇一摇";
            imageName = @"shake";
        }
            break;
        case 4:
        {
            title = @"意见反馈";
            imageName = @"return";
        }
            break;
        case 5:
        {
            
        }
            break;
            
        default:
            break;
    }
    
    
    label.text = title;
    imageView.image = [UIImage imageNamed:imageName];
    
    
    
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.delegate respondsToSelector:@selector(didSelectedIndex:)]) {
        
        [self.delegate didSelectedIndex:indexPath.section];
        
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self removeFromSuperview];
    
}


@end
