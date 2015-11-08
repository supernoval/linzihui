//
//  Constants.h
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/1.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//



#pragma mark - bmob app id
#define  kBmobApplicationID       @"953e584ada055ec7250cbc57f589f308"

#pragma mark -  环信
#define kEseamobAppKey            @"shiwaitaoyuan#linzihui"

#pragma mark - 短信验证  shareSDK
#define kShareSMSAppKey           @"bda4046e6c7c"
#define kShareSMSAppSecret        @"7212b6997e38237ed00ad4ce0f332ed7"




#pragma mark - Color

#define RGB(a,b,c,d)              [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:d]

#define kNavigationTintColor      [UIColor whiteColor]

#define kNavigationBarColor       [UIColor colorWithRed:68/255.0 green:180/255.0 blue:205/255.0 alpha:1]

#define kTabbarBarTintColor        RGB(0,0,0,0.9)

#define kBackgroundColor           RGB(240,240,240,1)

#define kOrangeTextColor           RGB(255,105,0,0.9)


/*宽高*/
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height


//默认头像
#define kDefaultHeadImage   [UIImage imageNamed:@"wo"]