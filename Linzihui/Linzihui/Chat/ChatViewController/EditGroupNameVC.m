//
//  EditGroupNameVC.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/12/12.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "EditGroupNameVC.h"

@interface EditGroupNameVC ()

@end

@implementation EditGroupNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    _editTF.text = _groupSubTitle;
    
    [_editTF becomeFirstResponder];
    
    
}




- (IBAction)saveEdited:(id)sender {
    
    
    if (_editTF.text.length ==0) {
        
        [CommonMethods showDefaultErrorString:@"请输入群名称"];
        
        return;
    }
    
    
    
    //修改环信群名称
    [[EaseMob sharedInstance].chatManager asyncChangeGroupSubject:_editTF.text forGroup:_groupId];
    
    NSString *subTitle = _editTF.text;
    
    
    BmobQuery *query = [BmobQuery queryWithClassName:kChatGroupTableName];
    
    [query whereKey:@"groupId" equalTo:_groupId];
    
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
       
        if (!error && array) {
            
            BmobObject *ob = [array firstObject];
            
            [ob setObject:subTitle forKey:@"subTitle"];
            
            [ob updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
               
                if (isSuccessful) {
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:kChangeGroupSubTitleNoti object:nil userInfo:@{@"subTitle":subTitle}];
                    
                    if (_block) {
                        
                        _block(subTitle);
                        
                    }
                    
                    
                    
                    [CommonMethods showDefaultErrorString:@"修改成功"];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }
            }];
        }
        
    }];
    
}
-(void)setBlock:(SetName)block
{
    _block = block;
    
}
@end
