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




static NSString *CellId  = @"CellId";

@interface LinYouTableViewController ()
{
    NSMutableArray *_muDataSource;
    
    
    NSMutableArray *_friendListArray;
    
    
}

@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableArray *contactsSource;
@property (strong, nonatomic) NSMutableArray *sectionTitles;
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
    
    //设置侧边索引背景颜色
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    
    
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
    }];
    
    
    

    
  
}


-(NSMutableArray*)addtopContents
{
    
    NSMutableArray *muArray = [[NSMutableArray alloc]init];
    
    NSArray *topContentArray = @[@{@"image":@"newfriends",@"title":@"新朋友"},@{@"image":@"groupchat",@"title":@"群聊"},@{@"image":@"follow",@"title":@"关注"}];

    [muArray addObjectsFromArray:topContentArray];
    
    
    return muArray;
    
}

#pragma mark   UITableViewDataSource

//设置 sectionheaderView 及邮编字母栏
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
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
    
    return _muDataSource.count + _dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        
        UIImageView *imageView = (UIImageView*)[cell viewWithTag:100];
        
        UILabel*titleLabel = (UILabel*)[cell viewWithTag:101];
        
        if (indexPath.section < 3) {
            
            NSDictionary *oneDict = [_muDataSource objectAtIndex:indexPath.section];
            
            titleLabel.text = [oneDict objectForKey:@"title"];
            
            imageView.image = [UIImage imageNamed:[oneDict objectForKey:@"image"]];
        }
        else
        {
            if (_dataSource.count > indexPath.section -3) {
                
                NSArray *oneArray = [_dataSource objectAtIndex:indexPath.section - 3];
                
                UserModel *oneModel = [oneArray objectAtIndex:indexPath.row];
                
                if (oneModel.nickName) {
                    
                    titleLabel.text = oneModel.nickName;
                }
                else
                {
                    titleLabel.text = oneModel.username;
                    
                }
                
                
                [imageView sd_setImageWithURL:[NSURL URLWithString:oneModel.headImageURL] placeholderImage:kDefaultHeadImage];
            }
          
            
            
        }
   
        
        
        
        
    });
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    switch (indexPath.section) {
        case 0:
        {
            AddNewFriendsTVC *_addNewFriendsTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddNewFriendsTVC"];
            
            _addNewFriendsTVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:_addNewFriendsTVC animated:YES];
            
            
            
        }
            break;
        case 1:
        {
            
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
        NSString *firstLetter = [ChineseToPinyin pinyinFromChineseString:oneModel.nickName];
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
            NSString *firstLetter1 = [ChineseToPinyin pinyinFromChineseString:obj1.nickName];
            if (!firstLetter1) {
                
                firstLetter1 = [ChineseToPinyin pinyinFromChineseString:obj1.username];
            }
            firstLetter1 = [[firstLetter1 substringToIndex:1] uppercaseString];
            
            NSString *firstLetter2 = [ChineseToPinyin pinyinFromChineseString:obj2.nickName];
            
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}



@end
