//
//  AddPhotoView.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/3/28.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "AddPhotoView.h"

@implementation AddPhotoView

-(void)awakeFromNib{
    
}
-(id)initWithFrame:(CGRect)frame
{
    
    if (self == [super initWithFrame:frame]) {
        
        
    }
    
    
    return self;
    
}

-(void)setPhotosArray:(NSMutableArray *)photosArray
{
    NSMutableArray *muArray = [[NSMutableArray alloc]init];
    
    [muArray addObjectsFromArray:photosArray];
    
    //如果图片少于8张就加上加号
    UIImage *addImage = [UIImage imageNamed:@"tianjiazhaopian"];
    
    if (muArray.count < 8) {
        
        [muArray addObject:addImage];
        
    }
    
    
    _photosArray = muArray;
    
    
    
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    if (_photosArray == nil || _photosArray.count == 0) {
        
        UIImage *addImage = [UIImage imageNamed:@"tianjiazhaopian"];
        
        _photosArray =[[NSMutableArray alloc]init];
        
        [_photosArray addObject:addImage];
        
      
    }
    
    
    for (int i = 0 ; i < _photosArray.count; i++) {
        
        
    }
    
    
}

-(void)pickPhoto:(UIButton*)sender
{
    
}



@end
