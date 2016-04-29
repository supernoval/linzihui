//
//  HuoDongMapView.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/1/1.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "HuoDongMapView.h"

@interface HuoDongMapView ()
{
    MKPointAnnotation *_point;
    
}
@end

@implementation HuoDongMapView

- (void)viewDidLoad {
    [super viewDidLoad];
    
  
    _point = [[MKPointAnnotation alloc]init];
    
    _point.coordinate = _coord;
    
    [_mapview addAnnotation:_point];
    
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_mapview setRegion:MKCoordinateRegionMakeWithDistance(_coord, 1000, 1000) animated:YES];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}



@end
