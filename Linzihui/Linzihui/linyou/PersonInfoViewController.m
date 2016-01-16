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



typedef NS_ENUM(NSInteger,CheckType)
{
    CheckTypeOnlyFollowMe,
    CheckTypeOnlyMyFollow,
    CheckTypeFollowEachOther,
    CheckTypeFriend,
    
};
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
            
            _linhao.text = _model.username;
            
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
        
        AddBeiZhuVC *_addBeiZhu = [self.storyboard instantiateViewControllerWithIdentifier:@"AddBeiZhuVC"];
        
        _addBeiZhu.username = _username;
        _addBeiZhu.beizhuStr = _beizhuLabel.text;
        
        [self.navigationController pushViewController:_addBeiZhu animated:YES];
        
        
    }
    
    if (indexPath.section == 2) //相册
    {
        ShengHuoQuanTVC *_shenghuoQuan = [self.storyboard instantiateViewControllerWithIdentifier:@"ShengHuoQuanTVC"];
        
        _shenghuoQuan.hidesBottomBarWhenPushed = YES;
        
        _shenghuoQuan.isShuRenQuan = 3;
        
        _shenghuoQuan.username = _username;
        
        [self.navigationController pushViewController:_shenghuoQuan animated:YES];
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(void)checkGuanZhu:(NSArray*)userArray
{
    NSArray *friendList = [[EaseMob sharedInstance].chatManager fetchBuddyListWithError:nil];
    
    BOOL isFriend = NO;
    
    for (EMBuddy *buddy in friendList) {
        
        if ([_username isEqualToString:buddy.username]) {
           
            isFriend = YES;
            
            friendType = CheckTypeFriend;
        }
        
        
    }
    
    if (isFriend) {
        
        [_sendButton setTitle:@"发送消息" forState:UIControlStateNormal];
    }
    else
    {
        
        //检查是否互相关注
        [BmobHelper checkFollowEachOtherWithItemArray:userArray searchResult:^(NSArray *results) {
            
            
            if (results) {
                
                UserModel *tem_model = [results firstObject];
                
                if (tem_model.followEach) {
                    
                    
                    [_sendButton setTitle:@"发送好友请求" forState:UIControlStateNormal];
                    
                    friendType = CheckTypeFollowEachOther;
                    
                    
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
