//
//  QunBaTableViewController.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/6/1.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "QunBaTableViewController.h"
#import "QunBaTableViewCell.h"
#import "PulishTieZiTVC.h"
#import "TieZiModel.h"
#import "TieZiDetailViewController.h"
#import "GroupMemberTVC.h"



@interface QunBaTableViewController ()
{
    NSMutableArray *_muTableViewArray;
    
    NSInteger index;
    NSInteger pagesize;
    
    
    
}

@end

@implementation QunBaTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    
    self.title = [NSString stringWithFormat:@"%@群吧",_groupname];
    
    self.headerView.frame = CGRectMake(0, 0, ScreenWidth, 80);
    
    _muTableViewArray = [[NSMutableArray alloc]init];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithTitle:@"发帖" style:UIBarButtonItemStylePlain target:self action:@selector(publish)];
    
    self.navigationItem.rightBarButtonItem = barButton;
    
    
    if (![self.owner isEqualToString:[BmobUser getCurrentUser].username]) {
        
        [self.segment removeSegmentAtIndex:2 animated:NO];
        
        
        
    }
    
    index = 0;
    
    pagesize = 15;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    [self addHeaderRefresh];
    [self addFooterRefresh];
    

    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    [self.tableView.header beginRefreshing];
    
    
}

-(void)headerRefresh
{
    index = 0;
    [self loadData];
    
}

-(void)footerRefresh
{
    index ++;
    [self loadData];
    
}


-(void)loadData
{
    BmobQuery *query = [BmobQuery queryWithClassName:kTieZi];
    
    [query whereKey:@"groupId" equalTo:_groupId];
    
    [query includeKey:@"QunBa,publisher"];
    
    [query orderByDescending:@"created_at"];
    
    query.skip = index*pagesize;
    query.limit = pagesize;
    
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
       
        [self endFooterRefresh];
        [self endHeaderRefresh];
        
        if (index == 0) {
            
            [_muTableViewArray removeAllObjects];
            
        }
        
        if (array.count > 0) {
            
            for (int i = 0; i < array.count; i++) {
                
                BmobObject *OB = [array objectAtIndex:i];
                
                TieZiModel *model = [[TieZiModel alloc]init];
                
                [model setValuesForKeysWithDictionary:[OB valueForKey:kBmobDataDic]];
                
                model.createdAt = OB.createdAt;
                
//                CGFloat latitude = [OB objectForKey:@""]
                model.location = [OB objectForKey:@"location"];
                
                [_muTableViewArray addObject:model];
                
                
            }
            
        }
        
        [self.tableView reloadData];
        
        
    }];
    
    
}
-(void)publish
{
    PulishTieZiTVC  *_publishTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PublishTieZiTVC"];
    
    _publishTVC.groupId = _groupId;
    
    [self.navigationController pushViewController:_publishTVC animated:YES];
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    

    
    return _muTableViewArray.count;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QunBaTableViewCell *cell = (QunBaTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"QunbaCell"];
    
    if (indexPath.row < _muTableViewArray.count) {
        
        TieZiModel  *model = [_muTableViewArray objectAtIndex:indexPath.row];
        
        cell.titleLabel.text = model.title;
        
        [cell.typeLabel setTitle:model.type forState:UIControlStateNormal];
        
        if (model.type.length == 0) {
            
            cell.typeLabel.enabled = NO;
            
        }
        
        cell.nameLabel.text = [model.publisher objectForKey:@"nickName"];
        
        cell.timeLabel.text = [CommonMethods getYYYYMMddFromDefaultDateStr:model.createdAt];
        
        cell.replayNumLabel.text = [NSString stringWithFormat:@"%ld",(long)model.replay.count];
        
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TieZiModel *temmodel = [_muTableViewArray objectAtIndex:indexPath.row];
    
    
    TieZiDetailViewController *tieziVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TieZiDetailViewController"];
    
    tieziVC.model = temmodel;
    
    [self.navigationController pushViewController:tieziVC animated:YES];
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)valueChange:(id)sender {
    
    switch (_segment.selectedSegmentIndex) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
            EMGroup *group = [[EaseMob sharedInstance].chatManager fetchGroupInfo:_groupId error:nil];
            
            GroupMemberTVC *_groupMember = [[GroupMemberTVC alloc]initWithStyle:UITableViewStylePlain];
            
            _groupMember.group = group;
            _groupMember.isFromQunBa = YES;
            
            
            [self.navigationController pushViewController:_groupMember animated:YES];
            
            
        }
            break;
            
            
        default:
            break;
    }
}
@end
