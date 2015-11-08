//
//  BaseBmobModel.h
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/8.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "JSONModel.h"
#import <BmobSDK/Bmob.h>

@interface BaseBmobModel : JSONModel

@property (nonatomic,strong)  NSString *createdAt;
@property (nonatomic,strong)  NSString *updatedAt;
@property (nonatomic,strong)  NSString *objectId;

-(id)initwithBmobObject:(BmobObject*)object;


@end
