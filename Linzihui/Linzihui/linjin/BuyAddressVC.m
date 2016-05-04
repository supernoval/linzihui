//
//  BuyAddressVC.m
//  Linzihui
//
//  Created by ZhuHaikun on 16/5/4.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "BuyAddressVC.h"

@interface BuyAddressVC ()

@end

@implementation BuyAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
   self.title = @"送货地址";



}


- (IBAction)nextAction:(id)sender {
    
    if (_contactAddress.text.length == 0) {
        
        [CommonMethods showDefaultErrorString:@"请填写送货地址"];
        
        return;
    }
    
    if (_contactPhoneNum.text.length == 0) {
        
        [CommonMethods showDefaultErrorString:@"请填写联系电话"];
        
        return;
    }
    
    if (_contactNameLabel.text.length == 0) {
        
        [CommonMethods showDefaultErrorString:@"请填写联系人姓名"];
        
        return;
    }
    
    [self saveAddress];
    
    
}

-(void)saveAddress
{
    
    [MyProgressHUD showProgress];
    
    NSDictionary *addressDict = @{@"name":_contactNameLabel.text,@"phone":_contactPhoneNum.text,@"address":_contactAddress.text};
    
    BmobObject *ob = [BmobObject objectWithClassName:kAddress];
    
    [ob setObject:_contactAddress.text forKey:@"address"];
    
    [ob setObject:_contactPhoneNum.text forKey:@"phoneNum"];
    
    [ob setObject:_contactNameLabel.text forKey:@"name"];
    
    [ob setObject:[BmobUser getCurrentUser].username forKey:@"username"];
    
    [ob saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
    
        
        [MyProgressHUD dismiss];
        
        if (isSuccessful) {
            
            ConfirmOrderVC *_confirnVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ConfirmOrderVC"];
            
            _confirnVC.shangpinDict = _shangpinDict;
            
            _confirnVC.addressDict = addressDict;
            
            _confirnVC.shangjiaModel = _shangjiaModel;
            _confirnVC.addressOB = ob;
            
            [self.navigationController pushViewController:_confirnVC animated:YES];
            
            
            
        }
        
    }];
    
}
@end
