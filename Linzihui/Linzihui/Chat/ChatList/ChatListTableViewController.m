//
//  ChatListTableViewController.m
//  Taling
//
//  Created by Haikun Zhu on 15/10/14.
//  Copyright © 2015年 ZhuHaikun. All rights reserved.
//

#import "ChatListTableViewController.h"
#import "ChatListCellTableViewCell.h"
#import "IChatManagerDelegate.h"
#import "NSDate+Category.h"
#import "ConvertToCommonEmoticonsHelper.h"
#import "ChatViewController.h"
#import "LoginViewController.h"
#import "MyConversation.h"
#import "ShengHuoQuanTVC.h"
#import "GroupChatListTVC.h"
#import "HuoDongMessageTVC.h"
#import "HuoDongDetailTVC.h"
#import "PersonInfoViewController.h"






static NSString *cellId = @"ChatListCell";
static NSString *headCellID = @"CellID";

@interface ChatListTableViewController ()<EMChatManagerDelegate,UITableViewDataSource,UITableViewDelegate,IChatManagerDelegate,UISearchDisplayDelegate,UISearchBarDelegate>
{
    NSMutableArray *_conversations;
    
    NSMutableArray *_searchResults;
    
    
    
}

@property (nonatomic) UISearchDisplayController *mysearchConroller;


@end

@implementation ChatListTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
  
    self.title = @"邻信";
    
//    self.chatHeadView.frame = CGRectMake(0, 0, ScreenWidth, 44);
    
    
    self.tableView.tableHeaderView = self.mysearchConroller.searchBar;
    
    _conversations = [[NSMutableArray alloc]init];
    _searchResults = [[NSMutableArray alloc]init];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivegroupNoti:) name:kCreategroupSuccessNoti object:nil];
    
    
//    [self addHeaderRefresh];
//    [self addFooterRefresh];
    
  
    
//    [ MySearchBar setBackgroundColor :[ UIColor clearColor ]];
    
    
//    [self mysearchConroller];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kHadLogin]) {
        
        [self reFreshDataSource];
        
        [self registerNotifications];
        
        
       
    }
    else
    {
       
        UINavigationController *logNav = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNav"];
        
        [self presentViewController:logNav animated:YES completion:nil];
        
        
    }
    
   
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

-(void)headerRefresh
{
    
}

-(void)footerRefresh
{
    
}

-(UISearchDisplayController*)mysearchConroller
{
    if (!_mysearchConroller) {
        
        _mysearchConroller = [[UISearchDisplayController alloc]initWithSearchBar:self.searchBar contentsController:self];
        
        _mysearchConroller.searchResultsDataSource = self;
        
        _mysearchConroller.searchResultsDelegate = self;
        
        _mysearchConroller.displaysSearchBarInNavigationBar = NO;
        
        
    }
    
    return _mysearchConroller;
    
}

-(UISearchBar*)searchBar
{
    if (!_searchBar) {
        
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
        
        _searchBar.delegate = self;
        
        _searchBar.placeholder = nil;
        
        
    }
    
    return _searchBar;
    
}
#pragma mark - UITableViewDataSource

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *blankView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    
    blankView.backgroundColor = [UIColor clearColor];
    
    return blankView;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        
        return 50;
        
    }
    return 60;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
  
    return 1;
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _mysearchConroller.searchResultsTableView) {
        
        return _searchResults.count;
        
    }
    
       return _conversations.count + 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (tableView == _mysearchConroller.searchResultsTableView) {
        
        if (_searchResults.count > indexPath.section) {
            
            
            MyConversation *model = [_searchResults objectAtIndex:indexPath.section];
            
             ChatListCellTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellId];
            
            if (model.messageType == 0 ) {
                
                if (model.nickName) {
                    
                    cell.titleLabel.text = model.nickName;
                }
                else
                {
                    cell.titleLabel.text = model.converstion.chatter;
                }
                
                
                
                cell.lastestChatlabel.text =[self subTitleMessageByConversation:model.converstion];
                
                cell.timeLabel.text = [self lastMessageTimeByConversation:model.converstion];
                cell.timeLabel.adjustsFontSizeToFitWidth = YES;
                
                [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:model.headImageURL] placeholderImage:kDefaultHeadImage];
                
             }
            else if ( model.messageType == 1)
            {
                if (model.subTitle) {
                    
                    cell.titleLabel.text = model.subTitle;
                }
                else
                {
                    cell.titleLabel.text = model.converstion.chatter;
                }
                
                
                
                cell.lastestChatlabel.text =[self subTitleMessageByConversation:model.converstion];
                
                cell.timeLabel.text = [self lastMessageTimeByConversation:model.converstion];
                cell.timeLabel.adjustsFontSizeToFitWidth = YES;
                
                [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:model.groupHeadImage] placeholderImage:kDefaultHeadImage];
                
                
                
             }
            
            else
            {
                
                NSArray *photoURL = [model.huodong objectForKey:@"photoURL"];
                
                [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[photoURL firstObject]] placeholderImage:kDefaultHeadImage];
                
                cell.titleLabel.text = model.title;
                
                cell.lastestChatlabel.text = model.message;
                cell.timeLabel.adjustsFontSizeToFitWidth = YES;
                
             }
            
            
            return cell;
            
        }
    }
    
    
    if (indexPath.section == 0) {
        
        UITableViewCell *_headCell = [tableView dequeueReusableCellWithIdentifier:headCellID];
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
             UILabel *infoLabel = (UILabel*)[_headCell viewWithTag:99];
            infoLabel.clipsToBounds = YES;
            infoLabel.layer.cornerRadius = 5.0;
            
            
            UIImageView *_headImageView = (UIImageView*)[_headCell viewWithTag:100];
            UILabel *_titleLabel = (UILabel*)[_headCell viewWithTag:101];
            
        
            
            NSString *imageName = nil;
            NSString *title = nil;
            
            switch (indexPath.section) {
                case 0:
                {
                    imageName = @"llni";
                    title = @"熟人圈";
                    
                }
                    break;
           
                    
                default:
                    break;
            }
            
            _headImageView.image = [UIImage imageNamed:imageName];
            
            _titleLabel.text = title;
            
            
            
        });
        
        return _headCell;
        
        
    }
    
    
    
    ChatListCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    
    if (_conversations.count > indexPath.section -1) {
        
        
   
    MyConversation *model = [_conversations objectAtIndex:indexPath.section - 1];
    
        if (model.messageType == 0 ) {
            
            if (model.nickName) {
                
                cell.titleLabel.text = model.nickName;
            }
            else
            {
                cell.titleLabel.text = model.converstion.chatter;
            }
            
            
            
            cell.lastestChatlabel.text =[self subTitleMessageByConversation:model.converstion];
            
            cell.timeLabel.text = [self lastMessageTimeByConversation:model.converstion];
            cell.timeLabel.adjustsFontSizeToFitWidth = YES;
            
            [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:model.headImageURL] placeholderImage:kDefaultHeadImage];
            
         }
        else if ( model.messageType == 1)
        {
            if (model.subTitle) {
                
                cell.titleLabel.text = model.subTitle;
            }
            else
            {
                cell.titleLabel.text = model.converstion.chatter;
            }
            
            
            
            cell.lastestChatlabel.text =[self subTitleMessageByConversation:model.converstion];
            
            cell.timeLabel.text = [self lastMessageTimeByConversation:model.converstion];
            
            cell.timeLabel.adjustsFontSizeToFitWidth = YES;
            
            [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:model.groupHeadImage] placeholderImage:kDefaultHeadImage];
            

            
         }
        
        else
        {
            
            NSArray *photoURL = [model.huodong objectForKey:@"photoURL"];
            
            [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[photoURL firstObject]] placeholderImage:kDefaultHeadImage];
            
            cell.titleLabel.text = model.title;
            
            cell.lastestChatlabel.text = model.message;
            
            cell.timeLabel.adjustsFontSizeToFitWidth = YES;
          
        }

    
  
     }
    
    
    return cell;
    
    
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == _mysearchConroller.searchResultsTableView || indexPath.section > 0) {
        
        
        MyConversation *model;
        
        if (tableView == _mysearchConroller.searchResultsTableView) {
            
            if (_conversations.count < indexPath.section ) {
                
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                
                return;
                
            }
            model = [_searchResults objectAtIndex:indexPath.section ];
        }
        
        else
        {
            if (_conversations.count < indexPath.section -1) {
                
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                
                return;
                
            }
            model = [_conversations objectAtIndex:indexPath.section - 1];
        }
        
        
        if (model.messageType ==0 ) {
            
            
         
            
            ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:model.converstion.chatter isGroup:NO];
            if (model.nickName) {
                
                //        chatVC.title =model.nickName;
                chatVC.subTitle = model.nickName;
                
            }else
            {
                //        chatVC.title = model.converstion.chatter;
                chatVC.subTitle = model.nickName;
            }
            
            chatVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:chatVC animated:YES];
            
            
            
        }
        else if (model.messageType == 1)
        {
            
            
            
            EMGroup *group = [[EaseMob sharedInstance].chatManager fetchGroupInfo:model.groupId error:nil];
            
            ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:model.converstion.chatter isGroup:YES];
            if (model.subTitle) {
                
                chatVC.title =model.subTitle;
                chatVC.subTitle = model.subTitle;
            }else
            {
                chatVC.title = model.converstion.chatter;
                chatVC.subTitle = model.nickName;
            }
            
            chatVC.groupHeadImageURL = model.groupHeadImage;
            
            chatVC.group = group;
            NSLog(@"beginTitle:%@",chatVC.subTitle);
            
            chatVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:chatVC animated:YES];
        }
        
        else if (model.messageType == 2)
        {
           
            BmobQuery *query = [BmobQuery queryWithClassName:kHuoDongTableName];
            
            NSString *huodongID = [model.huodong objectForKey:@"objectId"];
            
            [query whereKey:@"objectId" equalTo:huodongID];
            
            [MyProgressHUD showProgress];
            
            [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
               
                [MyProgressHUD dismiss];
                
                if (!error && array.count > 0) {
                    
                    
                    BmobObject *temOb = [array firstObject];
                    NSDate *startDate = [temOb objectForKey:@"startTime"];
                    NSDate *endDate = [temOb objectForKey:@"endTime"];
                    NSDate *endRegistTime = [temOb objectForKey:@"endRegistTime"];
                    
                    HuoDongModel *_huodongModel = [[HuoDongModel alloc]init];
                    
                    NSDictionary *dic = [temOb valueForKey:kBmobDataDic];
                    
                    [_huodongModel setValuesForKeysWithDictionary:dic];
                    
                    
                    _huodongModel.startTime = startDate;
                    _huodongModel.endRegistTime = endRegistTime;
                    _huodongModel.endTime = endDate ;
                    
                    HuoDongDetailTVC *_detail = [self.storyboard instantiateViewControllerWithIdentifier:@"HuoDongDetailTVC"];
                    
                    _detail.huodong = _huodongModel;
                    _detail.hidesBottomBarWhenPushed = YES;
                    
                     [self.navigationController pushViewController:_detail animated:YES];
                    
                    
                }
            }];
         
            
            
            
           
            
            
            
        }
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        return;
        
    }
    
    if (indexPath.section ==0) {
        
        
        ShengHuoQuanTVC *_shenghuoQuan = [self.storyboard instantiateViewControllerWithIdentifier:@"ShengHuoQuanTVC"];
        
        _shenghuoQuan.hidesBottomBarWhenPushed = YES;
        
        _shenghuoQuan.isShuRenQuan = 1;
        
        
        [self.navigationController pushViewController:_shenghuoQuan animated:YES];
        

       
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        return;
        
    }
    
    

    

    
   
    
}

#pragma mark -  得到最后消息时间
-(NSString *)lastMessageTimeByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];;
    if (lastMessage) {
        ret = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
    }
    
    return ret;
}

#pragma mark -  得到未读消息条数
- (NSInteger)unreadMessageCountByConversation:(EMConversation *)conversation
{
    NSInteger ret = 0;
    ret = conversation.unreadMessagesCount;
    
    return  ret;
}

#pragma mark -  得到最后消息文字或者类型
-(NSString *)subTitleMessageByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];
    if (lastMessage) {
        id<IEMMessageBody> messageBody = lastMessage.messageBodies.lastObject;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Image:{
                ret = NSLocalizedString(@"message.image1", @"[image]");
            } break;
            case eMessageBodyType_Text:{
                // 表情映射。
                NSString *didReceiveText = [ConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
//                if ([[RobotManager sharedInstance] isRobotMenuMessage:lastMessage]) {
//                    ret = [[RobotManager sharedInstance] getRobotMenuMessageDigest:lastMessage];
//                } else {
//                    ret = didReceiveText;
//                }
                
                 ret = didReceiveText;
                
            } break;
            case eMessageBodyType_Voice:{
                ret = NSLocalizedString(@"message.voice1", @"[voice]");
            } break;
            case eMessageBodyType_Location: {
                ret = NSLocalizedString(@"message.location1", @"[location]");
            } break;
            case eMessageBodyType_Video: {
                ret = NSLocalizedString(@"message.video1", @"[video]");
            } break;
            default: {
            } break;
        }
    }
    
    return ret;
}


#pragma mark - 刷新
-(void)reFreshDataSource
{
    
    
    [self loadDataSource];
    
   
    
    
}

#pragma mark -获取聊天记录
- (void)loadDataSource
{
 
    NSArray *conversations = [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES];
    
    NSMutableArray *personChats = [[NSMutableArray alloc]init];
    NSMutableArray *groupChats = [[NSMutableArray alloc]init];
    
    for (EMConversation *convert in conversations) {
        
        if (convert.conversationType == eConversationTypeChat) {
            
            
            [personChats addObject:convert];
            
        }
        else
        {
            [groupChats addObject:convert];
            
        }
        
    }
    
    
    // get conversations nickname headImage
    [_conversations removeAllObjects];
    
    [BmobHelper getGroupChatInfo:groupChats results:^(NSArray *array) {
        
        if (array) {
            
            
            [_conversations addObjectsFromArray:array];
            
            
            [self getPersonchatHeaderImages:personChats];
            
            
        }
        else
        {
            [self getPersonchatHeaderImages:personChats];
            
        }
    }];
    
    

    
 
}

-(void)getPersonchatHeaderImages:(NSArray*)personChats
{
    // get conversations nickname headImage
    [BmobHelper getConversionsNickNameHeadeImageURL:personChats results:^(NSArray *array) {
        
        if (array) {
            
             [_conversations addObjectsFromArray:array];
            
        }
        else
        {
            
        }
        
        NSArray* sorte = [_conversations sortedArrayUsingComparator:
                          ^(MyConversation *obj1, MyConversation* obj2){
                              
                              EMMessage *message1 = [obj1.converstion latestMessage];
                              EMMessage *message2 = [obj2.converstion latestMessage];
                              if(message1.timestamp > message2.timestamp) {
                                  return(NSComparisonResult)NSOrderedAscending;
                              }else {
                                  return(NSComparisonResult)NSOrderedDescending;
                              }
                          }];
        
        
        NSMutableArray *muArray = [[NSMutableArray alloc]initWithArray:sorte];
        
        _conversations = muArray;
        
        
        [self getHuoDongMessages];
        
        
        
        
        
    }];
}


#pragma mark - 获取活动消息
-(void)getHuoDongMessages{
    
    NSString *username = [BmobUser getCurrentUser].username;
    
    if (username) {
        
        [BmobHelper getHuoDongMessageswithusername:username index:0 results:^(NSArray *array) {
           
            if (array) {
                
                [_conversations addObjectsFromArray:array];
                
            }
            
            
            [self.tableView reloadData];
            
            
            
        }];
    }
    
    
}



#pragma mark - IChatMangerDelegate

-(void)didUnreadMessagesCountChanged
{
    [self reFreshDataSource];
}

- (void)didUpdateGroupList:(NSArray *)allGroups error:(EMError *)error
{
    [self reFreshDataSource];
}


#pragma mark - registerNotifications
-(void)registerNotifications{
    [self unregisterNotifications];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}



- (void)receivegroupNoti:(NSNotification*)noti
{
    
//    EMGroup *group = noti.object;
//    
//    NSDictionary *dic = noti.userInfo;
//    
//    NSString *groupid = dic[@"groupid"];
//    
//    ChatViewController *chatController = [[ChatViewController alloc] initWithChatter:groupid isGroup:YES];
//    chatController.title = group.groupSubject;
//    
//    chatController.hidesBottomBarWhenPushed = YES;
//    
//    [self.navigationController pushViewController:chatController animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - UISearchDisplayDelegate
-(void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView
{
    [controller setActive:NO animated:YES];
    
}




-(void)matchSearch:(NSString*)search
{
    
    [_searchResults removeAllObjects];
    
    for (MyConversation *temCon in _conversations) {
        
        NSString *str = nil;
        if (temCon.messageType == 0) {
            
            str = temCon.nickName;
            
            if (!str) {
                
                str = temCon.username;
            }
            
            
        }
        else if (temCon.messageType == 1)
        {
            
            str = temCon.subTitle;
            
            if (!str) {
                
                str = temCon.converstion.chatter;
            }
        }
        else
        {
            
            str = temCon.title;
            
        }
        
        
        
        NSRange range = [str rangeOfString:search];
        
        if (range.length > 0) {
            
            
            [_searchResults addObject:temCon];
            
        }
    }
    
    if (_searchResults.count > 0) {
        
        
        [_mysearchConroller.searchResultsTableView reloadData];
        
    }
    
}

- (void)dealloc
{
    [self unregisterNotifications];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
