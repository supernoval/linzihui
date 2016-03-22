//
//  ShowDetailViewController.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/1/15.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "ShowDetailViewController.h"


@interface ShowDetailViewController ()

@end

@implementation ShowDetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    

    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *string = nil;
    
    switch (indexPath.section) {
        case 0:
        {
            
            string = _huodong.content;
            
            
        }
            break;
        case 1:
        {
               string = _huodong.TeDian;
        }
            break;
        case 2:
        {
               string = _huodong.LiuCheng;
        }
            break;
        case 3:
        {
               string = _huodong.ZhuYiShiXiang;
        }
            
            break;
            
        default:
        {
            string = @"";
            
        }
            break;
    }
    
    CGFloat heigt = [StringHeight heightWithText:string font:FONT_15 constrainedToWidth:ScreenWidth - 100];
    
    if (heigt < 44) {
        
        return 44;
    }
    return heigt + 10;
    
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HuoDongCell"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        
        UILabel *titleLabel = (UILabel*)[cell viewWithTag:100];
        
        UILabel *contentLabel = (UILabel*)[cell viewWithTag:101];
        
        NSString *title = nil;
        NSString *_content = nil;
        
        switch (indexPath.section) {
            case 0:
            {
                title = @"活动详情:";
                
                _content = _huodong.content;
            }
                break;
            case 1:
            {
                title = @"活动特点:";
                
                _content = _huodong.TeDian;
            }
                break;
            case 2:
            {
                title = @"活动流程:";
                
                _content = _huodong.LiuCheng;
            }
                break;
            case 3:
            {
                title = @"注意事项:";
                
                _content = _huodong.ZhuYiShiXiang;
                
                
            }
                break;
                
                
            default:
                break;
        }
        
        titleLabel.text = title;
        
        contentLabel.text = _content;
        
        
        
    });
    
    
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
