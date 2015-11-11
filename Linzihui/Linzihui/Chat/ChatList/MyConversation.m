//
//  MyConversation.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/12.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "MyConversation.h"
#import "ConstantsHeaders.h"

@implementation MyConversation

-(id)init
{
    if (self == [super init]) {
        
        
    }
    
    return self;
    
}

//-(void)setConverstion:(EMConversation *)converstion
//{
//    self.converstion = converstion;
//    
//    [BmobHelper searchUserWithUsername:converstion.chatter searchResult:^(NSArray *array) {
//        
//        if (array) {
//            
//            UserModel *obj = [array firstObject];
//            
//            self.nickName = obj.nickName;
//            self.headImageURL = obj.headImageURL;
//            
//            
//            
//        }
//        
//        }];
//        
//    
//}

@end
