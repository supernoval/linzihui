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

#pragma mark - 微信
#define kWeiChatAppID              @"wx08f14afb1a1bcf1a"
#define kWeiChatURLScheme          @"wx08f14afb1a1bcf1a"

#pragma mark - QQ
#define kQQAppID                   @"1104890893"
#define kQQAppKey                  @"bILqfDKzAuZe1Jjb"
//app 下载地址
#define kAppDownloadURL            @"https://itunes.apple.com/us/app/you-kang-fu-wu/id646300912?l=zh&ls=1&mt=8"



#pragma mark - Color

#define RGB(a,b,c,d)              [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:d]

#define kNavigationTintColor      [UIColor whiteColor]

#define kNavigationBarColor       [UIColor colorWithRed:68/255.0 green:180/255.0 blue:205/255.0 alpha:1]

#define kTabbarBarTintColor        RGB(0,0,0,0.9)

#define kBackgroundColor           RGB(240,240,240,1)

#define kLineColor               RGB(220,220,220,1)

#define kOrangeTextColor           RGB(255,105,0,0.9)

#define kBlueBackColor            RGB(68,180,205,1)

#define kHightLightColor          RGB(120,120,120,1)


/*字体*/
#define FONT_20 [UIFont systemFontOfSize:20]
#define FONT_18 [UIFont systemFontOfSize:18]
#define FONT_17 [UIFont systemFontOfSize:17]
#define FONT_16 [UIFont systemFontOfSize:16]
#define FONT_15 [UIFont systemFontOfSize:15]
#define FONT_14 [UIFont systemFontOfSize:14]
#define FONT_13 [UIFont systemFontOfSize:13]
#define FONT_12 [UIFont systemFontOfSize:12]



/*宽高*/
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height


//默认头像
#define kDefaultHeadImage   [UIImage imageNamed:@"defaultHead"]

//默认加载图标
#define kDefaultLoadingImage  [UIImage imageNamed:@"default_loading"]


//创建群成功 通知名称
#define kCreategroupSuccessNoti       @"CreategroupSuccessNoti"

//修改群名称 通知
#define kChangeGroupSubTitleNoti        @"ChangeGroupSubTitleNoti"