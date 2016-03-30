//
//  ErShouListTVC.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/3/30.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "ErShouListTVC.h"
#import "ErShouCell.h"
#import "PublishErShouVC.h"


@interface ErShouListTVC ()
{
    NSMutableArray *_dataSource;
    
    
}
@end

@implementation ErShouListTVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
   
    self.title = @"邻近二手";
    _dataSource = [[NSMutableArray alloc]init];
    
    UIBarButtonItem *publishButton = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(publish)];
    
    self.navigationItem.rightBarButtonItem = publishButton;
    
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    
    [self loadDataErShou];
    
    
    
}

-(void)publish
{
    PublishErShouVC *_publishErShou = [self.storyboard instantiateViewControllerWithIdentifier:@"PublishErShouVC"];
    
    _publishErShou.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:_publishErShou animated:YES];
    
    
}
-(void)loadDataErShou
{
    BmobQuery *query = [BmobQuery queryWithClassName:kErShou];
    
    
    [query orderByAscending:@"createdAt"];
    
    [query includeKey:@"publisher"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
       
        
        if (!error && array.count > 0) {
            
            
            for (int i = 0 ; i < array.count; i++) {
                
                BmobObject *Ob = [array objectAtIndex:i];
                
                NSDictionary *dic = [Ob valueForKey:kBmobDataDic];
                
                ErShouModel *model = [[ErShouModel alloc]init];
                
                [model setValuesForKeysWithDictionary:dic];
                
                BmobGeoPoint *location = [Ob objectForKey:@"location"];
                
                model.location = location;
                
                [_dataSource addObject:model];
                
                
            }
            
            
            [self.tableView reloadData];
            
            
            
        }
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ErShouModel *model = [_dataSource objectAtIndex:indexPath.section];
    
    
    CGFloat textHeight = [StringHeight heightWithText:model.des font:FONT_15 constrainedToWidth:ScreenWidth - 20];
    
    CGFloat photoViewHeight = 0;
    
    NSArray *imgs = model.photos;
    
    long imageCount = imgs.count;
    int perRowImageCount = ((imageCount == 4) ? 2 : 3);
    CGFloat perRowImageCountF = (CGFloat)perRowImageCount;
    int totalRowCount = ceil(imageCount / perRowImageCountF);
    
    photoViewHeight = 80 * totalRowCount;
    
    
    
    return 160 + textHeight + photoViewHeight;
    
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    ErShouCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"ErShouCell"];
    
     ErShouModel *model = [_dataSource objectAtIndex:indexPath.section];
    
    CGFloat textHeight = [StringHeight heightWithText:model.des font:FONT_15 constrainedToWidth:ScreenWidth - 20];
    
    CGFloat photoViewHeight = 0;
    
    NSArray *imgs = model.photos;
    
    long imageCount = imgs.count;
    int perRowImageCount = ((imageCount == 4) ? 2 : 3);
    CGFloat perRowImageCountF = (CGFloat)perRowImageCount;
    int totalRowCount = ceil(imageCount / perRowImageCountF);
    
    photoViewHeight = 80 * totalRowCount;
    
    
//    BmobObject *user = model.publisher;
    
    
    cell.contentLabelHeight.constant = textHeight;
    
    cell.photoViewHeight.constant = photoViewHeight;
    
    

    cell.contentLabel.text = model.des;
    
    cell.photoView.photoItemArray = model.photos;
    
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[model.publisher objectForKey:@"headImageURL"]] placeholderImage:kDefaultHeadImage];
    
    cell.nameLabel.text = [model.publisher objectForKey:@"nickName"];
    
    cell.timeLabel.text = [CommonMethods getYYYYMMddhhmmDateStr:model.createdAt];
    
    //等级
    [BmobHelper getOtherLevelWithUserName:[model.publisher  objectForKey:@"username"] result:^(NSString *levelStr) {
        
        cell.levelLabel.text =  [NSString stringWithFormat:@"等级:%@",levelStr];
        
    }];
    
    BmobGeoPoint *location = model.location;
    
    CGFloat latitude = [[location valueForKey:@"latitude"]floatValue];
    
    CGFloat longitude = [[location valueForKey:@"longitude"]floatValue];
    
    
    
    
    cell.distanceLabel.text = [CommonMethods distanceStringWithLatitude:latitude longitude:longitude];
    
    
    
    
    return cell;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
