//
//  HuoDongMapView.h
//  Linzihui
//
//  Created by ZhuHaikun on 16/1/1.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "BaseViewController.h"
#import <MapKit/MapKit.h>
@interface HuoDongMapView : BaseViewController

@property (weak, nonatomic) IBOutlet MKMapView *mapview;

@property (nonatomic,assign) CLLocationCoordinate2D coord;



@end
