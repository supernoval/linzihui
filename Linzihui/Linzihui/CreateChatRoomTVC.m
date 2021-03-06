//
//  CreateChatRoomTVC.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/14.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "CreateChatRoomTVC.h"
#import "SetNewGroupNameImageVC.h"


@interface CreateChatRoomTVC ()
{
    NSMutableArray *_buddyListsArray;
    
}
@end

@implementation CreateChatRoomTVC

-(void)setblock:(CreateChatRoomBlock)block
{
    _block = block;
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _buddyListsArray = [[NSMutableArray alloc]init];
    
    self.title = @"发起群聊";
    
    
    [self getBuddyList];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dissmiss)];
    
    self.navigationItem.leftBarButtonItem = item;
    
    UIBarButtonItem *okItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(ok)];
    self.navigationItem.rightBarButtonItem = okItem;
    
    
}

- (void)dissmiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}

-(void)ok
{
    
    
    NSMutableArray *muArray = [[NSMutableArray alloc]init];
    
    for (UserModel *oneModel in _buddyListsArray)
    {
        
        if (oneModel.hadSelected) {
            
            [muArray addObject:oneModel.username];
            
        }
    }
    
    
    if (muArray.count == 0)
    {
        
        
        [CommonMethods showDefaultErrorString:@"请选择朋友"];
        
        return;
    }
    
    
    
    SetNewGroupNameImageVC *_newGroupVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SetNewGroupNameImageVC"];
    
    if (_block) {
        
        _newGroupVC.temBlock = _block;
        
    }
    _newGroupVC.buddyList = _buddyListsArray;
    
    
    [self.navigationController pushViewController:_newGroupVC animated:YES];

    
    
    
}

-(void)getBuddyList
{
    [BmobHelper getBmobBuddyUsers:^(NSArray *array) {
       
        if (array) {
            
            [_buddyListsArray addObjectsFromArray:array];
            
            [self.tableView reloadData];
            
        }
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 1;
    
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *blankView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    
    blankView.backgroundColor = [UIColor clearColor];
    
    return blankView;
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
     return _buddyListsArray.count;
    
   
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
   
    
       return 1;
    
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellId"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        
        UIImageView *headImageView = (UIImageView*)[cell viewWithTag:100];
        
        UILabel *nameLabel = (UILabel*)[cell viewWithTag:101];
        
        UserModel *oneModel = [_buddyListsArray objectAtIndex:indexPath.section];
        
        
        [headImageView sd_setImageWithURL:[NSURL URLWithString:oneModel.headImageURL] placeholderImage:kDefaultHeadImage];
        
        nameLabel.text = oneModel.nickName;
        
        if (!oneModel.nickName) {
            
            nameLabel.text = oneModel.username;
            
            
        }
        
        
        if (oneModel.hadSelected) {
            
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            
        }
        
        
    });
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UserModel * model = [_buddyListsArray objectAtIndex:indexPath.section];
    
    if (model.hadSelected) {
        
        model.hadSelected = NO;
    }
    else
    {
        model.hadSelected = YES;
        
    }
    
    [_buddyListsArray replaceObjectAtIndex:indexPath.section withObject:model];
    
    
    [self.tableView reloadData];
    
    
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
