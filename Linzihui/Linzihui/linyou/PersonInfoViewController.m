//
//  ua.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/12/23.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "ChatViewController.h"
#import "ShengHuoQuanTVC.h"
#import "AddBeiZhuVC.h"
#import "FriendEditedTVC.h"
#import "PersonPullView.h"




@interface PersonInfoViewController ()
{
    CheckType friendType;
    
    PersonPullView *_pullView;
    
    BOOL hadShowed;
    
    
    
}
@property (nonatomic) UserModel *model;

@end

@implementation PersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"详细资料";
    
    if (_isShowed) {
        
        _sendButton.hidden = YES;
        
    }

    if ([_username isEqualToString:[BmobUser getCurrentUser].username]) {
        
        self.navigationItem.rightBarButtonItem = nil;
        
    }
    

    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getData];
    
}

-(void)getData
{
    
    [BmobHelper searchUserWithUsername:_username searchResult:^(NSArray *array) {
       
        if (array) {
            
            _model = [array firstObject];
            
            _pullView = [[PersonPullView alloc]initwithUserModel:self.model];
            
           
            
            
            [_headImageView sd_setImageWithURL:[NSURL URLWithString:_model.headImageURL] placeholderImage:kDefaultHeadImage];
            
            _nickName.text = _model.nickName;
            
            
            _yaoqingma.text = _model.inviteCode;
            
            _qianming.text = _model.selfComment;
            
            _address.text = _model.area;
            
            NSArray *beizhus = [BmobHelper getCurrentUserModel].beiZhu;
            
            if (beizhus.count > 0) {
                
                for (NSDictionary *dic in beizhus) {
                    
                    NSString *username = [dic objectForKey:@"username"];
                    
                    if ([username isEqualToString:_username]) {
                        
                        _beizhuLabel.text = [dic objectForKey:@"beizhu"];
                        
                    }
                }
            }
            
            [self checkGuanZhu:array];
            
         
            
        }
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 1) //备注
    {
        
        if ([_username isEqualToString:[BmobUser getCurrentUser].username]) {
            
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
         
            return;
            
            
        }
        
        AddBeiZhuVC *_addBeiZhu = [self.storyboard instantiateViewControllerWithIdentifier:@"AddBeiZhuVC"];
        
        _addBeiZhu.username = _username;
        _addBeiZhu.beizhuStr = _beizhuLabel.text;
        
        [self.navigationController pushViewController:_addBeiZhu animated:YES];
        
        
    }
    
    if (indexPath.section == 2) //相册
    {
        
       
        ShengHuoQuanTVC *_shenghuoQuan = [self.storyboard instantiateViewControllerWithIdentifier:@"ShengHuoQuanTVC"];
        
        _shenghuoQuan.hidesBottomBarWhenPushed = YES;
        
        if ([_username isEqualToString:[BmobUser getCurrentUser].username]) {
            
            _shenghuoQuan.isShuRenQuan = 2;
        }
        else
        {
            _shenghuoQuan.isShuRenQuan = 3; 
        }
       
        
        _shenghuoQuan.username = _username;
        
        [self.navigationController pushViewController:_shenghuoQuan animated:YES];
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(void)checkGuanZhu:(NSArray*)userArray
{
    
    //如果是查看自己的就隐藏按钮
    if ([_model.username isEqualToString:[BmobUser getCurrentUser].username]) {
        
        _sendButton.hidden =YES;
          _linhao.text = _model.username;
        return;
        
    }
    
    
    NSArray *friendList = [[EaseMob sharedInstance].chatManager fetchBuddyListWithError:nil];
    
    BOOL isFriend = NO;
    
    for (EMBuddy *buddy in friendList) {
        
        if ([_username isEqualToString:buddy.username]) {
           
            isFriend = YES;
            
            friendType = CheckTypeFriend;
        }
        
        
    }
    
    if (isFriend) {
        
          _linhao.text = _model.username;
        
        [_sendButton setTitle:@"发送消息" forState:UIControlStateNormal];
    }
    else
    {
        
        
        _linhao.text = @"";
        
        
  
        
        
        //检查是否互相关注
        
      
        [BmobHelper checkFollowTypeWithUserModel:[userArray firstObject] result:^(UserModel *finalModel) {
           
            if (finalModel) {
                
                _model = finalModel;
                
                
                if (_model.followType == CheckTypeFollowEachOther) {
                    
                    [_sendButton setTitle:@"发送好友请求" forState:UIControlStateNormal];
                    
                    friendType = CheckTypeFollowEachOther;
                }
                
                else if (_model.followType == CheckTypeOnlyFollowMe)
                {
                    
                    friendType = CheckTypeOnlyFollowMe;
                    
                    [_sendButton setTitle:@"关注" forState:UIControlStateNormal];
                    
                    
                }
                else if (_model.followType == CheckTypeOnlyMyFollow)
                {
                    friendType = CheckTypeOnlyMyFollow;
                    
                    [_sendButton setTitle:@"已关注" forState:UIControlStateNormal];
                    
                    
                    _sendButton.enabled = NO;
                    
                    
                }
                else
                {
                    friendType = CheckTypeOnlyFollowMe;
                    
                    [_sendButton setTitle:@"关注" forState:UIControlStateNormal];
                }
                
                
            }
            
        }];
        

        
        
        
        
    }
}

- (IBAction)sendAction:(id)sender {
    
    
    if (friendType == CheckTypeFriend) {
        
        ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:_model.username isGroup:NO];
        if (_model.nickName) {
            
            //        chatVC.title =model.nickName;
            chatVC.subTitle = _model.nickName;
            
        }else
        {
            //        chatVC.title = model.converstion.chatter;
            chatVC.subTitle = _model.nickName;
        }
        
      
        
        [self.navigationController pushViewController:chatVC animated:YES];
    }
    else if(friendType == CheckTypeFollowEachOther)
    {
        [EMHelper sendFriendRequestWithBuddyName:_username Mesage:@"请求加你好友"];
        
    }
    else
    {
        [BmobHelper addFollowWithFollowedUserModel:_model result:^(BOOL success) {
           
            
            if (success) {
                
                [CommonMethods showDefaultErrorString:@"关注成功"];
                
                [_sendButton setTitle:@"已关注" forState:UIControlStateNormal];
                
                _sendButton.enabled = NO;
                
            }
        }];
    }
    
}
- (IBAction)showInfo:(id)sender {
    
    
    
    if (hadShowed) {
       
        
        [_pullView removeFromSuperview];
        
        hadShowed = NO;
    }
    
    else
    {
        [self.view addSubview:_pullView];
        
        hadShowed = YES;
        
    }
    
    
    
//    FriendEditedTVC *_friendTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FriendEditedTVC"];
//    
//    _friendTVC.model = _model;
//    
//    
//    [self.navigationController pushViewController:_friendTVC animated:YES];
    
    
    
    
    
}





@end
