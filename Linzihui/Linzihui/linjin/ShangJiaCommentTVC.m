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
    
  
    BmobQuery *query = [BmobQuery queryWithClassName:kShangJiaComment];
    
    [query whereKey:@"shangjia_username" equalTo:_model.username];
    
    [query includeKey:@"publisher"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
       
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
    return 65;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShangjiaCommentCell*_CommentCell = [tableView dequeueReusableCellWithIdentifier:@"ShangjiaCommentCell"];
    
    ShangJiaCommentModel *model =[_dataSource objectAtIndex:indexPath.section];
    
    
    _CommentCell.contentlabel.text = model.content;
    
    _CommentCell.nameLabel.text = [model.publisher objectForKey:@"nickName"];
    
    [_CommentCell.headImageView sd_setImageWithURL:[NSURL URLWithString:[model.publisher objectForKey:@"headImageURL"]] placeholderImage:kDefaultHeadImage];
    
    _CommentCell.timeLabel.text = [CommonMethods getYYYYMMddHHmmssDateStr:model.createdAt ];
    
    
    

    
    
    
    return _CommentCell;
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
