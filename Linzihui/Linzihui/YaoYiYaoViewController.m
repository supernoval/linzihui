//
//  YaoYiYaoViewController.m
//  Linzihui
//
//  Created by ZhuHaikun on 15/12/6.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//

#import "YaoYiYaoViewController.h"
#import "HuodongTVCViewController.h"

@interface YaoYiYaoViewController ()

@end

@implementation YaoYiYaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"摇一摇";
    
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navbar_return_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(popView)];
    
    
   
}

-(void)popView
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"开始摇");
    

    
    
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"结束");
    
  
    
    [CommonMethods systemSound_1];
    
    
    [self getData];
    
    
    
    
}

-(void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"取消");
    
}

-(void)getData
{
    
    CGFloat latitude = [[NSUserDefaults standardUserDefaults] floatForKey:kCurrentLatitude];
    CGFloat longitude = [[NSUserDefaults standardUserDefaults] floatForKey:kCurrentLongitude];
    
   BmobGeoPoint * _currentPoint = [[BmobGeoPoint alloc]initWithLongitude:longitude WithLatitude:latitude];
    
    BmobQuery *query = [BmobQuery queryWithClassName:kHuoDongTableName];
    
    query.limit = 10;
    
    [query  orderByDescending:@"updatedAt"];
    
    [query includeKey:@"starter"];
    
    [query whereKey:@"location" nearGeoPoint:_currentPoint withinKilometers:3.0];
    
    
    [MyProgressHUD showProgress];
    
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        [MyProgressHUD dismiss];
        
        
        if (!error && array.count > 0) {
            

            BmobObject *ob = [array firstObject];
            
                
            HuoDongModel *model = [[HuoDongModel alloc]init];
                
            NSDictionary *dataDict = [ob valueForKey:@"bmobDataDic"];
                
            [model setValuesForKeysWithDictionary:dataDict];
                
            model.objectId = ob.objectId;
            
                
            NSMutableArray *MuArray = [[NSMutableArray alloc]initWithObjects:model, nil];
            
            HuodongTVCViewController *_huodongTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HuodongTVCViewController"];
            
            
            _huodongTVC.isFromYaoYiYao = YES;
            
            _huodongTVC.dataSource = MuArray;
            
            
            
            [self.navigationController pushViewController:_huodongTVC animated:YES];
            
            
           
            
        }
        else
        {
            
            [CommonMethods showDefaultErrorString:@"未找到对应的活动内容，请重试"];
            
            
        }
        
        
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
