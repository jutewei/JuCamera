//
//  UIColor+hexString.m
//  TestImage
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/5/14.
//

#import "UIColor+hexString.h"
#define PAColorFromRGBA(rgbValue,aValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:aValue]
@implementation UIColor(hexString)

+ (UIColor *)zlColorWithHexString:(NSString*)stringToConvert alpha:(CGFloat)alpha{
    if([stringToConvert hasPrefix:@"#"]){
        stringToConvert = [stringToConvert substringFromIndex:1];
    } else   if([stringToConvert hasPrefix:@"0X"]){
        stringToConvert = [stringToConvert substringFromIndex:2];
    }
    NSScanner*scanner = [NSScanner scannerWithString:stringToConvert];
    unsigned hexNum;
    if(![scanner scanHexInt:&hexNum]){
        return nil;
    }
    return PAColorFromRGBA(hexNum,alpha);
}

@end
