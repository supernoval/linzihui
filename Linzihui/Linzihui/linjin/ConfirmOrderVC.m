//
//  ConfirmOrderVC.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/5/4.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "ConfirmOrderVC.h"

@interface ConfirmOrderVC ()
{
    BmobObject *buyShangpinOB;
    
}
@end

@implementation ConfirmOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认订单";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buySuccess) name:kPaySucessNotification object:nil];
    
    
    [self showData];
    
    
    
    
}



-(void)showData
{
    _nameLabel.text = [_shangpinDict objectForKey:@"des"];
    
    _priceLabel.text = [NSString stringWithFormat:@"%.2f元",[[_shangpinDict objectForKey:@"price"]floatValue]];
    
    [_photoImageView sd_setImageWithURL:[NSURL URLWithString:[_shangpinDict objectForKey:@"photos"]] placeholderImage:kDefaultHeadImage];
    
    
    _contactNameLabel.text = [NSString stringWithFormat:@"姓名:%@",[_addressDict objectForKey:@"name"]];
    
    _contactPhoneLabel.text = [NSString stringWithFormat:@"联系电话:%@",[_addressDict objectForKey:@"phone"]];
    
    _contactAddressLabel.text = [NSString stringWithFormat:@"详细地址:%@",[_addressDict objectForKey:@"address"]];
    
    
    
}



- (IBAction)ok:(id)sender
{
    
    
    [MyProgressHUD showProgress];
    
    NSString *username = [BmobUser getCurrentUser].username;
    
    BmobObject *shangpinOB = [BmobObject objectWithoutDatatWithClassName:kShangPin objectId:[_shangpinDict objectForKey:@"objectId"]];
    
    BmobObject *shangjiaOB = [BmobObject objectWithoutDatatWithClassName:kShangJia objectId:[_shangjiaModel objectId]];
    
     buyShangpinOB = [BmobObject objectWithClassName:kBuyShangPin];
    
    [buyShangpinOB setObject:shangpinOB forKey:@"shangpin"];
    [buyShangpinOB setObject:shangjiaOB forKey:@"shangjia"];
    [buyShangpinOB setObject:_addressOB forKey:@"address"];
    
    [buyShangpinOB setObject:[_shangpinDict objectForKey:@"name"] forKey:@"shangpinName"];
    [buyShangpinOB setObject:[_shangpinDict objectForKey:@"photos"] forKey:@"shangpinPhoto"];
    [buyShangpinOB setObject:[_shangpinDict objectForKey:@"price"] forKey:@"price"];
    
    [buyShangpinOB setObject:[NSNumber numberWithInteger:0] forKey:@"status"];
    
    [buyShangpinOB setObject:username forKey:@"username"];
    
    [buyShangpinOB saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        
        [MyProgressHUD dismiss];
        
        if (isSuccessful) {
            
            
            [self payOrder];
            
            
        }
        else
        {
            
            [CommonMethods showDefaultErrorString:@"订单提交失败，请重试"];
            
            NSLog(@"fail:%@",error);
            
        }
    }];
    
  
    

    
    
}


-(void)buySuccess
{
    
    [MyProgressHUD showProgress];
    
   [buyShangpinOB setObject:[NSNumber numberWithInteger:1] forKey:@"status"];
    
    [buyShangpinOB updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
       
        [MyProgressHUD dismiss];
        
        
        [CommonMethods showDefaultErrorString:@"购买成功"];
        if (isSuccessful) {
            
            for (UIViewController *vc in self.navigationController.viewControllers) {
                
                if ([vc isKindOfClass:[ShangPinTVC class]]) {
                    
                    [self.navigationController popToViewController:vc animated:YES];
                    
                }
            }
        }
    }];
    
 
    

}


-(void)payOrder
{
    

    NSString *dateStr = [CommonMethods getNoSpaceDateStr:[NSDate date]];
    NSString *out_trade_no = [NSString stringWithFormat:@"%@%@",dateStr,[BmobUser getCurrentUser].username];
    
    
    PayOrderInfoModel *model = [[PayOrderInfoModel alloc]init];
    
    model.productName = [_shangpinDict objectForKey:@"name"];
    
    model.productDescription = @"购买邻近商品";
    
    model.amount =  [NSString stringWithFormat:@"%.2f",[[_shangpinDict objectForKey:@"price"]floatValue]];
    model.out_trade_no = out_trade_no;
    
    [PayOrder loadALiPaySDK:model];
    
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPaySucessNotification object:nil];
    
    
}
@end
