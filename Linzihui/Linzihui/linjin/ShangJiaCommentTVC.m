//
//  ShangJiaCommentTVC.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/5/2.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "ShangJiaCommentTVC.h"

@interface ShangJiaCommentTVC ()
{
    
}
@end

@implementation ShangJiaCommentTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"商家评论";
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _model.Comments.count;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShangjiaCommentCell*_CommentCell = [tableView dequeueReusableCellWithIdentifier:@"ShangjiaCommentCell"];
    
    
    
    return _CommentCell;
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
