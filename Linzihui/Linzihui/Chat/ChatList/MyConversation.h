//
//  MyConversation.h
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/12.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "EMConversation.h"
#import "JSONModel.h"
@interface MyConversation : JSONModel

-(id)init;


@property (nonatomic,strong) EMConversation *converstion;
@property (nonatomic,strong) NSString *headImageURL;
@property (nonatomic,strong) NSString *nickName;

@end
