//
//  LinYouTableViewController.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/3.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "LinYouTableViewController.h"
#import "EaseMob.h"
#import "ChineseToPinyin.h"
#import "AddNewFriendsTVC.h"
#import "ChatViewController.h"
#import "GZViewController.h"
#import "MygroupListTVC.h"
#import "TongXunLuTVC.h"
#import "PersonInfoViewController.h"






static NSString *CellId  = @"CellId";

@interface LinYouTableViewController ()<UISearchDisplayDelegate,UISearchBarDelegate>
{
    NSMutableArray *_muDataSource;
    
    
    NSMutableArray *_friendListArray;
    
    NSMutableArray *_searchResults;
    
    
}

@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableArray *contactsSource;
@property (strong, nonatomic) NSMutableArray *sectionTitles;


@property (nonatomic) UISearchBar *mySearchBar;
@property (nonatomic) UISearchDisplayController *myDisplayerController;

@end

@implementation LinYouTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    self.headView.frame = CGRectMake(0, 0, ScreenWidth, 44);
    
    _muDataSource = [self addtopContents];
    _dataSource = [[NSMutableArray alloc]init];
    _contactsSource = [[NSMutableArray alloc]init];
    _sectionTitles = [[NSMutableArray alloc]init];
    
     _friendListArray = [[NSMutableArray alloc]init];
    
     _searchResults = [[NSMutableArray alloc]init];
    
    //设置侧边索引背景颜色
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    
    self.tableView.tableHeaderView = self.myDisplayerController.searchBar;
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadDataSource];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

-(UISearchBar*)mySearchBar
{
    
    
    if (!_mySearchBar) {
        
        _mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
        
        _mySearchBar.delegate = self;
        
        
    }
    
    return _mySearchBar;
    
    
}

-(UISearchDisplayController*)myDisplayerController
{
    
    if (!_myDisplayerController) {
        
        _myDisplayerController = [[UISearchDisplayController alloc]initWithSearchBar:self.mySearchBar contentsController:self];
        
        _myDisplayerController.searchResultsDataSource = self;
        _myDisplayerController.searchResultsDelegate = self;
        
        
    }
    
    return _myDisplayerController;
    
}

#pragma mark - dataSource

- (void)reloadDataSource
{
    [self.dataSource removeAllObjects];
    [self.contactsSource removeAllObjects];
    
    
    [BmobHelper getBmobBuddyUsers:^(NSArray * array) {
        
        if (array) {
            
            //将数据排序后加入到 datasource
            [self.dataSource addObjectsFromArray:[self sortDataArray:array]];
            
            [self.tableView reloadData];
            
        }
        else
        {
             [self.tableView reloadData];
        }
    }];
    
    
    

    
  
}


-(NSMutableArray*)addtopContents
{
    
    NSMutableArray *muArray = [[NSMutableArray alloc]init];
    
    NSArray *topContentArray = @[@{@"image":@"newfriends",@"title":@"通讯录"},@{@"image":@"groupchat",@"title":@"群聊"},@{@"image":@"follow",@"title":@"关注"}];

    [muArray addObjectsFromArray:topContentArray];
    
    
    return muArray;
    
}

#pragma mark   UITableViewDataSource

//设置 sectionheaderView 及邮编字母栏
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == _myDisplayerController.searchResultsTableView) {
        
        return nil;
        
    }
    NSMutableArray * existTitles = [NSMutableArray array];
    //section数组为空的title过滤掉，不显示
    for (int i = 0; i < [self.sectionTitles count]; i++) {
        
        NSArray *array = [_dataSource objectAtIndex:i];
        
        if ([array count] > 0) {
            
            [existTitles addObject:[self.sectionTitles objectAtIndex:i]];
        }
    }
    return existTitles;
}

//section header 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _myDisplayerController.searchResultsTableView) {
        
        return 0;
        
    }
    if (section < 3) {
        
        return 0;
    }
    else
    {
        if (_dataSource.count > section -3) {
            
            NSArray *array = [_dataSource objectAtIndex:section - 3];
            
            if (array.count > 0) {
                
                return 25;
            }
            else
            {
                return 0;
                
            }
        }
        return 0;
        
     
        
    }
    
}

//返回每个section 上面的 A,B,C....
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if (tableView == _myDisplayerController.searchResultsTableView) {
        
        return nil;
        
    }
    if (section < 3) {
        return nil;
    }
    else
    {
        if (_sectionTitles.count > section -3) {
            
              return [_sectionTitles objectAtIndex:section - 3];
        }
      
        return nil;
        
        
    }
}


//有几个section
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _myDisplayerController.searchResultsTableView) {
        
        return 1;
        
    }
    
    return _muDataSource.count + _dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == _myDisplayerController.searchResultsTableView) {
        
        return _searchResults.count;
        
    }
    
    if (section < 3) {
        
        return 1;
    }
    else
    {
        NSArray *array = [_dataSource objectAtIndex:section -3];
        
        return array.count;
        
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellId];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        
        UIImageView *imageView = (UIImageView*)[cell viewWithTag:100];
        
        UILabel*titleLabel = (UILabel*)[cell viewWithTag:101];
        
        
        if (tableView == _myDisplayerController.searchResultsTableView || indexPath.section > 2) {
            
            
              NSArray *oneArray;
            UserModel *oneModel;
            
            
            if (tableView == _myDisplayerController.searchResultsTableView) {
                
                 oneModel = [_searchResults objectAtIndex:indexPath.row];
                
            }
            else
            {
                if (_dataSource.count > indexPath.section -3) {
                    
                    oneArray = [_dataSource objectAtIndex:indexPath.section - 3];
                    
                    oneModel  = [oneArray objectAtIndex:indexPath.row];
                    
                    
                }
            }
     
          
            
            
            
            if (oneModel.beizhu) {
                
                titleLabel.text = oneModel.beizhu;
                
            }
             else  if (oneModel.nickName) {
                    
                    titleLabel.text = oneModel.nickName;
               
             }
            
             else
                {
                    titleLabel.text = oneModel.username;
                    
                }
                
                
                [imageView sd_setImageWithURL:[NSURL URLWithString:oneModel.headImageURL] placeholderImage:kDefaultHeadImage];
            
        }
        else {
            
            NSDictionary *oneDict = [_muDataSource objectAtIndex:indexPath.section];
            
            titleLabel.text = [oneDict objectForKey:@"title"];
            
            imageView.image = [UIImage imageNamed:[oneDict objectForKey:@"image"]];
        }
       
   
        
        
        
        
    });
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == _myDisplayerController.searchResultsTableView) {
        
        
        
        UserModel *model = [_searchResults objectAtIndex:indexPath.row];
        
        ChatViewController *_chat = [[ChatViewController alloc]initWithChatter:model.username isGroup:NO];
        
        if (model.nickName) {
            
            _chat.title = model.nickName;
        }
        else
        {
            _chat.title = model.username;
        }
        
        _chat.hidesBottomBarWhenPushed = YES;
        _chat.userModel = model;
        
        [self.navigationController pushViewController:_chat animated:YES];
      
        
        [_myDisplayerController setActive:NO animated:NO];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        
        return;
        
    }
    switch (indexPath.section) {
        case 0:
        {
            TongXunLuTVC *_tonxunLuTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TongXunLuTVC"];
            
            _tonxunLuTVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:_tonxunLuTVC animated:YES];
            
        
            
            
            
        }
            break;
        case 1:  //群聊
        {
            MygroupListTVC *_groupListTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MygroupListTVC"];
            
            _groupListTVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:_groupListTVC animated:YES];
            
            
        }
            break;
        case 2:
        {
            GZViewController *_gzVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GZViewController"];
            
            _gzVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:_gzVC animated:YES];
            
        }
            break;
            
        
        default:  //点击好友 跳到聊天
        {
            NSArray *Array = [_dataSource objectAtIndex:indexPath.section -3];
            
            UserModel *model = [Array objectAtIndex:indexPath.row];
            
            
            PersonInfoViewController *_personInfoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PersonInfoViewController"];
            
            _personInfoVC.username = model.username;
            
            _personInfoVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:_personInfoVC animated:YES];
            
            
//            ChatViewController *_chat = [[ChatViewController alloc]initWithChatter:model.username isGroup:NO];
//            
//            if (model.nickName) {
//                
//                _chat.title = model.nickName;
//            }
//            else
//            {
//                _chat.title = model.username;
//            }
//            
//            _chat.hidesBottomBarWhenPushed = YES;
//            _chat.userModel = model;
//            
//            [self.navigationController pushViewController:_chat animated:YES];
            
        }
            break;
    }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



#pragma mark - private  排序

- (NSMutableArray *)sortDataArray:(NSArray *)dataArray
{
    //建立索引的核心
    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
    
    [self.sectionTitles removeAllObjects];
    [self.sectionTitles addObjectsFromArray:[indexCollation sectionTitles]];
    
    //返回27，是a－z和＃
    NSInteger highSection = [self.sectionTitles count];
    //tableView 会被分成27个section
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i <= highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sortedArray addObject:sectionArray];
    }
    
    //名字分section
    for (UserModel *oneModel in dataArray) {
        //getUserName是实现中文拼音检索的核心，见NameIndex类
        NSString *firstLetter = [ChineseToPinyin pinyinFromChineseString:oneModel.beizhu];
        if (!firstLetter) {
            
            firstLetter = [ChineseToPinyin pinyinFromChineseString:oneModel.nickName];
            
        }
        
        if (!firstLetter) {
            
            firstLetter = [ChineseToPinyin pinyinFromChineseString:oneModel.username];
            
        }
        NSInteger section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
        
        NSMutableArray *array = [sortedArray objectAtIndex:section];
        [array addObject:oneModel];
    }
    
    //每个section内的数组排序
    for (int i = 0; i < [sortedArray count]; i++) {
        NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(UserModel *obj1, UserModel *obj2) {
            NSString *firstLetter1 = [ChineseToPinyin pinyinFromChineseString:obj1.beizhu];
            if (!firstLetter1) {
                
                firstLetter1 = [ChineseToPinyin pinyinFromChineseString:obj1.nickName];
            }
            
            if (!firstLetter1) {
                
                firstLetter1 = [ChineseToPinyin pinyinFromChineseString:obj1.username];
            }
            firstLetter1 = [[firstLetter1 substringToIndex:1] uppercaseString];
            
            NSString *firstLetter2 = [ChineseToPinyin pinyinFromChineseString:obj2.beizhu];
            
            if (!firstLetter2) {
                firstLetter2 = [ChineseToPinyin pinyinFromChineseString:obj2.nickName];
            }
            
            if (!firstLetter2) {
                firstLetter2 = [ChineseToPinyin pinyinFromChineseString:obj2.username];
            }
            
            firstLetter2 = [[firstLetter2 substringToIndex:1] uppercaseString];
            
            return [firstLetter1 caseInsensitiveCompare:firstLetter2];
        }];
        
        
        [sortedArray replaceObjectAtIndex:i withObject:[NSMutableArray arrayWithArray:array]];
    }
    
    return sortedArray;
}

#pragma mark - UISearchBarDelegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    if (searchBar.text.length > 0) {
        
        [self matchSearch:searchBar.text];
        
    }
    
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
}


#pragma mark - UISearchDisplayContorllerDelegate
-(void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView
{
    
    [controller setActive:NO animated:YES];
    
}

-(void)matchSearch:(NSString*)search
{

    
    [_searchResults removeAllObjects];
    
    for (int i = 0 ; i < _dataSource.count; i ++) {
        
        NSArray *array = [_dataSource objectAtIndex:i];
        
        if (i > 1) {
            
            for (UserModel *oneModel in array) {
                
                NSString *nickName = oneModel.beizhu;
                
                if (!nickName) {
                    
                    nickName =oneModel.nickName;
                }
                
                if (!nickName) {
                    
                    nickName =oneModel.username;
                }
                
                NSRange range = [nickName rangeOfString:search];
                
                if (range.length > 0) {
                    
                    [_searchResults addObject:oneModel];
                    
                }
                
            }
        }
 
    }
    
    
    if (_searchResults.count > 0) {
        
        [_myDisplayerController.searchResultsTableView reloadData];
        
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}



@end
