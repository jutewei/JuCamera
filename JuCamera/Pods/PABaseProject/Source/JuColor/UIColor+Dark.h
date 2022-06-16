//
//  UIColor+Hex.h
//  UIColorManager
//
//  Created by Juvid on 2019/11/7.
//  Copyright © 2019 Juvid. All rights reserved.
//

#define UINormalColorHex(hex)           [UIColor colorWithHex:hex alpha:1.0]                    ///< 正常颜色000000-ffffff
#define UINormalColorHexA(hex,a)        [UIColor colorWithHex:hex alpha:a]                      ///< 正常颜色000000-ffffff 0-1
#define UINormalColorRGBA(r,g,b,a)      [UIColor juColorWithRed:r green:g blue:b alpha:a]       ///< 正常颜色0-255 0-255 0-255  0-1

#define JUDarkColorHex(hex)             [UIColor colorDarkWithHex:hex alpha:1]                  ///< 暗黑000000-ffffff
#define JUDarkColorHexA(hex,a)          [UIColor colorDarkWithHex:hex alpha:a]                  ///< 暗黑000000-ffffff 0-1

#define JUDarkColorWhiteA(w,a)          [UIColor colorDarkWithWhite:w alpha:a]                  ///< 暗黑 0-1 0-1
#define JUDarkColorRBGA(r,g,b,a)        [UIColor colorDarkWithRed:r green:g blue:b alpha:a]     ///< 暗黑 0-255 0-255 0-255  0-1

#define JUDarkBothColor(wCol,dCol)      [UIColor colorWithWhite:wCol darkColor:dCol]            ///< 暗黑模式自定义颜色 color  color
#define JUDarkBothColorHex(wHex,dHex)   [UIColor colorWithWhite:UINormalColorHex(wHex) darkColor:UINormalColorHex(dHex)]///< 暗黑模式自定义颜色  000000-ffffff  000000-ffffff

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Dark)

/// 16进制颜色
/// @param rgbV 16进制数
/// @param alpha 透明度
+(UIColor *)colorWithHex:(NSInteger)rgbV alpha:(CGFloat)alpha;

/// 16进制暗黑模式自动反转
/// @param hex 16进制数
/// @param alpha 透明度
+ (UIColor *)colorDarkWithHex:(NSInteger)hex alpha:(CGFloat)alpha;

/// 白色-黑色 暗黑模式自动反转
/// @param wValue 白色值
/// @param alpha 透明度
+ (UIColor *)colorDarkWithWhite:(CGFloat)wValue alpha:(CGFloat)alpha;

/// 十进制RBG颜色暗黑模式自动反转
/// @param red 红色
/// @param green 绿色
/// @param blue 蓝色
/// @param alpha 透明度
+ (UIColor *)colorDarkWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;


/// 十进制RBG颜色
/// @param red 红色
/// @param green 绿色
/// @param blue 蓝色
/// @param alpha 透明度
+(UIColor *)juColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

/// 暗黑模式颜色设置
/// @param whiteColor 白色
/// @param darkColor 黑色
+ (UIColor *)colorWithWhite:(UIColor *)whiteColor darkColor:(UIColor *)darkColor;

/// 字符串转颜色值
/// @param stringToConvert 字符
+ (UIColor *)juColorWithHexString:(NSString*)stringToConvert;

/// 字符串转颜色
/// @param stringToConvert 字符
/// @param alpha 透明度
+ (UIColor *)juColorWithHexString:(NSString*)stringToConvert alpha:(CGFloat)alpha;

+ (UIColor *)colorWithHexString:(NSString*)stringToConvert alpha:(CGFloat)alpha __deprecated_msg("Use `juColorWithHexString`");
///**纯色获取颜色值*/
//+ (UIColor *)getDarkHexStringByColor:(UIColor *)originColor;

/*任何颜色反转*/
- (UIColor *)getDarkByColor;
/**rgb相等反转*/
- (UIColor *)getDarkByEqualColor;

//
///**颜色值返回十六进制*/
- (NSInteger)getHexStringByColor:(CGFloat *)alpha;

@end

NS_ASSUME_NONNULL_END
