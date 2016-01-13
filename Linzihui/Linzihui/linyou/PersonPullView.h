//
//  PersonPullView.h
//  Linzihui
//
//  Created by ZhuHaikun on 16/1/12.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface PersonPullView : UIView<UIAlertViewDelegate>

-(id)initwithUserModel:(UserModel*)model;
@property (nonatomic) UserModel *model;

@end
