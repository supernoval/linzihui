//
//  ErShouTypeTVC.h
//  Linzihui
//
//  Created by ZhuHaikun on 16/3/29.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"

typedef void (^ErShouTypeBlock)(BOOL success,NSString *typeString);


@interface ErShouTypeTVC : BaseTableViewController  
{
    ErShouTypeBlock _block;
    
}

@property (nonatomic,strong) NSString *selectedType;

-(void)setBlock:(ErShouTypeBlock)block;

@end
