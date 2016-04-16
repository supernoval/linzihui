//
//  ErShouJiaGeView.h
//  Linzihui
//
//  Created by ZhuHaikun on 16/4/16.
//  Copyright © 2016年 haikunZhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonMethods.h"

@protocol ErShouJiaGeDelegate <NSObject>

-(void)didInputMSGandPrice:(NSString*)message price:(NSString*)price;


@end
@interface ErShouJiaGeView : UIView<UITextFieldDelegate>

- (IBAction)okAction:(id)sender;

- (IBAction)cancelAction:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *priceTF;

@property (weak, nonatomic) IBOutlet UITextField *msgTF;

@property (nonatomic,assign) id <ErShouJiaGeDelegate> delegate;


-(id)initWithFrame:(CGRect)frame;

@end
