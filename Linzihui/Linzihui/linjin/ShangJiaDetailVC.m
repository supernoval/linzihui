//
//  ShangJiaDetailVC.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/4/29.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "ShangJiaDetailVC.h"
#import "HuoDongMapView.h"
#import "ChatViewController.h"
#import "WechatShareController.h"
#import "ShengHuoQuanTVC.h"
#import "ShangJiaCommentTVC.h"
#import "PingJiaVC.h"
#import "BuyHistoryCell.h"
#import "BuyShangPinModel.h"
#import "EditeShangJiaTVC.h"
#import "CurrentBuyTableView.h"



@interface ShangJiaDetailVC ()<UIActionSheetDelegate,UIAlertViewDelegate>
{
     UIToolbar *_myToolBar;
    
    UIAlertView *_jubaoAlertView;
    
    NSMutableArray *_muHistoryArray;
    
    
    UIBarButtonItem *common ; //关注按钮
    BOOL hadGuanzhu ; //是否已关注
}
@end

@implementation ShangJiaDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"商家详情";
    
    self.headView.frame = CGRectMake(0, 0, ScreenWidth, 100);
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _muHistoryArray = [[NSMutableArray alloc]init];
    
    [self initHeadView];
    
    [self initBottomView];
    
    [self getCurrentBuy];
    
    [self checkFollow];
    
    
    if ([_model.username isEqualToString:[BmobUser getCurrentUser].username]) {
        
        UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editeShangJia)];
        
        self.navigationItem.rightBarButtonItem = button;
        
        
    }
    

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.view addSubview:_myToolBar];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_myToolBar removeFromSuperview];
    
}

-(void)checkFollow
{
    BmobQuery *query = [BmobQuery queryForUser];
    
    [query whereKey:@"username" equalTo:_model.username];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if (array.count > 0) {
            
            BmobObject *ob = [array firstObject];
            
            UserModel *_userModel = [[UserModel alloc]init];
            
            NSDictionary *dict = [ob valueForKey:kBmobDataDic];
            
            [_userModel setValuesForKeysWithDictionary:dict];
            
            [BmobHelper checkFollowTypeWithUserModel:_userModel result:^(UserModel *finalModel) {
               
                if (finalModel.followType == CheckTypeOnlyMyFollow  || finalModel.followType== CheckTypeFollowEachOther) {
                    
                    
                    hadGuanzhu = YES;
                    
                    [common setTitle:@"取消关注"];
                    
                }
                
            }];
        }
    }];
    
 
}

#pragma mark - 编辑商家
-(void)editeShangJia
{
    EditeShangJiaTVC *edit = [self.storyboard instantiateViewControllerWithIdentifier:@"EditeShangJiaTVC"];
    
    edit.model = _model;
    
    [self.navigationController pushViewController:edit animated:YES];
    
}

#pragma mark - 获取最近成交
-(void)getCurrentBuy
{
    BmobQuery *queryhist = [BmobQuery queryWithClassName:kBuyShangPin];
    
    [queryhist whereKey:@"username" equalTo:_model.username];
    [queryhist includeKey:@"address"];
    [queryhist whereKey:@"status" greaterThan:[NSNumber numberWithInt:1]];
    
    
    [queryhist findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
       
        if (array.count > 0) {
            
            for (int i = 0; i< array.count; i++) {
                
                BmobObject *ob = [array objectAtIndex:i];
                
                BuyShangPinModel *model = [[BuyShangPinModel alloc]init];
                
                [model setValuesForKeysWithDictionary:[ob valueForKey:kBmobDataDic]];
                
                model.createdAt = ob.createdAt;
                
                [_muHistoryArray addObject:model];
                
                
                
            }
            
            [self.tableView reloadData];
            
            
        }
        
    }];
}

-(void)initBottomView
{
    
    _myToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, ScreenHeight - 44, ScreenWidth, 44)];
    
    UIBarButtonItem *zixun = [[UIBarButtonItem alloc]initWithTitle:@"咨询" style:UIBarButtonItemStylePlain target:self action:@selector(ask)];
    
    
    
    common = [[UIBarButtonItem alloc]initWithTitle:@"关注" style:UIBarButtonItemStylePlain target:self action:@selector(guanzhu)];
    
     UIBarButtonItem *pinjia = [[UIBarButtonItem alloc]initWithTitle:@"评价" style:UIBarButtonItemStylePlain target:self action:@selector(pinjia)];
    
    UIBarButtonItem *fenxiang = [[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(fenxiang)];
    
    UIBarButtonItem *jubao  = [[UIBarButtonItem alloc]initWithTitle:@"举报"style:UIBarButtonItemStylePlain target:self action:@selector(jubao)];
    
    
    UIBarButtonItem *flex = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *flex1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *flex2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *flex3 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *flex4 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
    
    _myToolBar.items = @[flex,zixun,flex3,common,flex1,pinjia,flex1,fenxiang,flex2,jubao,flex4];
    
    _myToolBar.tintColor = kBlueBackColor;
}

#pragma mark - 关注
-(void)guanzhu
{
    
    if (hadGuanzhu) {
        
        BmobQuery *query = [BmobQuery queryForUser];
        
        [query whereKey:@"username" equalTo:_model.username];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            
            if (array.count > 0) {
                
                BmobObject *ob = [array firstObject];
                
                UserModel *_userModel = [[UserModel alloc]init];
                
                NSDictionary *dict = [ob valueForKey:kBmobDataDic];
                
                [_userModel setValuesForKeysWithDictionary:dict];
                
               [BmobHelper cancelFollowWithUserModel:_userModel username:[BmobUser getCurrentUser].username result:^(BOOL success) {
                  
                   
                   
                   [common setTitle:@"关注"];
                   hadGuanzhu = NO;
                   [CommonMethods showDefaultErrorString:@"取消关注成功"];
                   
               }];
            }
        }];
    }
    else
    {
        BmobQuery *query = [BmobQuery queryForUser];
        
        [query whereKey:@"username" equalTo:_model.username];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            
            if (array.count > 0) {
                
                BmobObject *ob = [array firstObject];
                
                UserModel *_userModel = [[UserModel alloc]init];
                
                NSDictionary *dict = [ob valueForKey:kBmobDataDic];
                
                [_userModel setValuesForKeysWithDictionary:dict];
                
                [BmobHelper addFollowWithFollowedUserModel:_userModel result:^(BOOL success) {
                    
                    if (success) {
                        
                        [common setTitle:@"取消关注"];
                        hadGuanzhu = YES;
                        [CommonMethods showDefaultErrorString:@"关注成功"];
                        
                    }
                }];
            }
        }];
    }


}

#pragma mark - 评价
-(void)pinjia
{
    
    PingJiaVC *pingjiaVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PingJiaVC"];
    

    pingjiaVC.shangjiausername = _model.username;
    
    
    
    [self.navigationController pushViewController:pingjiaVC animated:YES];
    
}
#pragma mark - 咨询
-(void)ask
{
    
    
    UserModel *model = [[UserModel alloc]init];
    
    
    NSString *nickName = [_model.publisher objectForKey:@"nickName"];
    NSString *username = _model.username;
    
    
    
    if ([username isEqualToString:[BmobUser getCurrentUser].username]) {
        
        [CommonMethods showDefaultErrorString:@"您自己发布的信息，无法与自己聊天"];
        
        return;
        
    }
    
    model.username = username;
    model.nickName = nickName;
    
    
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

#pragma mark - 分享
- (void)fenxiang
{
    UIActionSheet *_actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    
    [_actionSheet addButtonWithTitle:@"分享到微信"];
    [_actionSheet addButtonWithTitle:@"分享到QQ"];
    
    [_actionSheet addButtonWithTitle:@"取消"];
    
    
    _actionSheet.cancelButtonIndex = 2;
    
    [_actionSheet showInView:self.view];
    
    
    
}

#pragma mark - 举报
- (void)jubao
{
    _jubaoAlertView = [[UIAlertView alloc]initWithTitle:nil message:@"确认要举报该用户吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"举报", nil];
    
    [_jubaoAlertView show];
    
    
}



-(void)initHeadView
{
    [self.photoView sd_setImageWithURL:[NSURL URLWithString:_model.photo] placeholderImage:kDefaultHeadImage];
    
    
    self.nameLabel.text = _model.name;
    
    self.addressLabel.text = [NSString stringWithFormat:@"地址:%@",_model.address];
    
    
    
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
  
    return 1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
 
    
    
    return 60;
    
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
  
    
    
    return 1;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
//    if (section == 2) {
//        
//        UILabel *historyLabel = [CommonMethods labelWithText:@"   最近成交" textColor: kBlueBackColor font:FONT_15 textAligment:NSTextAlignmentLeft frame:CGRectMake(0, 0, ScreenWidth, 50)];
//        
//        return historyLabel;
//        
//    }
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    
    view.backgroundColor = [UIColor clearColor];
    
    
    return view;
    
}

#pragma mark - UITableViewDataSource
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    if (indexPath.section == 3) {
//        
//        BuyHistoryCell *historyCell = [tableView dequeueReusableCellWithIdentifier:@"BuyHistoryCell"];
//        
//        if (indexPath.row < _muHistoryArray.count) {
//            
//            BuyShangPinModel *model = [_muHistoryArray objectAtIndex:indexPath.row];
//            
//            historyCell.timeLabel.text = [CommonMethods getYYYYMMddHHmmssDateStr:model.createdAt];
//            historyCell.shangpinnamelabel.text = model.shangpinName;
//            historyCell.addresslabel.text = [model.address objectForKey:@"address"];
//            historyCell.priceLabel.text = [NSString stringWithFormat:@"%.2f元",model.price];
//            
//            
//            
//        }
//        
//        return historyCell;
//        
//        
//        
//    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid"];
    
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellid"];
        
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    switch (indexPath.section) {
        case 0:
        {
            cell.textLabel.text = @"商家动态";
        }
            break;
        case 1:
        {
            cell.textLabel.text = @"评论";
        }
            break;
        case 2:
        {
            cell.textLabel.text = @"商品";
        }
            break;
        case 3:
        {
            cell.textLabel.text = @"最近成交";
            
        }
      
            
        default:
            break;
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            ShengHuoQuanTVC *_shenghuoquanTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ShengHuoQuanTVC"];
            _shenghuoquanTVC.isShuRenQuan = 4;
            _shenghuoquanTVC.username = [_model.publisher objectForKey:@"username"];
            
            [self.navigationController pushViewController:_shenghuoquanTVC animated:YES];
            
            
        }
            break;
        case 1:
        {
            ShangJiaCommentTVC *_commentTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ShangJiaCommentTVC"];
            
            _commentTVC.model = _model;
            
            
            [self.navigationController pushViewController:_commentTVC animated:YES];
            
            
            
        }
            break;
        case 2:
        {
            ShangPinTVC *_shangpinTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ShangPinTVC"];
            _shangpinTVC.model = _model;
            
            [self.navigationController pushViewController:_shangpinTVC animated:YES];
            
            
        }
            break;
        case 3:
        {
            CurrentBuyTableView *_currentBuy = [self.storyboard instantiateViewControllerWithIdentifier:@"CurrentBuyTableView"];
            
            _currentBuy.model = _model;
            
            [self.navigationController pushViewController:_currentBuy animated:YES];
            
        }
            
            
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark - 显示地图
- (IBAction)showMap:(id)sender {
    
    HuoDongMapView *_mapView = [self.storyboard instantiateViewControllerWithIdentifier:@"HuoDongMapView"];
    
    _mapView.coord = CLLocationCoordinate2DMake([[_model.location valueForKey:@"latitude"]floatValue], [[_model.location valueForKey:@"longitude"]floatValue]);
    
    [self.navigationController pushViewController:_mapView animated:YES];
    
}



#pragma makr - 切换
- (IBAction)switchAction:(id)sender {
    
    
}

#pragma mark -  UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex < 2) {
        
        WechatShareController *_shareVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WechatShareController"];
        
        _shareVC.hidesBottomBarWhenPushed = YES;
        _shareVC.shareType = buttonIndex + 1;
        
        [self.navigationController pushViewController:_shareVC animated:YES];
        
    }
}

#pragma mark- UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == _jubaoAlertView && buttonIndex == 1) {
        
        
        BmobObject *ob = [BmobObject objectWithoutDataWithClassName:kShangJia objectId:_model.objectId];
        
        
        [ob addObjectsFromArray:@[[BmobUser getCurrentUser].username] forKey:@"jubao"];
        
        [ob updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            
            if (isSuccessful) {
                
                [CommonMethods showDefaultErrorString:@"举报成功"];
                
                
            }
        }];
        
    }
    
    
    
}


@end
