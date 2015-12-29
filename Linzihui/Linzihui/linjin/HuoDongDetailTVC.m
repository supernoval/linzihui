//
//  HuoDongDetailTVC.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/12/18.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "HuoDongDetailTVC.h"
#import "PhotoCell.h"
#import "EaseMob.h"
#import "EMHelper.h"
#import "ChatViewController.h"

@interface HuoDongDetailTVC ()

@end

@implementation HuoDongDetailTVC

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.title = @"活动详情";
    
    [self initdata];
    
    
    
    
}

-(void)initdata
{
    
     _headerView.frame = CGRectMake(0, 0, ScreenWidth, 450);
    
    _titleLabel.text = _huodong.title;
    
    _addressLabel.text = _huodong.address;
    
    _timeLabel.text = [CommonMethods getYYYYMMddhhmmDateStr:_huodong.startTime];
    
    _feelabel.text = _huodong.feeNum;
    
    _distanceLabel.text = [CommonMethods distanceStringWithLatitude:[[_huodong.location valueForKey:@"latitude"]floatValue] longitude:[[_huodong.location valueForKey:@"longitude"]floatValue]];
    _publisher.text = _huodong.realName ;
    
    _detailLabel.text = _huodong.content;
    
    _tedianLabel.text = _huodong.TeDian;
    
    _liuchengLabel.text = _huodong.LiuCheng;
    
    _shixianglabel.text = _huodong.ZhuYiShiXiang;
    
    _endRegistTimeLabel.text = [CommonMethods getYYYYMMddhhmmDateStr: _huodong.endRegistTime];
    
     _numLabel.text = [NSString stringWithFormat:@"%ld人已参加",(long)_huodong.AttendUsers.count];
    
    
   
    
    NSInteger status = [CommonMethods activityStatusWithStartTime:_huodong.startTime endTime:_huodong.endTime];
    
    if (status == 1) {
        
        
        _statusLabel.text =[NSString stringWithFormat:@"离活动开始:%@",[CommonMethods timeStringFromNow:_huodong.startTime]];
        
        
        
        
    }
    if (status == 2) {
        
        _statusLabel.text = @"活动进行中";
    }
    if (status == 3) {
        
        _statusLabel.text = @"活动已结束";
        
        
    }
    
    if (_huodong.groupId.length == 0) {
        
        _checkButton.hidden = YES;
        
    }
    else
    {
        _checkButton.hidden = NO;
        
        
    }
    
    
    if ([self hadAttend:_huodong]) {
        
        _attendButton.enabled = NO;
        
        [_attendButton setTitle:@"已报名" forState:UIControlStateNormal];
        
    }
    
    else
    {
        
        
        
        _attendButton.enabled = YES;
        
        [_attendButton setTitle:@"报名参加" forState:UIControlStateNormal];
        
        
      
        
        
    }
    
    
    NSInteger registStatus = [CommonMethods activityRegistStatus:_huodong.endRegistTime];
    
    if (registStatus == 2) {
        
        _attendButton.enabled = NO;
        
        [_attendButton setTitle:@"报名已截止" forState:UIControlStateNormal];
        
        
    }
    else
    {
        _attendButton.enabled = YES;
        
      
        
    }
    
    
    if ([[BmobUser getCurrentUser].username isEqualToString:[_huodong.starter objectForKey:@"username"]]) {
        
        _attendButton.enabled = NO;
        
    }
    
    
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        CGFloat photoViewHeight = 0;
        
        NSArray *imgs = _huodong.photoURL;
        
        long imageCount = imgs.count;
        int perRowImageCount = ((imageCount == 4) ? 2 : 3);
        CGFloat perRowImageCountF = (CGFloat)perRowImageCount;
        int totalRowCount = ceil(imageCount / perRowImageCountF);
        
        photoViewHeight = 95 * totalRowCount;
        
        return photoViewHeight;
        
        
    }
    
 
    
    
    
    return 50;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 1;
    }
    
    return _huodong.AttendUsers.count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section == 0) {
        
        PhotoCell *_photoCell = [tableView dequeueReusableCellWithIdentifier:@"photoCell"];
        
        _photoCell.imagesView.photoItemArray = _huodong.photoURL;
        
        
        
        
        
        return _photoCell;
        
    }
    
    

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellId"];
    

    dispatch_async(dispatch_get_main_queue(), ^{
       
        
        NSArray *personsArray = _huodong.AttendUsers;
        
        NSDictionary *onePerson = [personsArray objectAtIndex:indexPath.row];
        
        AttendUserModel * _usermodel = [[AttendUserModel alloc]init];
        
        [_usermodel setValuesForKeysWithDictionary:onePerson];
        
        UIImageView *imageView = (UIImageView*)[cell viewWithTag:100];
        
        
        UILabel *label = (UILabel*)[cell viewWithTag:101];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:_usermodel.headImageURL] placeholderImage:kDefaultHeadImage];
        
        
        label.text = _usermodel.nickName;
        
        if (!_usermodel.nickName) {
            
            label.text = _usermodel.userName;
            
        }
        
        
        
        
        
        
    });
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



-(BOOL)hadAttend:(HuoDongModel*)model
{
    BOOL hadAttend = NO;
    NSArray *dataArray = model.AttendUsers;
    
    BmobUser *currentUser = [BmobUser getCurrentUser];
    
    
    for (NSDictionary *dict in dataArray) {
        
        AttendUserModel *_attendmodel = [[AttendUserModel alloc]init];
        
        [_attendmodel setValuesForKeysWithDictionary:dict];
        
        
        if ([currentUser.username isEqualToString:_attendmodel.userName]) {
            
            hadAttend = YES;
            
            
        }
    }
    
    
    
    
    
    
    return hadAttend;
    
}





- (IBAction)attendAction:(id)sender {
    
    
    BmobObject *_ob  = [BmobObject objectWithoutDatatWithClassName:kHuoDongTableName objectId:_huodong.objectId];
    
    
    UserModel *currentUser = [BmobHelper getCurrentUserModel];
    
    NSString *nick = currentUser.nickName;
    if (!nick) {
        
        nick = @"";
    }
    NSString *headImageURL = currentUser.headImageURL;
    
    if (!headImageURL) {
        
        headImageURL = @"";
        
    }
    BmobGeoPoint *location = currentUser.location;
    
    CGFloat latitude = [[location valueForKey:@"latitude"] floatValue];
    
    CGFloat longitude = [[location valueForKey:@"longitude"]floatValue];
    
    AttendUserModel *_attendModel = [[AttendUserModel alloc]init];
    
    _attendModel.nickName = nick;
    _attendModel.userName = currentUser.username;
    _attendModel.headImageURL = headImageURL;
    _attendModel.latitude = latitude;
    _attendModel.longitude = longitude;
    
    NSDictionary *param = [_attendModel toDictionary];
    
    
    [_ob addObjectsFromArray:@[param] forKey:@"AttendUsers"];
    
    [_ob updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        
        if (isSuccessful) {
            
            NSLog(@"updateSuccess");
            
            [CommonMethods showDefaultErrorString:@"报名成功"];
            
            
            NSMutableArray *_muarray = [[NSMutableArray alloc]initWithArray:_huodong.AttendUsers];
            
            [_muarray addObject:param];
            
            
            _huodong.AttendUsers = _muarray;
            
            
            [self.tableView reloadData];
            
            
            
            //将objectId 添加到user表  attendAcivities
            
            BmobUser *currentUser = [BmobUser getCurrentUser];
            
            [currentUser addObjectsFromArray:@[_ob.objectId] forKey:@"attendActivities"];
            
            [currentUser updateInBackground];
            
            
            
            
        }
        else
        {
            NSLog(@"error:%@",error);
            
            [CommonMethods showDefaultErrorString:@"报名失败"];
            
        }
    }];
    
    
}


#pragma mark -加群讨论

- (IBAction)checkAction:(id)sender {
    
    
    [EMHelper joinGroup:_huodong.groupId username:nil result:^(BOOL success, EMGroup *group) {
       
        if (success) {
            
            
           [BmobHelper getGroupInfo:group.groupId result:^(BOOL sccess, GroupChatModel *model) {
              
               if (success) {
                   
                   
             
            ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:group.groupId isGroup:YES];
            if (model.subTitle) {
               
                chatVC.title =model.subTitle;
//                chatVC.subTitle = model.nickName;
            }else
            {
                chatVC.title = model.groupId;
                
//                    chatVC.subTitle = model.nickName;
                
                }
               
                chatVC.group = group;
                           
                chatVC.hidesBottomBarWhenPushed = YES;
                           
                [self.navigationController pushViewController:chatVC animated:YES];
               
                 }
           }];
            

            
            
        }
    }];
    
    
    
    
}
- (IBAction)zixunAction:(id)sender {
}

- (IBAction)pinglunAction:(id)sender {
}

- (IBAction)qiandao:(id)sender {
}

- (IBAction)yaoqing:(id)sender {
}
@end
