//
//  BaseBmobModel.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/8.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//
  
#import "BaseBmobModel.h"
#import "Constants.h"
#import "BmobDBConstants.h"

@implementation BaseBmobModel

-(id)initwithBmobObject:(BmobObject*)object
{
    
    if (self == [super init]) {
        
        
        NSDictionary *dataDic = [object valueForKey:kBmobDataDic];
        
        [self setValuesForKeysWithDictionary:dataDic];
        
        
    }
    
    return self;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"undefineKey:%@",key);
    
    
}
@end
