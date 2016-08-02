//
//  CommonMethods.m
//  Xianghu
//
//  Created by iMac on 14-7-7.
//  Copyright (c) 2014年 Xianghu. All rights reserved.
//

#import "CommonMethods.h"
#import "Constants.h"
#import "MyProgressHUD.h"





@implementation CommonMethods

+ (NSString*)getHHmmssStr:(NSString *)dateStr
{
    NSDateFormatter *dateformatter1 = [[NSDateFormatter alloc]init];
    
    [dateformatter1 setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    
    NSDate *formateDate = [dateformatter1 dateFromString:dateStr];
    
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"HH:mm:ss"];
    
    
    NSString *timeStr = [dateformatter stringFromDate:formateDate] ;
    
    return timeStr;
}
+ (NSString*)getYYYYMMddHHmmssDateStr:(NSDate *)date
{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
    
    [dateformatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    
    NSString *finalDateStr = [dateformatter stringFromDate:date];
    
    
    return finalDateStr;
}
+(NSInteger)getDay:(NSString *)dateStr
{
    NSDateFormatter *fromatter = [[NSDateFormatter alloc]init];
    
    [fromatter setDateFormat:@"YYYY-MM-dd"];
    
    NSDate *date = [fromatter dateFromString:dateStr];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
  
    
    NSInteger dateFlag = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    
    NSDateComponents *components = [calendar components:dateFlag fromDate:date];
    
    NSInteger today = [components day];
    
    
    return today;
    
                                    
    
}

+ (UIImage*)autoSizeImageWithImage:(UIImage *)image
{
    CGSize imageSize = image.size;
    
    
    CGFloat imagewith = 500.0;
    
    CGFloat imageHeight = imageSize.height *imagewith/imageSize.width;
    
    
    
    return [self imageWithImage:image scaledToSize:CGSizeMake(imagewith, imageHeight)];
    
    
    
}

+(NSDate*)getYYYMMddFromString:(NSString *)dateStr
{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *date = [dateformatter dateFromString:dateStr];
    
    return date;
    
}

+(NSString*)getYYYYMMddFromDefaultDateStr:(NSDate *)date
{
 
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
    
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    
    NSString *finalDateStr = [dateformatter stringFromDate:date];
    
    
    return finalDateStr;
    
    
}


+(NSString*)getHHmmFromDefaultDateStr:(NSDate *)date
{
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"HH:mm"];
    
    
    NSString *timeStr = [dateformatter stringFromDate:date];
    
    return timeStr;
    
}

+(NSString*)getHHmmssFromDefaultDateStr:(NSDate *)date
{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"HH:mm:ss"];
    
    
    NSString *timeStr = [dateformatter stringFromDate:date];
    
    return timeStr;
}

+(NSString*)getYYYYMMddhhmmDateStr:(NSDate *)date
{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    
    
    NSString *timeStr = [dateformatter stringFromDate:date];
    
    return timeStr;
}

+(NSString *)getNoSpaceDateStr:(NSDate*)date
{


    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    
    NSInteger dateFlag = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit;
    
    NSDateComponents *components = [calendar components:dateFlag fromDate:date];
    
    NSInteger today = [components day];
    
    NSInteger year = [components year];
    
    NSInteger month = [components month];
    
    NSInteger hour = [components hour];
    
    NSInteger min = [components minute];
    
    NSInteger sec = [components second];
    
    NSString *str = [NSString stringWithFormat:@"%ld%ld%ld%ld%ld%ld",(long)year,(long)month,(long)today,(long)hour,(long)min,(long)sec];
    
    return str;
    
    
}



#pragma mark - UILabel
+(UILabel*)labelWithText:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font textAligment:(NSTextAlignment)alignment frame:(CGRect)frame
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    
    label.text = text;
    
    label.textColor = textColor;
    label.font = font;
    
    label.textAlignment = alignment;
    
    
    
    return label;
    
    
}


#pragma mark - UILabel
+(UILabel*)LabelWithText:(NSString *)labeltext andTextAlgniment:(NSTextAlignment)alignment andTextColor:(UIColor *)textcolor andTextFont:(UIFont *)textFont andFrame:(CGRect)frame
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = labeltext;
    label.textAlignment = alignment;
    label.textColor = textcolor;
    label.font = textFont;
    label.backgroundColor = [UIColor clearColor];
    
    return label;
    
}



+ (BOOL)checkTel:(NSString *)str
{
    
     NSString *eleven = @"^1\\d{10}$";
    NSPredicate *regexttext11 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",eleven];
    
    if ([regexttext11 evaluateWithObject:str])
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
    /**
//     * 手机号码
//     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
//     * 联通：130,131,132,152,155,156,185,186
//     * 电信：133,1349,153,180,189
//     */
//    NSString * MOBILE = @"^1(3r[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
//    /**
//     10         * 中国移动：China Mobile
//     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
//     12         */
//    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
//    /**
//     15         * 中国联通：China Unicom
//     16         * 130,131,132,152,155,156,185,186
//     17         */
//    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
//    /**
//     20         * 中国电信：China Telecom
//     21         * 133,1349,153,180,189
//     22         */
//    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
//    
//    /**
//     25         * 大陆地区固话及小灵通
//     26         * 区号：010,020,021,022,023,024,025,027,028,029
//     27         * 号码：七位或八位
//     28         */
//    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
//    
//    /**
//     29         * 新增淘宝等号段
//     30         * 170,176,177,178,147
//     31         */
//    NSString *TB = @"^1(7[0678]|4[7]|8[0-9])\\d{8}$";
//    
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
//    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
//    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
//    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
//    NSPredicate *regexttexttb = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",TB];
//    
//    if (([regextestmobile evaluateWithObject:str] == YES)
//        || ([regextestcm evaluateWithObject:str] == YES)
//        || ([regextestcu evaluateWithObject:str] == YES)
//        || ([regextestct evaluateWithObject:str] == YES)
//        || ([regextestphs evaluateWithObject:str] == YES)
//        || [regexttexttb evaluateWithObject:str] == YES)
//    {
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
}




#pragma mark - 判断Email格式是否正确
+ (BOOL)isValidateEmail:(NSString *)Email
{
    NSString *emailCheck = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailCheck];
    return [emailTest evaluateWithObject:Email];
}

#pragma mark - 判断用户名
+(BOOL)isRightUserName:(NSString*)Username
{
    NSString *usernameCheck = @"^[_\\w\\d\\x{4e00}-\\x{9fa5}]{2,20}$";
    
    NSPredicate *usernameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",usernameCheck];
    
    return [usernameTest evaluateWithObject:Username];
    
    
}

#pragma mark - 密码
+(BOOL)isRightCode:(NSString*)code
{
    NSString *codeCheck = @"^[\\~!@#$%^&*()-_=+|{}\\[\\],.?\\/:;\'\"\\d\\w]{6,16}$";
    
    NSPredicate *codeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",codeCheck];
    
    //NSLog(@"%s,%@",__func__,code);
    
    return [codeTest evaluateWithObject:code];
    
    
}


#pragma mark - 异步请求图片
+(void)setImageViewWithImageURL:(NSString *)url imageView:(UIImageView *)imageView
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
        
        if (image != nil) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                imageView.image = image;
                
            });
        }
 
        
        
    });
    
}

+(void)setButtonImageWithImageURL:(NSString*)url button:(UIButton*)button
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
        
        if (image != nil) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                [button setImage:image forState:UIControlStateNormal];
                
            });
        }
        
        
        
    });
}





#pragma mark - 对图片进行大小压缩
+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

#pragma mark - 将中间字符变成 ****
+(NSString*)geteditedmobile:(NSString*)mobile
{
    
    if (mobile.length == 11) {
        
        NSString *editemobile = mobile;
        
        NSString *firstThreeStr = [editemobile substringToIndex:3];
        
        NSString *lastFourStr = [editemobile substringFromIndex:7];
        
        editemobile = [NSString stringWithFormat:@"%@****%@",firstThreeStr,lastFourStr];
        
        
        
        return editemobile;
    }
 
    else
    {
        return mobile;
        
    }
    
}

+(BOOL)isBetweenTheTime:(NSString*)startTime endTime:(NSString*)endTime
{
    
    if (startTime == nil || endTime == nil) {
        
        return NO;
        
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"YYYY-MM-dd"];
    
    
    NSDate *startDate = [formatter dateFromString:startTime];
    
    NSDate *endDate = [formatter dateFromString:endTime];
    
    
    NSDate *now = [NSDate date];
    
    if ([now isEqualToDate:[now laterDate:startDate]] && [now isEqualToDate:[now earlierDate:endDate]])
    {
        
        
        return YES;
        
        
        
    }
    
    return NO;
    
    
}

+(BOOL)isContainsEmoji:(NSString *)string {
    
    
    
    __block BOOL isEomji = NO;
    
    
    
    [string  enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         
         
         const unichar hs = [substring characterAtIndex:0];
         
         // surrogate pair
         
         if (0xd800 <= hs && hs <= 0xdbff) {
             
             if (substring.length > 1) {
                 
                 const unichar ls = [substring characterAtIndex:1];
                 
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     
                     isEomji = YES;
                     
                 }
                 
             }
             
         } else if (substring.length > 1) {
             
             const unichar ls = [substring characterAtIndex:1];
             
             if (ls == 0x20e3) {
                 
                 isEomji = YES;
                 
             }
             
             
             
         } else {
             
             // non surrogate
             
             if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                 
                 isEomji = YES;
                 
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 
                 isEomji = YES;
                 
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 
                 isEomji = YES;
                 
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 
                 isEomji = YES;
                 
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                 
                 isEomji = YES;
                 
             }
             
         }
         
     }];
    
    
    
    return isEomji;
    
}


+(void)showDefaultErrorString:(NSString *)errorStr
{
    
    [[[UIAlertView alloc]initWithTitle:nil message:errorStr delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil]show ];
    
    
    
    
}

+(void)showAlertString:(NSString *)alert delegate:(id)delegate tag:(NSInteger)tag
{
    
      UIAlertView * alertview = [[UIAlertView alloc]initWithTitle:nil message:alert delegate:delegate cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    alertview.tag = tag;
    
    [alertview show];
    
}

+(void)addLine:(float)x startY:(float)y color:(UIColor *)color toView:(UIView *)parentView{
    CALayer *line = [[CALayer alloc] init];
    line.frame = CGRectMake(x, y, parentView.frame.size.width-x, 1);
    line.backgroundColor = color.CGColor;
    [parentView.layer addSublayer:line];
}




+(NSString*)distanceStringWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude
{
    double dis = [self distanceFromLocation:latitude longitude:longitude];
    
    if (dis < 1000) {
        
        return [NSString stringWithFormat:@"%.0f米",dis];
    }
    else
    {
        return [NSString stringWithFormat:@"%.2f公里",dis/1000.0];
        
    }
    
    
}

+(CGFloat)distanceFromLocation:(CGFloat)latitude  longitude:(CGFloat)longitude
{
    CGFloat currentlongitude = [[NSUserDefaults standardUserDefaults ] floatForKey:kCurrentLongitude];
    
    CGFloat currentlatitude = [[NSUserDefaults standardUserDefaults ] floatForKey:kCurrentLatitude];
    
    CLLocation *fromLocation = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    
    CLLocation *toLocation = [[CLLocation alloc]initWithLatitude:currentlatitude longitude:currentlongitude];
    
    
    CGFloat meter = [toLocation distanceFromLocation:fromLocation];
    
    
    return meter;
    
    
    
}
+(NSString*)timeStringFromNow:(NSDate*)Thattime
{
    
    
    double time = fabs([Thattime timeIntervalSinceNow]);
    
    
    NSInteger day = (NSInteger)time/60/60/24;
    
    NSInteger hour = (NSInteger)time/60/60%24;
    
    NSInteger minues = (NSInteger)time/60%60;
    
    
    

        
  
    
    if (day > 0) {
        
       return  [NSString stringWithFormat:@"%ld天%ld小时%ld分钟",(long)day,(long)hour,(long)minues];
    }
    
    if (hour > 0) {
        
        return  [NSString stringWithFormat:@"%ld小时%ld分钟",(long)hour,(long)minues];
    }
    
    return  [NSString stringWithFormat:@"%ld分钟",(long)minues];
    
//    if (hour > 0) {
//        
//        return [NSString stringWithFormat:@"%ld小时",(long)hour];
//        
//    }
//    
//   
//    return [NSString stringWithFormat:@"%ld分钟",(long)minues];
    
    
}

+ (NSString *)getMounthAndDay:(NSDate *)dateTime{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit;
    comps = [calendar components:unitFlags fromDate:dateTime];
    long day=[comps day];//获取日期对应的日
    long month=[comps month];//获取月对应的月
    return [NSString stringWithFormat:@"%ld/%ld",month,day];
}




+(NSString*)getCurrentDeviceName
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    if (screenSize.width == 320) {
        
        if (screenSize.height == 480) {
            
            return @"来自:iPhone 4s";
        }
        
        if (screenSize.height == 568) {
            
            return @"来自:iPhone 5s";
        }
        
      
    }
    
    if (screenSize.width == 375) {
        
        return @"来自:iPhone 6";
    }
    
    if (screenSize.width == 414) {
        
        return @"来自:iPhone 6plus";
        
    }
    
    return @"来自:未知型号";
    
}


+ (void)callPhoneWithSuperView:(UIView *)view phoneNum:(NSString *)phoneNum
{
    UIWebView *webView = [[UIWebView alloc]init];
    
    NSString *phonestr  = [NSString stringWithFormat:@"tel://%@", phoneNum];
    NSURL *telUrl = [NSURL URLWithString:phonestr];
    [webView loadRequest:[NSURLRequest requestWithURL:telUrl]];
    [view addSubview:webView];
    
    
}

+(double)timeLeft:(NSString *)sinceTimeStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm"];
    
    NSDate *fromDate = [formatter dateFromString:sinceTimeStr];
    
    
    double secends = [[NSDate date] timeIntervalSinceDate:fromDate];
    
//    NSLog(@"fromDate:%@",fromDate);
    
    return (3600 - secends);
    
    
    
}


+(void)upLoadPhotos:(NSArray *)photos resultBlock:(upLoadPhotoBlock)block
{
    if (photos.count > 0) {
        
        NSMutableArray *photosDataArray = [[NSMutableArray alloc]init];
        
        for (NSInteger i = 0 ; i  < photos.count ; i ++) {
            
            UIImage *oneImage = [photos objectAtIndex:i];
            NSData *imageData = UIImageJPEGRepresentation(oneImage, 1);
            
            
            
            NSDictionary *imagedataDic = @{@"data":imageData,@"filename":@"image.jpg"};
            
            [photosDataArray addObject:imagedataDic];
            
            
        }
        
        
        
       [BmobFile filesUploadBatchWithDataArray:photosDataArray progressBlock:^(int index, float progress) {
           
       } resultBlock:^(NSArray *array, BOOL isSuccessful, NSError *error) {
           if (error) {
               
               NSLog(@"%s,error:%@",__func__,error);
               
               NSLog(@"图片上传失败");
               
               [CommonMethods showDefaultErrorString:@"图片上传失败，请重新上传"];
               
               block(NO,nil);
               
               
           }else
           {
               
//               NSLog(@"filename:%@ ",array);
            
               
               
               NSMutableArray *temUrlArray = [[NSMutableArray alloc]init];
               
               for (int i = 0; i < array.count; i ++) {
                   
                   BmobFile *file = [array objectAtIndex:i];
                   
                   [temUrlArray addObject:file.url];
                   
               }
               //回调
               block(YES,temUrlArray);
               
               
           }
       }];
        
 
        
        
        
        
        
    }
}

#pragma mark - 整理手机号码格式
+(NSString*)getRightPhoneNum:(NSString*)phoneNum{
    
    if (phoneNum.length > 4) {
        
        NSString *firstThreeLetter = [phoneNum substringFromIndex:3];
        
        NSString *firstTwoLetter = [phoneNum substringToIndex:2];
        
        if ([firstThreeLetter isEqualToString:@"+86"]) {
            
            phoneNum = [phoneNum substringFromIndex:4];
            
        }
        if ([firstTwoLetter isEqualToString:@"86"]) {
            
            phoneNum = [phoneNum substringFromIndex:3];
            
        }
        
        phoneNum = [phoneNum stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        return phoneNum;
        
        
    }
    else
    {
        return @"";
        
    }
 
    
}

+(NSDate*)getYYYYMMddhhmmssFromString:(NSString*)dateStr
{
    
    NSDateFormatter *_dateFormater = [[NSDateFormatter alloc]init];
    
    [_dateFormater setDateFormat:@"YYYY-MM-dd HH:mm"];
    
    
    NSDate*_date = [_dateFormater dateFromString:dateStr];
    
    
    return _date;
    
}
#pragma mark - 活动状态
+(NSInteger)activityStatusWithStartTime:(NSDate*)startTime  endTime:(NSDate*)endTime
{
    
    
 
    
    
    
    
    NSDate *_now = [NSDate date];
    
    
    if ([_now isEqualToDate:[_now earlierDate:startTime]]) {
        
        return 1;  //活动未开始
        
    }
    
    if ([_now isEqualToDate:[_now earlierDate:endTime]] ) {
        
        
        return 2; //活动进行中
    }
    
    
    return 3; //活动已结束
    
    

    
    
    
    
}


#pragma mark - 是否已过报名时间
+(NSInteger)activityRegistStatus:(NSDate*)endRegitstTime
{
    
    
    NSDate *_now = [NSDate date];
    
    
    if ([_now isEqualToDate:[_now earlierDate:endRegitstTime]]) {
        
        return 1;  //未截止
        
    }
    
    return 2;  //已截止
    
}

#pragma mark- 震动、声音效果

#define SOUNDID  1109  //1012 -iphone   1152 ipad  1109 ipad
#define SOUNDID_1 1012
+ (void)systemVibrate
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

+ (void)systemSound
{
    AudioServicesPlaySystemSound(SOUNDID);
}

+ (void)systemSound_1
{
    AudioServicesPlaySystemSound(SOUNDID_1);
}


#pragma mark - 获取当前地址
+(void)getCurrentLocation:(void(^)(BOOL success,NSString *address))result
{
    
    CGFloat latitude = [[NSUserDefaults standardUserDefaults]floatForKey:kCurrentLatitude];
    
    CGFloat longitude = [[NSUserDefaults standardUserDefaults] floatForKey:kCurrentLongitude];
    
    
    CLLocation *location = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    
    CLGeocoder *coder = [[CLGeocoder alloc]init];
    
    [coder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> *  placemarks, NSError *  error) {
       
        if (!error && placemarks.count > 0) {
            
            
            CLPlacemark *placeMark = [placemarks firstObject];
            
            NSLog(@"address->>>>>>>%@",placeMark.addressDictionary);
            
            NSString *address = nil;
            
            NSString *SubThoroughfare = [placeMark.addressDictionary objectForKey:@"SubThoroughfare"];
            
            if (!SubThoroughfare) {
                
                SubThoroughfare = @"";
            }
            NSString *subLocality = [placeMark.addressDictionary objectForKey:@"SubLocality"];
            
            if (!subLocality) {
                
                subLocality = @"";
                
            }
            NSString *street = [placeMark.addressDictionary objectForKey:@"Street"];
            
            if (!street) {
                
                street = @"";
                
            }
            
            address = [NSString stringWithFormat:@"  %@%@",subLocality,street];
            
            
            if (result) {
                
                result(YES,address);
                
            }
            
            
        }
        
        
    }];
    
    
    
}


@end
