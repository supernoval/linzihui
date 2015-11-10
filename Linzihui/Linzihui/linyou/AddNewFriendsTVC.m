//
//  AddNewFriendsTVC.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/3.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "AddNewFriendsTVC.h"
#import "InvitationManager.h"


static NSString * CellId = @"CellId";
static NSString * RequestCell = @"RequestCell";

@interface AddNewFriendsTVC ()<UISearchDisplayDelegate,UISearchBarDelegate>
@property (nonatomic,strong) UISearchDisplayController *searchController;
@property ( nonatomic) UISearchBar *searchbar;
@property (nonatomic,strong) NSMutableArray *searResults;
@property (nonatomic,strong) NSMutableArray *dataSource;



@end

@implementation AddNewFriendsTVC

- (void)viewDidLoad {
    [super viewDidLoad];
  
  
     _searResults = [[NSMutableArray alloc]init];
    _dataSource = [[NSMutableArray alloc]init];
    
    
    [self searchbar];
    
    [self searchController];
    
    self.tableView.tableHeaderView = _searchbar;
    
    [self getLocateInviteData];
    
}


//添加本地的好友请求数据
-(void)getLocateInviteData
{
    [_dataSource removeAllObjects];
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    NSString *loginName = [loginInfo objectForKey:kSDKUsername];
    if(loginName && [loginName length] > 0)
    {
        
        NSArray * applyArray = [[InvitationManager sharedInstance] applyEmtitiesWithloginUser:loginName];
        [_dataSource addObjectsFromArray:applyArray];
        
        [self.tableView reloadData];
    }
}
#pragma mark  - property

-(UISearchBar*)searchbar
{
    if (!_searchbar) {
        
        
        _searchbar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
        _searchbar.delegate = self;
        
        
        
    }
    
    return _searchbar;
    
}
-(UISearchDisplayController*)searchController
{
    if (!_searchController) {
        
        _searchController = [[UISearchDisplayController alloc]initWithSearchBar:_searchbar contentsController:self];
        
        _searchController.delegate = self;
        _searchController.searchResultsDataSource = self;
        _searchController.searchResultsDelegate = self;
        
        _searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
    }
    
    return _searchController;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _searchController.searchResultsTableView) {
        
        return 1;
        
    }
    return 2;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == _searchController.searchResultsTableView) {
        
        return _searResults.count;
        
    }
   
    if (section == 0) {
        
        return 3;
        
    }
    
    return _dataSource.count;
    
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellId];
    

    
    
        
        if (tableView ==_searchController.searchResultsTableView) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIImageView *imageView = (UIImageView*)[cell viewWithTag:100];
                UILabel *titleLabel = (UILabel*)[cell viewWithTag:101];
                UIButton *button = (UIButton*)[cell viewWithTag:102];
            
            
            button.hidden = NO;
            cell.contentView.tag = indexPath.row;
            [button addTarget:self action:@selector(follow:) forControlEvents:UIControlEventTouchUpInside];
           
            button.clipsToBounds = YES;
            button.layer.cornerRadius = 5.0;
            
            UserModel *model = [_searResults objectAtIndex:indexPath.row];
            
            if (model.followEach) {
                
                [button setTitle:@"添加好友" forState:UIControlStateNormal];
                
            }else
            {
                [button setTitle:@"关注" forState:UIControlStateNormal];
            }
            
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.headImageURL] placeholderImage:kDefaultHeadImage];
            
            if (model.nickName) {
                
                titleLabel.text = model.nickName;
            }else
            {
                titleLabel.text = model.username;
                
            }
            
        
            cell.accessoryType = UITableViewCellAccessoryNone;
                
             });
            
             return cell;
           
            
         }
        else
        {
      
            
                 
                 
            
                
            if (indexPath.section == 0) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
            
                UIImageView *imageView = (UIImageView*)[cell viewWithTag:100];
                UILabel *titleLabel = (UILabel*)[cell viewWithTag:101];
                UIButton *button = (UIButton*)[cell viewWithTag:102];
                
                button.hidden = YES;
                
                
                NSString *imageName = nil;
                NSString  *title    = nil;
                
                switch (indexPath.row) {
                    case 0:
                    {
                        imageName  = @"tongxunlu";
                        title =  @"通讯录";
                    }
                        break;
                    case 1:
                    {
                        imageName  = @"qqIcon";
                        title =  @"QQ";
                    }
                        break;
                    case 2:
                    {
                        imageName  = @"weichaIcon";
                        title =  @"微信";
                    }
                        break;
                        
                        
                    default:
                    {
                        
                        
                    }
                        break;
                }
                
                imageView.image = [UIImage imageNamed:imageName];
                titleLabel.text = title;
                
                 cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                });
                
                
                return cell;
                
                
             }
            else  //好友请求历史
            {
            
            UITableViewCell * _requestCell = [tableView dequeueReusableCellWithIdentifier:RequestCell];
            
            _requestCell.contentView.tag = indexPath.row;
                
            dispatch_async(dispatch_get_main_queue(), ^{
            
            UIImageView *headImageView = (UIImageView*)[_requestCell viewWithTag:100];
            UILabel *titleLabel = (UILabel*)[_requestCell viewWithTag:101];
            UILabel *contentLabel = (UILabel*)[_requestCell viewWithTag:102];
            UIButton *acceptButton = (UIButton*)[_requestCell viewWithTag:103];
            
            [acceptButton addTarget:self action:@selector(acceptApply:) forControlEvents:UIControlEventTouchUpInside];
            
            
            ApplyEntity *entity = [_dataSource objectAtIndex:indexPath.row ];
            if (entity) {
                
                ApplyStyle applyStyle = [entity.style intValue];
                if (applyStyle == ApplyStyleGroupInvitation) {
                    
                    
                    
                }
                else if (applyStyle == ApplyStyleJoinGroup)
                {
                    
                }
                else if(applyStyle == ApplyStyleFriend){
                    
                    [headImageView sd_setImageWithURL:[NSURL URLWithString:entity.avatar] placeholderImage:kDefaultHeadImage];
                    
                    if (entity.applicantNick) {
                        
                        titleLabel.text = entity.applicantNick;
                    }
                    else
                    {
                        titleLabel.text = entity.applicantUsername;
                        
                    }
                    
                    if (entity.reason) {
                        
                        contentLabel.text = entity.reason;
                    }
                    else
                    {
                        contentLabel.text = @"请求加你为好友";
                    }
                    
                    
                    
                }
                
                
                
                
            }
                
                
            });
                
            
            return _requestCell;
                
                
            }
            
            
         }
    
      
    
   
    
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - UISearchBarDelegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text.length > 0) {
        
         [self getUserWithUserName:searchBar.text];
    }
   
    
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
    [[UIApplication sharedApplication ] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    [_searchController setActive:YES animated:YES];
    
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
     _searchbar.delegate = self;
    
}

#pragma mark - UISearchDisplayDelegate 
-(void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{

    
    [_searResults removeAllObjects];
    
    
    //要加这句 不然没法再次搜 我日啊，搞了好久
    [_searchController.searchBar resignFirstResponder];
    
    
    [[UIApplication sharedApplication ] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    
    [_searchController setActive: NO animated:YES];
    
    
}

-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{

    
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView
{
  
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView
{

    
}

#pragma mark - 关注或者加好友
-(void)follow:(UIButton*)sender
{
    
    UserModel *model = [_searResults objectAtIndex:[sender superview].tag];
    
    //如果互相关注 发送加好友请求
    if (model.followEach) {
      
        [EMHelper sendFriendRequestWithBuddyName:model.username Mesage:@"请求加为好友"];
        
        
    }
    else
    {
    [BmobHelper addFollowWithFollowedUserModel:model result:^(BOOL isSuccess) {
       
        if (isSuccess) {
            
            NSLog(@"添加关注成功");
            
        }
        else
        {
             NSLog(@"添加关注失败");
        }
    }];
    }
    
    
}


#pragma mark - 搜索用户
-(void)getUserWithUserName:(NSString*)username
{
    
    [BmobHelper searchUserWithUsername:username searchResult:^(NSArray * array) {
       
        if (array.count > 0) {
            
            //检查是否互相关注
            [BmobHelper checkFollowEachOtherWithItemArray:array searchResult:^(NSArray *results) {
                
                
                [_searResults addObjectsFromArray:results];
                
                [_searchController.searchResultsTableView reloadData];
                
            }];
            
            
        }
        
    }];
}


#pragma mark - 接受好友请求
-(void)acceptApply:(UIButton*)sender
{
    ApplyEntity *entity = [_dataSource objectAtIndex:[sender superview].tag ];
    
    EMError *error ;
    
    if ([[EMHelper getHelper] accepBuddyRequestWithUserName:entity.applicantUsername error:&error])
    {
        
        [self.tableView reloadData];
        
    }
    
   
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
