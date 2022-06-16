//
//  UIColor+Hex.m
//  UIColorManager
//
//  Created by Juvid on 2019/11/7.
//  Copyright © 2019 Juvid. All rights reserved.
//

#import "UIColor+Dark.h"

@implementation UIColor (Dark)

+(UIColor *)colorWithHex:(NSInteger)rgbV alpha:(CGFloat)alpha{

    return[self juColorWithRed:(rgbV&0xFF0000)>>16 green:(rgbV&0xFF00)>>8 blue:rgbV&0xFF alpha:alpha];
}

+(UIColor *)juColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha{
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
}

/// 16进制暗黑模式自动反转
+(UIColor *)colorDarkWithHex:(NSInteger)rgbV alpha:(CGFloat)alpha{
    return [self colorDarkWithRed:(rgbV&0xFF0000)>> 16 green:(rgbV&0xFF00)>> 8 blue:rgbV&0xFF alpha:alpha];
}


/// 十进制RBG颜色暗黑模式自动反转
+ (UIColor *)colorDarkWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha{
    return [self colorWithWhite:[UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha] darkColor:[UIColor colorWithRed:1-red/255.0 green:1-green/255.0 blue:1-blue/255.0 alpha:alpha]];
}

/// 白色-黑色 暗黑模式自动反转
+(UIColor *)colorDarkWithWhite:(CGFloat)hex alpha:(CGFloat)alpha{
    return [self colorWithWhite:[UIColor colorWithWhite:hex alpha:alpha] darkColor:[UIColor colorWithWhite:1-hex alpha:alpha]];
}
/// 暗黑模式颜色设置
+(UIColor *)colorWithWhite:(UIColor *)whiteColor darkColor:(UIColor *)darkColor{
    if (@available(iOS 13.0, *)) {
        return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle== UIUserInterfaceStyleDark) {
                return darkColor;
            }
            else{
                return whiteColor;
            }
        }];
    } else {
        return whiteColor;
    }
}

+ (UIColor *)juColorWithHexString:(NSString*)stringToConvert{
    return [UIColor juColorWithHexString:stringToConvert alpha:1];
}

+ (UIColor *)juColorWithHexString:(NSString*)stringToConvert alpha:(CGFloat)alpha{
    return [self colorWithHex:[self juHexNumWithString:stringToConvert] alpha:alpha];
}

+ (UIColor *)colorWithHexString:(NSString*)stringToConvert alpha:(CGFloat)alpha{
    return [self juColorWithHexString:stringToConvert alpha:alpha];
}

///**纯色获取颜色值*/
//- (UIColor *)getDarkHexStringByColor{
//    NSArray *colors=[self getHexStringByColor];
//    return JUDarkColorHexA([UIColor colorWithHexString:colors.firstObject],[colors.lastObject floatValue]);
//}

/**颜色转16进制字符串*/
- (NSInteger)getHexStringByColor:(CGFloat *)alpha{
    CGFloat r=0,g=0,b=0;
    [self getRed:&r green:&g blue:&b alpha:alpha];
    NSString *red   = [NSString stringWithFormat:@"%02x", (int)(r * 255)];
    NSString *green = [NSString stringWithFormat:@"%02x", (int)(g * 255)];
    NSString *blue  = [NSString stringWithFormat:@"%02x", (int)(b * 255)];
    return [UIColor juHexNumWithString:[NSString stringWithFormat:@"0x%@%@%@", red, green, blue]];

}
/*任何颜色反转*/
- (UIColor *)getDarkByColor{
//    CGFloat max=r,min=g;
//    if (r<g) {
//        max=g;
//        min=r;
//    }
//    if (max<b) {
//        max=b;
//    }
//    if (min>b) {
//        min=b;
//    }
//    if (max-min<=0.05) {
        return [self getDarkByColor:YES];
//    }
//    return self;
}
/**rgb相等反转*/
- (UIColor *)getDarkByEqualColor{
    return [self getDarkByColor:NO];
}
/*颜色经典反转*/
- (UIColor *)getDarkByColor:(BOOL)isAuto{
    CGFloat r=0,g=0,b=0,a=0;
    [self getRed:&r green:&g blue:&b alpha:&a];
    if (isAuto||r==g==b) {
        return [UIColor colorWithWhite:[UIColor colorWithRed:r green:g blue:b alpha:a] darkColor:[UIColor colorWithRed:1-r green:1-g blue:1-b alpha:a]];
    }
    return self;
}

+ (NSInteger)juHexNumWithString:(NSString*)stringToConvert{
    if([stringToConvert hasPrefix:@"#"]){
        stringToConvert = [stringToConvert substringFromIndex:1];
    } else if([stringToConvert hasPrefix:@"0X"]||[stringToConvert hasPrefix:@"0x"]){
        stringToConvert = [stringToConvert substringFromIndex:2];
    }
    NSScanner*scanner = [NSScanner scannerWithString:stringToConvert];
    unsigned hexNum;
    if(![scanner scanHexInt:&hexNum]){
        return 0;
    }
    return hexNum;
}



@end
