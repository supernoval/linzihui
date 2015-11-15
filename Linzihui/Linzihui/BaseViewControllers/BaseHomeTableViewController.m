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


static CGFloat pullViewWith = 150;
static CGFloat pullViewHeight = 225;

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
    _pullView = [[PullView alloc]initWithFrame:CGRectMake(ScreenWidth - pullViewWith , 64, pullViewWith, 0)];
    _pullView.delegate = self;
    _pullView.clipsToBounds = YES;
    
    
}
#pragma mark -  显示 隐藏下拉选项
-(void)showPullView
{
    
    if (hadShowedPullView) {
        
        hadShowedPullView =NO;
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect originFrame = _pullView.frame;
            
            _pullView.frame = CGRectMake(originFrame.origin.x, originFrame.origin.y, pullViewWith, 0);
            
            
        } completion:^(BOOL finished) {
            
            if (finished) {
                
                [_pullView removeFromSuperview];
                
            }
        }];
    }
    else
    {
     
        hadShowedPullView = YES;
        
        [self.navigationController.view addSubview:_pullView];
        
        
        [UIView animateWithDuration:0.3 animations:^{
       
        CGRect originFrame = _pullView.frame;
        
        _pullView.frame = CGRectMake(originFrame.origin.x, originFrame.origin.y, pullViewWith, pullViewHeight);
        
       
    }];
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
            
        }
            break;
            
        case 2:  //扫一扫
        {
            
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
