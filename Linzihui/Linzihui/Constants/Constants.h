//
//  Constants.h
//  Linzihui
//
//  Created by ZhuHaikun on 15/11/1.
//  Copyright © 2015年 haikunZhu. All rights reserved.
//



#pragma mark - bmob app id
#define  kBmobApplicationID       @"953e584ada055ec7250cbc57f589f308"

#pragma mark - bmob 云逻辑地址
#define kBmobCloudHttpRequestHeader      @"http://cloud.bmob.cn/5985577c36b64742"

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

#pragma mark - 百度地图key
#define kBaiduMapKey                @"Zp1EsdgXIa2RG8PKXBi1z1GU"

#pragma mark -  极光推送
#define kJPushAppKey              @"b1ee251ae6ef4cd03ea1107c"
#define KJPushChannel             @"Publish channel"
#define KJPushProduction            0


#pragma mark - 支付宝
#define  kAlipayParnerID        @"2088221501579815"
#define  kAliPaySellerID         @"gaopeng48@126.com"
#define  kAlipayPriviteKey      @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAJ45fyEyDYeL4I6CKsLd0DSF/V+Z/GzbOhuVvCU2NRC7PynKFdRsB4DcVoWFD4FBh4oRBvEE9oHsN5avW5g/1XpfbZBrY/tkoWE4lXP90VadfQbztjZIMhTGJtq364n0Ka7ip67XPNvUN5Z+PCy1YDzx0lBozJiQvAHLAPjiVd7fAgMBAAECgYEAlDcJ9r+bWuDV3sjiY55DHiBxw69MfXAzE4oFL9qChQTSW0QZhN4ZfUVpqzOE3bDT1aqzlOzwOa5cOERWCd2qC7nSIkFuB3UF9sXo+fDKKJU4zW8drTUwRBNfWUXd/kbPRH9Sqmm6ZBTR/qpXodPwpwsnd/z1He+zDbsc2bipaIECQQDOP8h8SjnhednoqYCxPYwBfNlf0XaHCs+SEh/xjoI/9/hXjxJeJn36Ku3518bR9TAMlFaikBpcSGkav6KQjGMfAkEAxGQerhOkps5buUpDg5qnWKl8PrVfViUvKZEQRXSPjgHelMYlhKW8ZJfL34SNVph0DKRoIra6eXxeSXzNTczMQQJALXMs0QbiXmelt3my3Fv9wE4s8MqN3hBp0XyhAXAwD7yrQ1BJ8el1lW1kZ8w/CgGIBx2hQc2ToYZrcvOL9WKabQJAWpFNcLvQT7iUpjNwRS26BPJMQOMFr0WApWunlFA3r6Z/Dh7+yFhiNAWo2FBZmdi+k+HxwCiCgGnxVXR/fWR3wQJANufp3Ld9sqba4ZUbIioEufwuUUUcjH/q5LLu72H5dcGlpEP3FIqfOHfCBQwUHDIPglBMygFuviOU7L+UnASYAA=="
#define   kAlipayNotifyURL    @"http://cloud.bmob.cn/5985577c36b64742/alipaynotify"
#define  kAliPayURLSchemes     @"LinZiHuiAlipay"
//支付成功通知
#define kPaySucessNotification      @"PaySuccessNotification"



//app 下载地址
//iOS下载地址
#define kAppDownloadURL            @"https://itunes.apple.com/us/app/you-kang-fu-wu/id646300912?l=zh&ls=1&mt=8"
//安卓下载地址
#define kAndroidDownloadURL     @"http://shouji.360tpcdn.com/160330/9d178bb88dd50cb02a630123c3e57a23/com.linzihui_24.apk"


#pragma mark - Color

#define RGB(a,b,c,d)              [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:d]

#define kNavigationTintColor      [UIColor whiteColor]

#define kNavigationBarColor       [UIColor colorWithRed:68/255.0 green:180/255.0 blue:205/255.0 alpha:1]

#define kDarkGrayColor             [UIColor darkGrayColor]

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