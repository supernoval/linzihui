//
//  SearchNearByViewController.h
//  Linzihui
//
//  Created by ZhuHaikun on 16/1/16.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "BaseViewController.h"
#import <BaiduMapAPI_Search/BMKPoiSearch.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
#import <BaiduMapAPI_Cloud/BMKCloudSearch.h>

typedef  void (^SearchBlock)(NSString*xiaoqu);

@interface SearchNearByViewController : BaseViewController
{
    
    SearchBlock _block;
}

-(void)setBlock:(SearchBlock)block;


@end
