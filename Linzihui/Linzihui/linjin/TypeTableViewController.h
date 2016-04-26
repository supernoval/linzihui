//
//  TypeTableViewController.h
//  Linzihui
//
//  Created by ZhuHaikun on 16/4/27.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "BaseTableViewController.h"

typedef void (^TypePickBlock)(NSString*type,NSInteger showType);

@interface TypeTableViewController : BaseTableViewController
{
    
    TypePickBlock _block;
    
}

@property (nonatomic,assign)NSInteger showType; //显示类型: 1 经营类型选择   2覆盖范围

-(void)setblock:(TypePickBlock)block;

@end
