//
//  AttendUserModel.h
//  Linzihui
//
//  Created by ZhuHaikun on 15/12/1.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "JSONModel.h"

@interface AttendUserModel : JSONModel


@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong ) NSString *nickName;
@property (nonatomic,strong)  NSString *headImageURL;
@property (nonatomic,assign)  float latitude;
@property (nonatomic,assign)  float longitude;




@end
