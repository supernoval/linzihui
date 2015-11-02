//
//  StringHeight.m
//  UcanService
//
//  Created by ucan on 15/4/15.
//  Copyright (c) 2015年 ucan. All rights reserved.
//

#import "StringHeight.h"
#import <CoreText/CoreText.h>
@implementation StringHeight


+ (CGFloat)heightWithText:(NSString *)text font:(UIFont *)font constrainedToWidth:(CGFloat)width
{
    
    if (!text) {
        
        return 0;
    }
    // Get text
    CFMutableAttributedStringRef attrString =CFAttributedStringCreateMutable(kCFAllocatorDefault,0);
    CFAttributedStringReplaceString (attrString,CFRangeMake(0,0), (CFStringRef) text);
    CFIndex stringLength = CFStringGetLength((CFStringRef) attrString);
    
    // Change font
    CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef) font.fontName, font.pointSize,NULL);
    CFAttributedStringSetAttribute(attrString, CFRangeMake(0, stringLength), kCTFontAttributeName, ctFont);
    
    // Calc the size
    CTFramesetterRef framesetter =CTFramesetterCreateWithAttributedString(attrString);
    CFRange fitRange;
    CGSize frameSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, stringLength), NULL, CGSizeMake(width, CGFLOAT_MAX), &fitRange);
    CFRelease(ctFont);
    CFRelease(framesetter);
    CFRelease(attrString);
    //NSLog(@"frameSize=======:%f", frameSize.height);
    return frameSize.height;
}


+(CGFloat)widthtWithText:(NSString *)text font:(UIFont *)font constrainedToHeight:(CGFloat)height
{
    if (!text) {
        
        return 0;
    }
    
    
    CGRect sizeRect = [text boundingRectWithSize:CGSizeMake(1000, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    
    return sizeRect.size.width + 5;
    
    // Get text
//    CFMutableAttributedStringRef attrString =CFAttributedStringCreateMutable(kCFAllocatorDefault,0);
//    CFAttributedStringReplaceString (attrString,CFRangeMake(0,0), (CFStringRef) text);
//    CFIndex stringLength = CFStringGetLength((CFStringRef) attrString);
//    
//    // Change font
//    CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef) font.fontName, font.pointSize,NULL);
//    CFAttributedStringSetAttribute(attrString, CFRangeMake(0, stringLength), kCTFontAttributeName, ctFont);
//    
//    // Calc the size
//    CTFramesetterRef framesetter =CTFramesetterCreateWithAttributedString(attrString);
//    CFRange fitRange;
//    CGSize frameSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, stringLength), NULL, CGSizeMake(CGFLOAT_MAX, height), &fitRange);
//    CFRelease(ctFont);
//    CFRelease(framesetter);
//    CFRelease(attrString);
//    //NSLog(@"frameSize=======:%f", frameSize.height);
//    
//    return frameSize.width + 5;
}

@end
