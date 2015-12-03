//
//  BaseTableViewController.m
//  QianShouBang
//
//  Created by Haikun Zhu on 15/7/31.
//  Copyright (c) 2015年 zhuhaikun. All rights reserved.
//

#import "BaseHomeTableViewController.h"
#import "PullView.h"
#import "CreateChatRoomTVC.h"
#import "AddNewFriendsTVC.h"
#import "LBXScanViewController.h"



@interface BaseHomeTableViewController ()<PullViewDelegate>
{
    UITapGestureRecognizer *_tapResign;
    
    PullView *_pullView;
    BOOL hadShowedPullView;
    
    
}
@end

@implementation BaseHomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //去掉底部黑线
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        NSArray *list=self.navigationController.navigationBar.subviews;
        for (id obj in list) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView=(UIImageView *)obj;
                NSArray *list2=imageView.subviews;
                for (id obj2 in list2) {
                    if ([obj2 isKindOfClass:[UIImageView class]]) {
                        UIImageView *imageView2=(UIImageView *)obj2;
                        imageView2.hidden=YES;
                    }
                }
            }
        }
    }
    
    self.view.backgroundColor = kBackgroundColor;
    
    //    self.tabBarController.tabBar.tintColor = TabbarTintColor;
    
    _tapResign = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    
    
    //    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"leftArrow"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
    //
    ////    self.navigationItem.backBarButtonItem = leftButton;
    
    
    [self initWithPullView];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showPullView)];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboarddidShow) name:UIKeyboardDidShowNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
   
    
}

-(void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)keyboarddidShow
{
    [self.view addGestureRecognizer:_tapResign];
    
    
}
-(void)hideKeyboard
{
    [self.view endEditing:YES];
    
    [self.view removeGestureRecognizer:_tapResign];
    
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

-(void)addHeaderRefresh
{
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    
    
    
    
    
}
-(void)headerRefresh
{
    
    
}

-(void)addFooterRefresh
{
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    
    
}
-(void)footerRefresh
{
    
}

-(void)endHeaderRefresh
{
    [self.tableView.header endRefreshing];
    
}
-(void)endFooterRefresh
{
    [self.tableView.footer endRefreshing];
    
}

-(void)removeHeaderRefresh
{
    [self.tableView removeHeader];
    
}
-(void)removeFooterRefresh
{
    [self.tableView removeFooter];
    
}

- (void)initWithPullView
{
    _pullView = [[PullView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _pullView.delegate = self;
    _pullView.clipsToBounds = YES;
    
    
}
#pragma mark -  显示 隐藏下拉选项
-(void)showPullView
{
    
    if (hadShowedPullView) {
        
        hadShowedPullView =NO;
        [_pullView removeFromSuperview];
        
    
    }
    else
    {
     
        hadShowedPullView = YES;
        
        [self.tabBarController.view addSubview:_pullView];
        
        
 
    }
}



#pragma mark - PullViewDelegate
-(void)didSelectedIndex:(NSInteger)index
{
    switch (index) {
        case 0: // 发起群聊
        {
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
            
            
            CreateChatRoomTVC *_createChatRoom = [storyboard  instantiateViewControllerWithIdentifier:@"CreateNav"];
//            CreateChatRoomTVC *_createChatRoom = [[CreateChatRoomTVC alloc]init];
            
            
            [self presentViewController:_createChatRoom animated:YES completion:nil];
            
            
        }
            break;
        case 1:  //添加朋友
        {
            AddNewFriendsTVC *_addNewFriendsTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddNewFriendsTVC"];
            
            _addNewFriendsTVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:_addNewFriendsTVC animated:YES];
        }
            break;
            
        case 2:  //扫一扫
        {
            //设置扫码区域参数
            LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
            style.centerUpOffset = 44;
            style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Inner;
            style.photoframeLineW = 4;
            style.photoframeAngleW = 28;
            style.photoframeAngleH = 16;
            style.isNeedShowRetangle = NO;
            
            style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
            
            style.animationImage = [self createImageWithColor:[UIColor redColor]];
            //非正方形
            //设置矩形宽高比
            style.whRatio = 4.3/2.18;
            
            //离左边和右边距离
            style.xScanRetangleOffset = 30;
            
            
            
            LBXScanViewController *_scanVC = [[LBXScanViewController alloc]init];
            
            _scanVC.style = style;
            _scanVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:_scanVC animated:YES];
            
            
        }
            break;
        case 3:  //摇一摇
        {
            
        }
            break;
        case 4:  //意见反馈
        {
            
        }
            break;
            
        default:
            break;
    }
}

-(void)tapResgin
{
    
    hadShowedPullView = NO;
    
}

- (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
