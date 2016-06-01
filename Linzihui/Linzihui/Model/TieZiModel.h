//
//  TieZiModel.h
//  Linzihui
//
//  Created by ZhuHaikun on 16/6/1.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "JSONModel.h"

@interface TieZiModel : JSONModel


@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *content;

@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSArray *photos;
@property (nonatomic,strong) NSArray *replay;
@property (nonatomic,strong) NSString *groupId;
@property (nonatomic,strong) BmobObject *publisher;
@property (nonatomic,strong) BmobObject *QunBa;
@property (nonatomic,strong) BmobGeoPoint *location;



@end
