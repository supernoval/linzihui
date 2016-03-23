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




@interface PersonInfoViewController ()<PullViewDelegate>
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
    


    if ([_username isEqualToString:[BmobUser getCurrentUser].username]) {
        
        self.navigationItem.rightBarButtonItem = nil;
        
    }
    
    _cancelAttendButton.hidden = YES;
    
    

    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getData];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
     [_pullView removeFromSuperview];
}
-(void)getData
{
    
    [BmobHelper searchUserWithUsername:_username searchResult:^(NSArray *array) {
       
        if (array) {
            
            _model = [array firstObject];
            
           
            
            
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
        
           self.model.followType = CheckTypeFriend;
        
            _pullView = [[PersonPullView alloc]initwithUserModel:self.model];
        
    }
    else
    {
        
        
        _linhao.text = @"";
        
          _linhaoTitleLabel.hidden = YES;
  
        
        
        //检查是否互相关注
        
      
        [BmobHelper checkFollowTypeWithUserModel:[userArray firstObject] result:^(UserModel *finalModel) {
           
            if (finalModel) {
                
                _model = finalModel;
                
                
                if (_model.followType == CheckTypeFollowEachOther) {
                    
                    [_sendButton setTitle:@"发送好友请求" forState:UIControlStateNormal];
                    
                    friendType = CheckTypeFollowEachOther;
                    
                    
                    _cancelAttendButton.hidden = NO;
                    
                }
                
                else if (_model.followType == CheckTypeOnlyFollowMe)
                {
                    
                    friendType = CheckTypeOnlyFollowMe;
                    
                    [_sendButton setTitle:@"关注" forState:UIControlStateNormal];
                    
                    
                }
                else if (_model.followType == CheckTypeOnlyMyFollow)
                {
                    friendType = CheckTypeOnlyMyFollow;
                    
                    [_sendButton setTitle:@"取消关注" forState:UIControlStateNormal];
                    
                    

                    
                    
                }
                else
                {
                    friendType = CheckTypeOnlyFollowMe;
                    
                    [_sendButton setTitle:@"关注" forState:UIControlStateNormal];
                }
                
                
                _pullView = [[PersonPullView alloc]initwithUserModel:self.model];
                
         
                
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
    else if (_model.followType == CheckTypeOnlyMyFollow)
    {
        [BmobHelper cancelFollowWithUserModel:_model username:[BmobUser getCurrentUser].username result:^(BOOL success) {
           
            if (success) {
                
                NSLog(@"取消关注成功");
                
                friendType = CheckTypeNone;
                
                [_sendButton setTitle:@"关注" forState:UIControlStateNormal];
            }
        }];
    }
    else
    {
        
        

        BmobGeoPoint *otherpoint = _model.location;
        
        CLLocationCoordinate2D otherCoord = CLLocationCoordinate2DMake([[otherpoint valueForKey:@"latitude"]floatValue], [[otherpoint valueForKey:@"longitude"]floatValue]);
        
        CGFloat distance = [CommonMethods distanceFromLocation:otherCoord.latitude longitude:otherCoord.longitude];
        
        NSLog(@"distance:%.2f",distance);
        
        if (distance > 3000) {
            
            [CommonMethods showDefaultErrorString:@"只能关注3公里范围的人"];
            
            return;
            
        }
        
        
        
        [BmobHelper addFollowWithFollowedUserModel:_model result:^(BOOL success) {
           
            
            if (success) {
                
                [CommonMethods showDefaultErrorString:@"关注成功"];
                
                [_sendButton setTitle:@"取消关注" forState:UIControlStateNormal];
                
            
                
            }
        }];
    }
    
}

- (IBAction)cancelAttend:(id)sender {
    
    [BmobHelper cancelFollowWithUserModel:_model username:[BmobUser getCurrentUser].username result:^(BOOL success) {
        
        if (success) {
            
            NSLog(@"取消关注成功");
            
            friendType = CheckTypeNone;
            
            [_sendButton setTitle:@"关注" forState:UIControlStateNormal];
            
            _cancelAttendButton.hidden = YES;
            
        }
    }];
    
    
}
- (IBAction)showInfo:(id)sender {
    
    
    
    

    
    
    if (hadShowed) {
       

        [_pullView removeFromSuperview];
        
        hadShowed = NO;
    }
    
    else
    {
        [self.navigationController.view addSubview:_pullView];
        
        hadShowed = YES;
        
    }
    
    
    
//    FriendEditedTVC *_friendTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FriendEditedTVC"];
//    
//    _friendTVC.model = _model;
//    
//    
//    [self.navigationController pushViewController:_friendTVC animated:YES];
    
    
    
    
    
}


#pragma mark - PullViewDelegate
-(void)didRemoveFriend
{
     [_pullView removeFromSuperview];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)didAddBlackSheet
{
     [_pullView removeFromSuperview];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}




@end
