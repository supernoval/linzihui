//
//  ShengHuoQuanTVC.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/18.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "ShengHuoQuanTVC.h"
#import "SendWXViewController.h"
#import "ShengHuoModel.h"

static NSString *contentCell = @"ShenghuoQuanCell";


@interface ShengHuoQuanTVC ()
{
    NSInteger page;
    NSInteger limit;
    
    NSMutableArray *_dataSource;
    
    
    
}

@end

@implementation ShengHuoQuanTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"生活圈";
    
    page = 0;
    limit = 10;
    
    _dataSource = [[NSMutableArray alloc]init];
    
    
    self.tableView.backgroundColor = kBackgroundColor;
    
    
    [self addHeaderRefresh];
    
    [self addFooterRefresh];
    
    
    [self.tableView.header beginRefreshing];
    
 
}

-(void)headerRefresh
{
    page = 0;
    
    [self getData];
    
}

-(void)footerRefresh
{
    page ++;
    
    [self getData];
    
    
}



-(void)getData
{
    
    BmobQuery *query = [BmobQuery queryWithClassName:kShengHuoQuanTableName];
    
    [query includeKey:@"publisher"];
    
    [query setLimit:limit];
    
    query.skip = page *limit;
    [query orderByDescending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
       
        [self endHeaderRefresh];
        [self endFooterRefresh];
        
        
        if (!error) {
            
            if (array.count > 0) {
                
                if (page == 0) {
                    
                    [_dataSource removeAllObjects];
                    
                }
                for (int i = 0; i < array.count; i++) {
                    
                    BmobObject *ob = [array objectAtIndex:i];
                     NSDictionary *dataDict = [ob valueForKey:@"bmobDataDic"];
                    
                    ShengHuoModel *model = [[ShengHuoModel alloc]init];
                    
                    [model setValuesForKeysWithDictionary:dataDict];
                    
                    model.objectId = ob.objectId;
                    model.createdAt = ob.createdAt;
                    model.updatedAt = ob.updatedAt;
                    
                    
                    [_dataSource addObject:model];
                    
                    
                }
                
               
                [self.tableView reloadData];
                
                
                
                
            }
            
        }
        
        else
        {
            NSLog(@"获取生活圈数据失败:%@",error);
            
            
            
        }
        
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 5;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *blankView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 5)];
    
    blankView.backgroundColor = [UIColor clearColor];
    
    
    
    return blankView;
    
    
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
    
    ShengHuoModel *oneModel = [_dataSource objectAtIndex:indexPath.section];
    
    CGFloat photoViewHeight = 0;

    NSArray *imgs = oneModel.image_url;
    
    long imageCount = imgs.count;
    int perRowImageCount = ((imageCount == 4) ? 2 : 3);
    CGFloat perRowImageCountF = (CGFloat)perRowImageCount;
    int totalRowCount = ceil(imageCount / perRowImageCountF);
    
    photoViewHeight = 95 * totalRowCount;
    
    
    
    CGFloat textHeight = 0;
    
    
    NSString *text =oneModel.text;
    

    textHeight = [StringHeight heightWithText:text font:FONT_17 constrainedToWidth:ScreenWidth - 25];
    
    if (textHeight < 30)
    {
        
        textHeight = 30;
        
        
    }
    
    
    
    return 158 + photoViewHeight + textHeight;
    
 
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    ShenghuoQuanCell *cell = [tableView dequeueReusableCellWithIdentifier:contentCell];
    
    if (indexPath.section < _dataSource.count) {
        
       ShengHuoModel *oneModel = [_dataSource objectAtIndex:indexPath.section];
        
        BmobUser *user = oneModel.publisher;
        
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[user objectForKey:@"headImageURL"]]
                              placeholderImage:kDefaultHeadImage];
        
        
        cell.nickNameLabel.text = [user objectForKey:@"nick"];
        
        if (!cell.nickNameLabel.text) {
            
            cell.nickNameLabel.text = [user objectForKey:@"username"];
            
        }
        
        cell.photoView.photoItemArray = oneModel.image_url;
        
        cell.contentextLabel.text = oneModel.text;
        
        
        
        
        
        
        
    }
    
    
    
    
    return cell;
}


- (IBAction)publishAction:(id)sender {
    
    
    SendWXViewController *_sendVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SendWXViewController"];
    
    
    
    
    [self.navigationController pushViewController:_sendVC animated:YES];
    
    
    
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
