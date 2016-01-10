/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "LocationViewController.h"

#import "UIViewController+HUD.h"

static LocationViewController *defaultLocation = nil;

@interface LocationViewController () <MKMapViewDelegate,CLLocationManagerDelegate,UISearchBarDelegate>
{
    MKMapView *_mapView;
    MKPointAnnotation *_annotation;
    MKPinAnnotationView *_pinannotation;
    
    CLLocationManager *_locationManager;
    CLLocationCoordinate2D _currentLocationCoordinate;
    BOOL _isSendLocation;
    
    BOOL hadLocated;
    
    
    
}

@property (nonatomic) UISearchBar*mySearchBar;
@property (nonatomic) CLGeocoder *myGeocoder;

@property (strong, nonatomic) NSString *addressString;

@end

@implementation LocationViewController

@synthesize addressString = _addressString;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _isSendLocation = YES;
    }
    
    return self;
}

- (instancetype)initWithLocation:(CLLocationCoordinate2D)locationCoordinate
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _isSendLocation = NO;
        _currentLocationCoordinate = locationCoordinate;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"位置";
    
//    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
//    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
//    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    [self.navigationItem setLeftBarButtonItem:backItem];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    _mapView.delegate = self;
    _mapView.mapType = MKMapTypeStandard;
    _mapView.zoomEnabled = YES;
    [self.view addSubview:_mapView];
    
    
    _mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, 50)];
    _mySearchBar.showsCancelButton = YES;
    
    _mySearchBar.delegate = self;
    
    _myGeocoder = [[CLGeocoder alloc]init];
    
    if (_showSearchBar) {
        
        [self.view addSubview:_mySearchBar];
        
    }
    
    if (_isSendLocation) {
        _mapView.showsUserLocation = YES;//显示当前位置
        
        UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
        [sendButton setTitle:@"选择" forState:UIControlStateNormal];
        [sendButton setTitleColor:[UIColor colorWithRed:32 / 255.0 green:134 / 255.0 blue:158 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [sendButton addTarget:self action:@selector(sendLocation) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:sendButton]];
        self.navigationItem.rightBarButtonItem.enabled = NO;
        
        [self startLocation];
        
        
        UILabel *tips = [CommonMethods LabelWithText:@"*温馨提示:可以移动地图来选定地址" andTextAlgniment:NSTextAlignmentLeft andTextColor:[UIColor darkGrayColor] andTextFont:FONT_18 andFrame:CGRectMake(0,ScreenHeight-30,ScreenWidth,30)];
        tips.backgroundColor = kBackgroundColor;
        
        [self.view addSubview:tips];
        
        
    }
    else{
        [self removeToLocation:_currentLocationCoordinate];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    hadLocated = NO;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - class methods

+ (instancetype)defaultLocation
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultLocation = [[LocationViewController alloc] initWithNibName:nil bundle:nil];
    });
    
    return defaultLocation;
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
    if (!hadLocated) {
        
        [self removeToLocation:userLocation.coordinate];
        
        _mapView.showsUserLocation = YES;//显示当前位置
        
        hadLocated = YES;
    }
   
    
    
    __weak typeof(self) weakSelf = self;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *array, NSError *error) {
        if (!error && array.count > 0 ) {
            CLPlacemark *placemark = [array objectAtIndex:0];
            weakSelf.addressString = placemark.name;
            
          
          
        }
    }];
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    //    [self showHint:NSLocalizedString(@"location.fail", @"locate failure")];
    [self hideHud];
    if (error.code == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:[error.userInfo objectForKey:NSLocalizedRecoverySuggestionErrorKey]
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
            {
                [_locationManager requestWhenInUseAuthorization];
            }
            break;
        case kCLAuthorizationStatusDenied:
        {
            
        }
        default:
        {
           
            [_locationManager startUpdatingLocation];
            
        }
           
            break;
    }
}

#pragma mark - public

- (void)startLocation
{
    if([CLLocationManager locationServicesEnabled]){
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = 5;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;//kCLLocationAccuracyBest;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            [_locationManager requestWhenInUseAuthorization];
        }
        else
        {
            [_locationManager startUpdatingLocation];
            
        }
    }
    
    if (_isSendLocation) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    
    [self showHudInView:self.view hint:NSLocalizedString(@"location.ongoning", @"locating...")];
}

-(void)createAnnotationWithCoords:(CLLocationCoordinate2D)coords
{
    if (_annotation == nil) {
        _annotation = [[MKPointAnnotation alloc] init];
    }
    else{
        [_mapView removeAnnotation:_annotation];
    }
    _annotation.coordinate = coords;
    [_mapView addAnnotation:_annotation];
}

- (void)removeToLocation:(CLLocationCoordinate2D)locationCoordinate
{
    [self hideHud];
    
    _currentLocationCoordinate = locationCoordinate;
    float zoomLevel = 0.01;
    MKCoordinateRegion region = MKCoordinateRegionMake(_currentLocationCoordinate, MKCoordinateSpanMake(zoomLevel, zoomLevel));
    [_mapView setRegion:[_mapView regionThatFits:region] animated:YES];
    
    if (_isSendLocation) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    
    [self createAnnotationWithCoords:_currentLocationCoordinate];
}

- (void)sendLocation
{
    if (_delegate && [_delegate respondsToSelector:@selector(sendLocationLatitude:longitude:andAddress:)]) {
        
        
        
        [_delegate sendLocationLatitude:_currentLocationCoordinate.latitude longitude:_currentLocationCoordinate.longitude andAddress:_addressString];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (!_pinannotation) {
        
        _pinannotation = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"anno"];
        
        _pinannotation.draggable = NO;
        
        
    }
    
    
    
    return _pinannotation;
    
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
{
 
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    CLLocationCoordinate2D centerCoord = mapView.centerCoordinate;
    
    _annotation.coordinate = centerCoord;
    
    _currentLocationCoordinate = centerCoord;
    
    [_mapView removeAnnotation:_annotation];
    
    [_mapView addAnnotation:_annotation];
    
    
    
}

#pragma mark - UISearchBarDelegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    if (searchBar.text.length == 0) {
        
        return;
        
    }
    
    [searchBar resignFirstResponder];
    
    [self getLocationWithAddress:searchBar.text];
    
    
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    searchBar.text = nil;
    
}


-(void)getLocationWithAddress:(NSString*)address
{
    
    CLCircularRegion *region = [[CLCircularRegion alloc]initWithCenter:_mapView.userLocation.coordinate radius:500 identifier:@"circle"];
    
    
    [_myGeocoder geocodeAddressString:address inRegion:region completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if ([placemarks count] > 0 && error == nil){
            NSLog(@"Found %lu placemark(s).", (unsigned long)[placemarks count]);
            CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
            
//            NSLog(@"Longitude = %f", firstPlacemark.location.coordinate.longitude);
//            NSLog(@"Latitude = %f", firstPlacemark.location.coordinate.latitude);
            
            
            for (CLPlacemark *mark in placemarks) {
              
                CGFloat dis = [CommonMethods distanceFromLocation:mark.location.coordinate.latitude longitude:mark.location.coordinate.longitude];
                
                CGFloat firstdis = [CommonMethods distanceFromLocation:firstPlacemark.location.coordinate.latitude longitude:firstPlacemark.location.coordinate.longitude];
                
                NSLog(@"dis:%.2f,firstdis:%.2f",dis,firstdis);
                
                if (firstdis > dis) {
                    
                    firstPlacemark = mark;
                }
                
            }
            
            
            [_mapView setRegion:MKCoordinateRegionMakeWithDistance(firstPlacemark.location.coordinate, 1000, 1000) animated:YES];
            
//            [_mapView setCenterCoordinate:firstPlacemark.location.coordinate animated:YES];
            
            
            
        }
        else if ([placemarks count] == 0 &&
                 error == nil){
            NSLog(@"Found no placemarks.");
        }
        else if (error != nil){
            NSLog(@"An error occurred = %@", error);
        }
    }];
    
}
@end
