//
//  AddNewFriendsTVC.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/3.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "AddNewFriendsTVC.h"


static NSString * CellId = @"CellId";


@interface AddNewFriendsTVC ()<UISearchDisplayDelegate,UISearchBarDelegate>
@property (nonatomic,strong) UISearchDisplayController *searchController;
@property ( nonatomic) UISearchBar *searchbar;
@property (nonatomic,strong) NSMutableArray *searResults;


@end

@implementation AddNewFriendsTVC

- (void)viewDidLoad {
    [super viewDidLoad];
  
  
     _searResults = [[NSMutableArray alloc]init];
    
    
    [self searchbar];
    
    [self searchController];
    
    self.tableView.tableHeaderView = _searchbar;
    
    
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
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == _searchController.searchResultsTableView) {
        
        return _searResults.count;
        
    }
    return 3;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellId];
    
    dispatch_async(dispatch_get_main_queue(), ^{
      
        
        UIImageView *imageView = (UIImageView*)[cell viewWithTag:100];
        UILabel *titleLabel = (UILabel*)[cell viewWithTag:101];
        UIButton *button = (UIButton*)[cell viewWithTag:102];
        
        
        if (tableView ==_searchController.searchResultsTableView) {
            
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
            
            
            
            
            
        }
        else
        {
            
            
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
                break;
        }
        
        imageView.image = [UIImage imageNamed:imageName];
        titleLabel.text = title;
        
            
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            
        }
        
    });
    
    return cell;
    
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
