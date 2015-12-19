//
//  GroupChatListTVC.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/12/8.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "GroupChatListTVC.h"
#import "MyConversation.h"
#import "NSDate+Category.h"
#import "ConvertToCommonEmoticonsHelper.h"
#import "ChatViewController.h"



static NSString *cellID = @"GroupCellID";


@interface GroupChatListTVC ()<EMChatManagerDelegate,IChatManagerDelegate>
{
     NSMutableArray *_conversations;
}
@end

@implementation GroupChatListTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"群消息";
    
    _conversations = [[NSMutableArray alloc]init];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivegroupNoti:) name:kCreategroupSuccessNoti object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reFreshDataSource];
    
    [self registerNotifications];
    
}


#pragma mark - UITableViewDataSource

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *blankView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 5)];
    
    blankView.backgroundColor = [UIColor clearColor];
    
    return blankView;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    return 50;
    
    
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    MyConversation *model = [_conversations objectAtIndex:indexPath.section];
    
    dispatch_async(dispatch_get_main_queue(), ^{
      
        
        UIImageView *_imageView = [cell viewWithTag:100];
        
        UILabel *_titleLabel = [cell viewWithTag:101];
        
        _titleLabel.text = model.subTitle;
        
        
//        [_imageView sd_setImageWithURL:[NSURL URLWithString:model.headImageURL] placeholderImage:kDefaultHeadImage];
        
          EMGroup *group = [[EaseMob sharedInstance].chatManager fetchGroupInfo:model.groupId error:nil];
        
        [BmobHelper getGroupHeadImageView:group imageView:_imageView result:^(BOOL success, UIImageView *headImageView) {
           
            
        }];
        
        
        
    });
    
    
    
//    if (model.nickName) {
//        
//        cell.titleLabel.text = model.nickName;
//    }
//    else
//    {
//        cell.titleLabel.text = model.converstion.chatter;
//    }
//    
//    
//    
//    cell.lastestChatlabel.text =[self subTitleMessageByConversation:model.converstion];
//    
//    
//    cell.timeLabel.text = [self lastMessageTimeByConversation:model.converstion];
//    cell.timeLabel.adjustsFontSizeToFitWidth = YES;
//    
//    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:model.headImageURL] placeholderImage:kDefaultHeadImage];
    
    
    
    return cell;
    
    
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
 
    
    MyConversation *model = [_conversations objectAtIndex:indexPath.section ];
    
    
    EMGroup *group = [[EaseMob sharedInstance].chatManager fetchGroupInfo:model.groupId error:nil];
    
    ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:model.converstion.chatter isGroup:YES];
    if (model.subTitle) {
        
        chatVC.title =model.subTitle;
         chatVC.subTitle = model.nickName;
    }else
    {
        chatVC.title = model.converstion.chatter;
         chatVC.subTitle = model.nickName;
    }
    
    chatVC.group = group;
    
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
    
    NSArray *conversations = [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES];
    
    NSMutableArray *muArray = [[NSMutableArray alloc]init];
    
    for (EMConversation *convert in conversations) {
        
        if (convert.conversationType != eConversationTypeChat) {
            
            
            [muArray addObject:convert];
            
        }
        
    }
    
    
    // get conversations nickname headImage
    [BmobHelper getGroupChatInfo:muArray results:^(NSArray *array) {
       
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
        else
        {
            
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


- (void)receivegroupNoti:(NSNotification*)noti
{
    
    
    [self reFreshDataSource];
    
//    EMGroup *group = noti.object;
//    
//    NSDictionary *dic = noti.userInfo;
//    
//    NSString *groupid = dic[@"groupid"];
    
//    ChatViewController *chatController = [[ChatViewController alloc] initWithChatter:groupid isGroup:YES];
//    chatController.title = group.groupSubject;
//    
//    chatController.hidesBottomBarWhenPushed = YES;
//    
//    [self.navigationController pushViewController:chatController animated:YES];
    
}



- (void)dealloc
{
    [self unregisterNotifications];
    
    [[NSNotificationCenter defaultCenter ] removeObserver:self name:kCreategroupSuccessNoti object:nil];
    
    
}




@end
