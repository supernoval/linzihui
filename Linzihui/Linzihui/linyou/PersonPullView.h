//
//  PersonPullView.h
//  Linzihui
//
//  Created by ZhuHaikun on 16/1/12.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"


@protocol PullViewDelegate <NSObject>

-(void)didRemoveFriend;
-(void)didAddBlackSheet;



@end
@interface PersonPullView : UIView<UIAlertViewDelegate>

@property (nonatomic) id <PullViewDelegate> delegate;


-(id)initwithUserModel:(UserModel*)model;
@property (nonatomic) UserModel *model;
@property (nonatomic) BOOL isFriend;


@end
