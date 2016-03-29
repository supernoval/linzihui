//
//  AddPhotoView.h
//  Linzihui
//
//  Created by ZhuHaikun on 16/3/28.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonMethods.h"

@protocol AddPhotoViewDelegate <NSObject>

-(void)didChangePhotos:(NSArray*)photos;


@end
@interface AddPhotoView : UIView<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    NSMutableArray *muPhotosArray ;  //放包括加号在内的图片
    
}

@property (nonatomic,assign) id < AddPhotoViewDelegate> delegate;


-(id)initWithFrame:(CGRect)frame;


//现有的photos 
@property (nonatomic,strong) NSMutableArray *photosArray;



@end
