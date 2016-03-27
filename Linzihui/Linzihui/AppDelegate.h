//
//  AppDelegate.h
//  Linzihui
//
//  Created by ZhuHaikun on 15/10/31.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import "Reachability.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    BMKMapManager* _mapManager;
}
@property (strong, nonatomic) UIWindow *window;


@end

