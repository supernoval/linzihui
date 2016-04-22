//
//  HongBaoViewController.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/1/10.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "HongBaoViewController.h"
#import "HongBaoDetailList.h"

@interface HongBaoViewController ()
{
    BmobObject *personAccountOB;
    
}
@end

@implementation HongBaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"邻红包";
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"红包明细" style:UIBarButtonItemStylePlain target:self action:@selector(showDetail)];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    
    [self getpersonAccout];
    
    
}

-(void)showDetail
{
    HongBaoDetailList *_hongBaoDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"HongBaoDetailList"];
    
    [self.navigationController pushViewController:_hongBaoDetail animated:YES];
    
    
}
                                                                                                                
                                                                                                                    
                                                                                                                    

-(void)getpersonAccout
{
    
         [MyProgressHUD showProgress];
    BmobQuery *query = [BmobQuery queryWithClassName:kpersonAccount];
    
    [query whereKey:@"username" equalTo:[BmobUser getCurrentUser].username];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
       
        [MyProgressHUD dismiss];
        
        if (array.count > 0) {
            
            personAccountOB = [array firstObject];
            
            CGFloat totalNum = [[personAccountOB objectForKey:@"totalNum"]floatValue];
            
            _NumLabel.text = [NSString stringWithFormat:@"￥%.2f",totalNum];
            
            
            
        }
        else
        {
            
            _NumLabel.text = [NSString stringWithFormat:@"￥%.2f",0.0];
            
            //新建一条
            [BmobHelper saveTotalAccount:[BmobUser getCurrentUser].username num:0 isincome:YES isDraw:NO  alipayAccount:nil];
            
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)chognzhi:(id)sender {
}

- (IBAction)tixian:(id)sender {
}
@end
