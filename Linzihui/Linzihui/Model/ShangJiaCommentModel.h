//
//  ShangJiaCommentModel.h
//  Linzihui
//
//  Created by ZhuHaikun on 16/5/11.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "JSONModel.h"

@interface ShangJiaCommentModel : JSONModel

@property (nonatomic,strong) NSString *shangjia_username;
@property (nonatomic,strong) BmobObject *publisher;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,assign) NSInteger star_num;

@end
