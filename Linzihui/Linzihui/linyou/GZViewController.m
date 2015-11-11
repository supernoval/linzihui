//
//  GZViewController.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/12.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "GZViewController.h"

@interface GZViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataSource;
    
    NSInteger type;
    
    BmobObject *_follow;
    
    NSMutableArray *_myFollows;
    NSMutableArray *_followMes;
    
    
    
}
@end

@implementation GZViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    type = 0;
    
    self.title = @"关注";
    
    _dataSource = [[NSMutableArray alloc]init];
    _myFollows = [[NSMutableArray alloc]init];
    _followMes = [[NSMutableArray alloc]init];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self loadData];
    
}

-(void)loadData
{
    BmobUser *currentUser = [BmobUser getCurrentUser];
    
    BmobQuery *query = [BmobQuery queryWithClassName:@"Follow"];
    
    [query whereKey:@"userObjectId" equalTo:currentUser.objectId];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
       
        if (!error && array.count >0) {
            
            _follow = [array firstObject];
            
            NSArray *myFollows = [_follow objectForKey:@"myFollows"];
            
            NSMutableArray *muArray  = [[NSMutableArray alloc]init];
            
            for (int i = 0; i < myFollows.count; i ++) {
                
                NSString *obID = [myFollows objectAtIndex:i];
                
                BOOL content = NO;
                
                for (NSString *temObjID in muArray) {
                   
                    if ([temObjID isEqualToString:obID]) {
                        
                        content = YES;
                    }
                }
                
                if (!content) {
                    
                    [muArray addObject:obID];
                    
                }
                
            }
            
            
            
            //获取我的关注的人信息
            BmobQuery *querymyFollows = [BmobQuery queryForUser];
            
            [querymyFollows whereKey:@"objectId" containedIn:muArray];
            
            [querymyFollows findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
               
                if (!error && array.count > 0) {
                    
                    for (BmobObject *temOb in array) {
                        
                        UserModel *model = [[UserModel alloc]initwithBmobObject:temOb];
                        
                        [_myFollows addObject:model];
                        
                    }
                    
                    _dataSource = _myFollows;
                    
                    [self.tableView reloadData];
                    
                    
                }
                
            }];
            
            
            
        }
        
        
    }];
}

- (void)getFollowMes
{
    if (_follow) {
        
        NSArray *followMes = [_follow objectForKey:@"followMes"];
        
        BmobQuery *queryFollowMes = [BmobQuery queryForUser];
        

        NSMutableArray *muArray  = [[NSMutableArray alloc]init];
        
        for (int i = 0; i < followMes.count; i ++) {
            
            NSString *obID = [followMes objectAtIndex:i];
            
            BOOL content = NO;
            
            for (NSString *temObjID in muArray) {
                
                if ([temObjID isEqualToString:obID]) {
                    
                    content = YES;
                }
            }
            
            if (!content) {
                
                [muArray addObject:obID];
                
            }
            
        }
        
        [queryFollowMes findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
           
            if (!error) {
                
                for (BmobObject *ob in array) {
                    
                    UserModel *followMe = [[UserModel alloc]initwithBmobObject:ob];
                    
                    [_followMes addObject:followMe];
                    
                }
                
                _dataSource = _followMes;
                
                
                [self.tableView reloadData];
                
            }
        }];
        
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _dataSource.count;
    
   
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        UIImageView *headImageView = (UIImageView*)[cell viewWithTag:100];
        
        UILabel*label = (UILabel*)[cell viewWithTag:101];
        
        UserModel *user = [_dataSource objectAtIndex:indexPath.row];
        
        [headImageView sd_setImageWithURL:[NSURL URLWithString:user.headImageURL] placeholderImage:kDefaultHeadImage];
        
        label.text = user.nickName;
        
        if (!user.nickName) {
            
            label.text = user.username;
            
        }
        
        
    });
    
    return cell;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)switchAction:(id)sender {
    
    if (type == 0) {
        
        type = 1;
        
   
        
        if (_followMes.count > 0) {
            
            _dataSource = _followMes;
            
             [self.tableView reloadData];
            
        }
        else
        {
            [self getFollowMes];
            
        }
        
    }
    else
    {
        type = 0;
        
        _dataSource = _myFollows;
        
          [self.tableView reloadData];
        
        
    }
    
   
    
}
@end
