//
//  ShangJiaCommentTVC.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/5/2.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "ShangJiaCommentTVC.h"
#import "ShangJiaCommentModel.h"


@interface ShangJiaCommentTVC ()
{
    NSMutableArray *_dataSource;
    
}
@end

@implementation ShangJiaCommentTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"商家评论";
    
    _dataSource = [[NSMutableArray alloc]init];
    
    [self requestData];
    
    
    
}

-(void)requestData
{
    
    [MyProgressHUD showProgress];
    
    BmobQuery *query = [BmobQuery queryWithClassName:kShangJiaComment];
    
    [query whereKey:@"shangjia_username" equalTo:_model.username];
    
    [query includeKey:@"publisher"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
       
        [MyProgressHUD dismiss];
        
        if (array.count > 0) {
            
            
            for (int i = 0; i < array.count; i++) {
                
                BmobObject *ob = [array objectAtIndex:i];
                
                NSDictionary *dataDict = [ob valueForKey:kBmobDataDic];
                
                ShangJiaCommentModel *model = [[ShangJiaCommentModel alloc]init];
                
                [model setValuesForKeysWithDictionary:dataDict];
                
               
                
                model.createdAt = ob.createdAt;
                
                [_dataSource addObject:model];
                
                
            }
            
            
            [self.tableView reloadData];
            
        }
        else
        {
            NSLog(@"error:%@",error);
            
        }
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
        return _dataSource.count;
    
  
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

      return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        ShangJiaCommentModel *model =[_dataSource objectAtIndex:indexPath.section];
    
    CGFloat height = [StringHeight heightWithText:model.content font:FONT_15 constrainedToWidth:ScreenWidth-16];
    
    if (height < 21) {
        
        height = 21;
        
    }
    
    return 80 + height;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShangjiaCommentCell*_CommentCell = [tableView dequeueReusableCellWithIdentifier:@"ShangjiaCommentCell"];
    
    ShangJiaCommentModel *model =[_dataSource objectAtIndex:indexPath.section];
    
    _CommentCell.trail.constant = 8;
    
    _CommentCell.commentLabel.text = model.content;
    
    NSLog(@"contentviewY:%.2f",_CommentCell.commentLabel.frame.size.width);
    
    _CommentCell.nameLabel.text = [model.publisher objectForKey:@"nickName"];
    
    CGFloat height = [StringHeight heightWithText:model.content font:FONT_15 constrainedToWidth:ScreenWidth-16];
    
    if (height < 21) {
        
        height = 21;
        
    }
    _CommentCell.contentHeighConstants.constant = height;
    
    [_CommentCell.headImageView sd_setImageWithURL:[NSURL URLWithString:[model.publisher objectForKey:@"headImageURL"]] placeholderImage:kDefaultHeadImage];
    
    [BmobHelper getOtherLevelWithUserName:[model.publisher objectForKey:@"username"] result:^(NSString *levelStr) {
       
        _CommentCell.levelLabel.text = [NSString stringWithFormat:@"等级:%@",levelStr];
        
    }];
    _CommentCell.timeLabel.text = [CommonMethods getYYYYMMddHHmmssDateStr:model.createdAt ];
    
    _CommentCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    

    
    
    
    return _CommentCell;
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
