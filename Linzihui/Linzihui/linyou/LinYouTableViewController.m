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
    
    
}

#pragma mark - dataSource

- (void)reloadDataSource
{
    [self.dataSource removeAllObjects];
    [self.contactsSource removeAllObjects];
    
    NSArray *buddyList = [[EaseMob sharedInstance].chatManager buddyList];
    NSArray *blockList = [[EaseMob sharedInstance].chatManager blockedList];
    for (EMBuddy *buddy in buddyList) {
        if (![blockList containsObject:buddy.username]) {
            [self.contactsSource addObject:buddy];
        }
    }
    
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    NSString *loginUsername = [loginInfo objectForKey:kSDKUsername];
    if (loginUsername && loginUsername.length > 0) {
        EMBuddy *loginBuddy = [EMBuddy buddyWithUsername:loginUsername];
        [self.contactsSource addObject:loginBuddy];
    }
    
    [self.dataSource addObjectsFromArray:[self sortDataArray:self.contactsSource]];
    
    [self.tableView reloadData];
}


-(NSMutableArray*)addtopContents
{
    
    NSMutableArray *muArray = [[NSMutableArray alloc]init];
    
    NSArray *topContentArray = @[@{@"image":@"newfriends",@"title":@"新朋友"},@{@"image":@"groupchat",@"title":@"群聊"},@{@"image":@"follow",@"title":@"关注"}];

    [muArray addObjectsFromArray:topContentArray];
    
    
    return muArray;
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return _muDataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    NSMutableArray * existTitles = [NSMutableArray array];
//    //section数组为空的title过滤掉，不显示
//    for (int i = 0; i < [self.sectionTitles count]; i++) {
//        
//        NSArray *temDataArray = [self.dataSource objectAtIndex:i];
//        
//        if (temDataArray.count > 0) {
//            [existTitles addObject:[self.sectionTitles objectAtIndex:i]];
//        }
//    }
//    return existTitles;
//}

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
        
        
        NSDictionary *oneDict = [_muDataSource objectAtIndex:indexPath.section];
        
        titleLabel.text = [oneDict objectForKey:@"title"];
        
        imageView.image = [UIImage imageNamed:[oneDict objectForKey:@"image"]];
        
        
        
        
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
            
        }
            break;
            
        
        default:
        {
            
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
    for (EMBuddy *buddy in dataArray) {
        //getUserName是实现中文拼音检索的核心，见NameIndex类
        NSString *firstLetter = [ChineseToPinyin pinyinFromChineseString:buddy.username];
        NSInteger section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
        
        NSMutableArray *array = [sortedArray objectAtIndex:section];
        [array addObject:buddy];
    }
    
    //每个section内的数组排序
    for (int i = 0; i < [sortedArray count]; i++) {
        NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(EMBuddy *obj1, EMBuddy *obj2) {
            NSString *firstLetter1 = [ChineseToPinyin pinyinFromChineseString:obj1.username];
            firstLetter1 = [[firstLetter1 substringToIndex:1] uppercaseString];
            
            NSString *firstLetter2 = [ChineseToPinyin pinyinFromChineseString:obj2.username];
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
