//
//  TongXunLuTVC.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/12.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "TongXunLuTVC.h"

static NSString *ContactsCell = @"ContactsCell";



@interface TongXunLuTVC ()
{
    NSString *yaoqingma;
    
    UIActionSheet *_yaoqingActionsheet;
    
  
    
    
}
@property (nonatomic) UISearchDisplayController *displayController;
@property (nonatomic) UISearchBar *mySearchBar;

@property(nonatomic,assign) ABAddressBookRef addressBook;
@property(nonatomic,strong)  NSMutableArray *abDataSource;
@property (nonatomic,strong) NSMutableArray *inviteDataSource;
@property (nonatomic)        NSMutableArray *searchResults;



@end

@implementation TongXunLuTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"通讯录好友";
    
    _abDataSource = [[NSMutableArray alloc]init];
    _inviteDataSource = [[NSMutableArray alloc]init];
    _searchResults = [[NSMutableArray alloc]init];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navbar_return_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
    

    
    yaoqingma = [BmobUser getCurrentUser].objectId;
    
    if (!_isFromNewFriend) {
        
         [self getLocateInviteData]; 
    }
  
    
    self.tableView.tableHeaderView = [self displayController].searchBar;
    
    
    [self requestAuthor];
    
}

-(void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(UISearchBar*)mySearchBar
{
    
    if (!_mySearchBar) {
        
        _mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
        
        _mySearchBar.delegate = self;
        
    }
    
    return _mySearchBar;
    
}

-(UISearchDisplayController*)displayController
{
    if (!_displayController) {
        
        _displayController = [[UISearchDisplayController alloc]initWithSearchBar:self.mySearchBar contentsController:self];
        
        
        _displayController.delegate = self;
        _displayController.searchResultsDataSource = self;
        _displayController.searchResultsDelegate = self;
        
        
    }
    
    return _displayController;
    
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    if (searchBar.text.length == 0) {
        
        return;
    }
    
    [self search:searchBar.text];
    
}

-(void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView
{
    

    
    [controller setActive:NO];
    
}

#pragma mark - 搜索
-(void)search:(NSString*)str
{
    
   
     [_searchResults removeAllObjects];
    
    
    
    for (int i = 0 ; i < _abDataSource.count; i++ ) {
        
        ContactModel *model = [_abDataSource objectAtIndex:i];
        
        NSRange rang = [model.nickName rangeOfString:str];
        
        if (rang.length > 0) {
            
            [_searchResults addObject:model];
            
        }
        else
        {
            rang = [model.username rangeOfString:str];
            
            if (rang.length > 0) {
                
                [_searchResults addObject:model];
                
            }
        }
    }
    
    
    [_displayController.searchResultsTableView reloadData];
    
    
    
}
#pragma mark -  获取好友邀请
-(void)getLocateInviteData
{
    [_inviteDataSource removeAllObjects];
    NSDictionary *loginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    NSString *loginName = [loginInfo objectForKey:kSDKUsername];
    if(loginName && [loginName length] > 0)
    {
        
        NSArray * applyArray = [[InvitationManager sharedInstance] applyEmtitiesWithloginUser:loginName];
        
        
        [_inviteDataSource addObjectsFromArray:applyArray];
        
        [self.tableView reloadData];
    }
}


#pragma mark - 获取授权
-(void)requestAuthor
{
    _addressBook = ABAddressBookCreate();

//     [MyProgressHUD showProgress];
    
//    [CNContactStore authorizationStatusForEntityType:]
//    if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized)
    {
        
        ABAddressBookRequestAccessWithCompletion(_addressBook, ^(bool granted, CFErrorRef error) {
            
            if (granted) {
                
                ABAddressBookRevert(_addressBook);
                
                NSArray *temArray = [NSArray arrayWithArray:(__bridge_transfer NSArray*)ABAddressBookCopyArrayOfAllPeople(_addressBook)];
                
                
              
                
                [self getContactsInfo:temArray];
                
                
                
            }
        });
        
    }
}

-(void)getContactsInfo:(NSArray*)contacts
{
    
    if (contacts.count == 0) {
        
        [MyProgressHUD dismiss];
        
        
    }
    NSMutableArray *mucontacts = [[NSMutableArray alloc]init];
    
    for (int i = 0 ; i < contacts.count; i ++) {
        
        ABRecordRef person = (__bridge ABRecordRef)(contacts[i]);
        
        NSString *firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        NSString *lastName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
       
        if (!firstName) {
            
            firstName = @"";
        }
        if (!lastName) {
            
            lastName = @"";
        }
        NSString *name = [NSString stringWithFormat:@"%@%@",lastName,firstName];
        
        
        
        ABMultiValueRef phoneRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
        
        NSString *phoneNum = nil;
        
        for (int k = 0; k < ABMultiValueGetCount(phoneRef); k++) {
            
            NSString *temPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phoneRef, k);
            
            if (temPhone.length > 0) {
                
//                NSLog(@"temPhone:%@",temPhone);
                
                phoneNum = temPhone;
                
            }
            
            
            
        }
        
        if (phoneNum.length > 0)
        {
            
            
            phoneNum = [CommonMethods getRightPhoneNum:phoneNum];
           
            
            
            if ([CommonMethods checkTel:phoneNum]) {
//                NSLog(@"phoneNum:%@",phoneNum);
                NSDictionary *temDict = @{@"name":name,@"phone":phoneNum};
                
                [mucontacts addObject:temDict];
                
            }
           
            
            
         }
        
//        NSLog(@"%s,mucontacts:%ld",__func__,(long)mucontacts.count);
        
  
        
    }
    
  
    
    [BmobHelper tongxunluMatch:mucontacts results:^(NSArray *array) {
        
        [MyProgressHUD dismiss];
        
        
        if (array) {
            
            [_abDataSource addObjectsFromArray:array];
            
            NSLog(@"%s,_abDataSource%ld",__func__,(long)_abDataSource.count);
            
            [self.tableView reloadData];
            
        }
        
    }];
    

    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == _displayController.searchResultsTableView) {
        
        
        return _searchResults.count;
        
    }
    if (section == 0) {
        
        return _inviteDataSource.count;
        
    }
    
     return _abDataSource.count;
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   
    if (tableView == _displayController.searchResultsTableView) {
        
        return 1;
        
        
    }
    return 2;
    
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ContactsCell];
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
        cell.contentView.tag = indexPath.row;
        
        UIImageView *imageView = (UIImageView*)[cell.contentView viewWithTag:1000 ];
        
        UILabel *nameLable = (UILabel*)[cell.contentView viewWithTag:1001];
        
        UIButton *addButto = (UIButton*)[cell.contentView viewWithTag:1002];
        addButto.clipsToBounds = YES;
        addButto.layer.cornerRadius = 5;
        
    
        if (indexPath.section == 0 && tableView != _displayController.searchResultsTableView) {
            
           
            addButto.enabled = YES;
            
            [addButto setTitle:@"接受" forState:UIControlStateNormal];
            addButto.backgroundColor = [UIColor redColor];
            
            [addButto setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [addButto addTarget:self action:@selector(acceptApply:) forControlEvents:UIControlEventTouchUpInside];
            
            ApplyEntity *entity = [_inviteDataSource objectAtIndex:indexPath.row ];
            if (entity) {
                
                ApplyStyle applyStyle = [entity.style intValue];
                if (applyStyle == ApplyStyleGroupInvitation) {
                    
                    
                    
                }
                else if (applyStyle == ApplyStyleJoinGroup)
                {
                    
                }
                else if(applyStyle == ApplyStyleFriend){
                    
                    [imageView sd_setImageWithURL:[NSURL URLWithString:entity.avatar] placeholderImage:kDefaultHeadImage];
                    
                    if (entity.applicantNick) {
                        
                        nameLable.text = entity.applicantNick;
                    }
                    else
                    {
                        nameLable.text = entity.applicantUsername;
                        
                    }
                    
                    if (entity.reason) {
                        
                        
                    }
                    else
                    {
                       
                    }
                    
                    
                    
                 }
            }
            
            
        }
        else
        {
            
            ContactModel *oneContact = nil;
            
            if (tableView == _displayController.searchResultsTableView) {
                
                 if (_searchResults.count > indexPath.row) {
                oneContact = [_searchResults objectAtIndex:indexPath.row];
                 }
                
            }
            else
            {
                
               
                if (_abDataSource.count > indexPath.row) {
                    
                    oneContact = [_abDataSource objectAtIndex:indexPath.row];
                }
                
                
                
            }
          
        
            if (oneContact.headImageURL) {
                
                [imageView sd_setImageWithURL:[NSURL URLWithString:oneContact.headImageURL] placeholderImage:kDefaultHeadImage];
            }
            else
            {
                imageView.image = kDefaultHeadImage;
                
            }
        
        
        if (oneContact.nickName) {
            
            nameLable.text = oneContact.nickName;
        }
        else
        {
            nameLable.text = oneContact.phoneNum;
        }
        
        if (oneContact.hadRegist && oneContact.isBuddy) {
            
            [addButto setTitle:@"已添加" forState:UIControlStateNormal];
            
            addButto.enabled = NO;
            addButto.backgroundColor = [UIColor clearColor];
            
            [addButto setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            
            
        }
        else if (oneContact.hadRegist)
        {
            
            if (oneContact.hadSendFriendRequest) {
                
                addButto.enabled = NO;
                
                [addButto setTitle:@"待批" forState:UIControlStateNormal];
                addButto.backgroundColor = [UIColor redColor];
                
                [addButto setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
            }
            else
            {
                addButto.enabled = YES;
                
                [addButto setTitle:@"添加" forState:UIControlStateNormal];
                addButto.backgroundColor = [UIColor redColor];
                
                [addButto setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
     
        }
        else
        {
            addButto.enabled = YES;
            
            [addButto setTitle:@"邀请" forState:UIControlStateNormal];
             addButto.backgroundColor = kBlueBackColor;
            
            [addButto setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
        }
        
      
        
        [addButto addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
            
            
            
        }
        
        
    });
    
    
    return cell;
}


-(void)addAction:(UIButton*)addButton
{
    
     NSInteger tag = [addButton superview].tag;
    
    
    ContactModel *model = [_abDataSource objectAtIndex:[addButton superview].tag];
    
    
    if ([addButton.titleLabel.text isEqualToString:@"邀请"]) {
        
        NSString *text = [NSString stringWithFormat:@"您的好友邀请您加入邻子会，社区邻妈互助众扶App,大量就近免费活动与奖励，邀请码为:%@,下载地址为:%@",yaoqingma,kAppDownloadURL];
    
        [self sendSMSMessageWithPhoneNum:model.phoneNum content:text];
        
//        _yaoqingActionsheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
//        
//        [_yaoqingActionsheet addButtonWithTitle:@"短信邀请"];
//        [_yaoqingActionsheet addButtonWithTitle:@"微信邀请"];
//        [_yaoqingActionsheet addButtonWithTitle:@"QQ邀请"];
//        
//        [_yaoqingActionsheet addButtonWithTitle:@"取消"];
//        
//        _yaoqingActionsheet.tag = [addButton superview].tag ;
//                                   
//        _yaoqingActionsheet.cancelButtonIndex = 3;
//     
//        [_yaoqingActionsheet showInView:self.view];
        
     
    }
    else  //添加好友
    {
       
        [EMHelper sendFriendRequestWithBuddyName:model.username Mesage:@"请求加你为好友"];
        
          ContactModel *oneContact = [_abDataSource objectAtIndex:tag];
        
        oneContact.hadSendFriendRequest = YES;
        
        [_abDataSource replaceObjectAtIndex:tag withObject:oneContact];
        
        [self.tableView reloadData];
        
        
    }
}

#pragma mark - 发送短信
- (void)sendSMSMessageWithPhoneNum:(NSString*)phone content:(NSString*)content{
    
    MFMessageComposeViewController *_messageVC = [[MFMessageComposeViewController alloc]init];
    
    _messageVC.recipients = @[phone];
    
    _messageVC.body = content;
    _messageVC.messageComposeDelegate = self;
    
    [self presentViewController:_messageVC animated:YES completion:nil];
    
    
    
}
#pragma mark - MFMessageComposeViewControllerDelegate
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if (actionSheet == _yaoqingActionsheet) {
        
        
         ContactModel *model = [_abDataSource objectAtIndex:actionSheet.tag];
        
         NSString *text = [NSString stringWithFormat:@"您的好友邀请您加入邻子会，社区邻妈互助众扶App,大量就近免费活动与奖励，邀请码为:%@,下载地址为:%@",yaoqingma,kAppDownloadURL];
        
        switch (buttonIndex) {
            case 0:
            {
               
                [self sendSMSMessageWithPhoneNum:model.phoneNum content:text];
                
            
            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - 接受好友请求
-(void)acceptApply:(UIButton*)sender
{
   
    
    ApplyEntity *entity = [_inviteDataSource objectAtIndex:[sender superview].tag ];
    
    EMError *error ;
    
    if ([[EMHelper getHelper] accepBuddyRequestWithUserName:entity.applicantUsername error:&error])
    {
        if (error) {
            
            NSLog(@"acceppt error:%@",error);
            
          
            
            
            
        }
        
         [[InvitationManager sharedInstance] removeInvitation:entity loginUser:[BmobUser getCurrentUser].username];
        
        
        [self getLocateInviteData];
        
        
        
        
    }
    
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}


@end
