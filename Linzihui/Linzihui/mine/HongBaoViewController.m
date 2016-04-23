//
//  HongBaoViewController.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/1/10.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "HongBaoViewController.h"
#import "HongBaoDetailList.h"
#import "PayOrder.h"
#import "TixianVC.h"


@interface HongBaoViewController ()<UIAlertViewDelegate>
{
    BmobObject *personAccountOB;
    
    UIAlertView *_chongzhiAlert;
    UIAlertView *_tixianAlert;
    
    CGFloat chongZhiNum;
    
    CGFloat totalNum;
    
    
    
}
@end

@implementation HongBaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"邻红包";
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"红包明细" style:UIBarButtonItemStylePlain target:self action:@selector(showDetail)];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    
 
    
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(paySuccess) name:kPaySucessNotification object:nil];
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
       [self getpersonAccout];
    
}

-(void)paySuccess
{

    [[[UIAlertView alloc]initWithTitle:@"提示" message:@"充值成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show ];
    
    [BmobHelper saveAccountDetail:[BmobUser getCurrentUser].username num:chongZhiNum isincome:YES beizhu:@"账户充值" isDraw:NO alipayAccount:nil];
    
    
    totalNum += chongZhiNum;
    _NumLabel.text = [NSString stringWithFormat:@"￥%.2f",totalNum];
    
    
    
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
            
            totalNum = [[personAccountOB objectForKey:@"totalNum"]floatValue];
            
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
    
    _chongzhiAlert = [[UIAlertView alloc]initWithTitle:@"请输入充值金额" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    _chongzhiAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    UITextField *tf = [_chongzhiAlert textFieldAtIndex:0];
    
    tf.keyboardType = UIKeyboardTypeNumberPad;
    
    [_chongzhiAlert show];
    
    
}

- (IBAction)tixian:(id)sender {
    
  
    TixianVC *_tixianVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TixianVC"];
    _tixianVC.totalMoney = totalNum;
    
    [self.navigationController pushViewController:_tixianVC animated:YES];
    
    
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView == _chongzhiAlert && buttonIndex == 1) {
        
        CGFloat acmount = [[alertView textFieldAtIndex:0].text floatValue];
        if (acmount == 0) {
            
            [CommonMethods showDefaultErrorString:@"请输入大于0的金额"];
            
            return;
            
        }
        
        chongZhiNum = acmount;
        
        
        NSString *username = [BmobUser getCurrentUser].username;
        
        NSString *dateStr = [CommonMethods getNoSpaceDateStr:[NSDate date]];
        
        
        
        PayOrderInfoModel *model = [[PayOrderInfoModel alloc]init];
        
        model.productName = @"账户充值";
        
        model.amount = [NSString stringWithFormat:@"%.2f",acmount];
        
        model.productDescription = [NSString stringWithFormat:@"手机号为%@用户充值",username];
        
        model.out_trade_no = [NSString stringWithFormat:@"%@%@",dateStr,username];
        
        [PayOrder loadALiPaySDK:model];
    
        
    }
    

    
    
}
@end
