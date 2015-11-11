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

static NSString *cellId = @"ChatListCell";


@interface ChatListTableViewController ()<EMChatManagerDelegate,UITableViewDataSource,UITableViewDelegate,IChatManagerDelegate>
{
    NSMutableArray *_conversations;
    
    
}

@end

@implementation ChatListTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
  
    self.title = @"邻信";
    
    self.chatHeadView.frame = CGRectMake(0, 0, ScreenWidth, 44);
    
    
    _conversations = [[NSMutableArray alloc]init];
    
//    [self addHeaderRefresh];
//    [self addFooterRefresh];
    
  
    
//    [ MySearchBar setBackgroundColor :[ UIColor clearColor ]];
    
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

-(void)headerRefresh
{
    
}

-(void)footerRefresh
{
    
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
    
    return 60;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
       return _conversations.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatListCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    MyConversation *model = [_conversations objectAtIndex:indexPath.row];
    
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
    
    
    
    return cell;
    
    
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyConversation *model = [_conversations objectAtIndex:indexPath.section];
    
    ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:model.converstion.chatter isGroup:NO];
    if (model.nickName) {
        
        chatVC.title =model.nickName;
    }else
    {
        chatVC.title = model.converstion.chatter;
    }
    
    chatVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:chatVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    

    
   
    
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
 
    NSArray *conversations = [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:NO];
    // get conversations nickname headImage
    
    [BmobHelper getConversionsNickNameHeadeImageURL:conversations results:^(NSArray *array) {
       
        if (array) {
            
            NSArray* sorte = [array sortedArrayUsingComparator:
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
            
            [self.tableView reloadData];
            
            
        }
       
        
        
    }];
    
 
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
