//
//  PersonInfoViewController.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/12/23.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "ChatViewController.h"

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
    
}
@property (nonatomic) UserModel *model;

@end

@implementation PersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"详细资料";
    [self getData];
    
    
    
    
}


-(void)getData
{
    
    [BmobHelper searchUserWithUsername:_username searchResult:^(NSArray *array) {
       
        if (array) {
            
            _model = [array firstObject];
            
            
            [_headImageView sd_setImageWithURL:[NSURL URLWithString:_model.headImageURL] placeholderImage:kDefaultHeadImage];
            
            _nickName.text = _model.nickName;
            
            _linhao.text = _model.username;
            
            _yaoqingma.text = _model.inviteCode;
            
            _qianming.text = _model.selfComment;
            
            
            [self checkGuanZhu:array];
            
         
            
        }
    }];
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
                   
                    _sendButton.hidden = YES;
                    
                    friendType = CheckTypeOnlyFollowMe;
                    
                    
                    
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
    else
    {
        [EMHelper sendFriendRequestWithBuddyName:_username Mesage:@"请求加你好友"];
        
    }
    
}
@end
