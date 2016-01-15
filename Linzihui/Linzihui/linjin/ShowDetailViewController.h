//
//  ShowDetailViewController.h
//  Linzihui
//
//  Created by ZhuHaikun on 16/1/15.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import "BaseViewController.h"

@interface ShowDetailViewController : BaseViewController


@property (nonatomic) NSString *detail;

@property (weak, nonatomic) IBOutlet UITextView *detailTF;


@end
