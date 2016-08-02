//
//  QunBaTypeSelectedTVC.h
//  Linzihui
//
//  Created by Haikun Zhu on 16/8/1.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseTableViewController.h"

typedef void (^QunBaTypeSelectBlock)(NSString*selectedType);


@interface QunBaTypeSelectedTVC : BaseTableViewController
{
    QunBaTypeSelectBlock selectBlock;
    
}

@property (nonatomic,strong) NSArray *typesArray;

@property (nonatomic,strong) NSString *selectedType;

-(void)setBlock:(QunBaTypeSelectBlock)block;




@end
