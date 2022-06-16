//
//  UIColor+PAColor.h
//  PABaseUIKit
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2022/1/20.
//

#import <UIKit/UIKit.h>
#import "UIColor+config.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (PAColor)
/// 16进制颜色
/// @param rgbV 16进制数
/// @param alpha 透明度
+(UIColor *)zlColorWithHex:(NSInteger)rgbV alpha:(CGFloat)alpha;

/// 16进制暗黑模式自动反转
/// @param hex 16进制数
/// @param alpha 透明度
+ (UIColor *)zlColorDarkWithHex:(NSInteger)hex alpha:(CGFloat)alpha;

/// 白色-黑色 暗黑模式自动反转
/// @param wValue 白色值
/// @param alpha 透明度
+ (UIColor *)zlColorDarkWithWhite:(CGFloat)wValue alpha:(CGFloat)alpha;

/// 十进制RBG颜色暗黑模式自动反转
/// @param red 红色
/// @param green 绿色
/// @param blue 蓝色
/// @param alpha 透明度
+ (UIColor *)zlColorDarkWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;


/// 十进制RBG颜色
/// @param red 红色
/// @param green 绿色
/// @param blue 蓝色
/// @param alpha 透明度
+(UIColor *)zlColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

/// 暗黑模式颜色设置
/// @param whiteColor 白色
/// @param darkColor 黑色
+ (UIColor *)zlColorWithWhite:(UIColor *)whiteColor darkColor:(UIColor *)darkColor;

/// 字符串转颜色值
/// @param stringToConvert 字符
+ (UIColor *)zlColorWithHexString:(NSString*)stringToConvert;

/// 字符串转颜色
/// @param stringToConvert 字符
/// @param alpha 透明度
+ (UIColor *)zlColorWithHexString:(NSString*)stringToConvert alpha:(CGFloat)alpha;

+ (UIColor *)zlColorWithHexString:(NSString*)stringToConvert alpha:(CGFloat)alpha __deprecated_msg("Use `juColorWithHexString`");
///**纯色获取颜色值*/
//+ (UIColor *)getDarkHexStringByColor:(UIColor *)originColor;

/*任何颜色反转*/
- (UIColor *)zlGetDarkByColor;
/**rgb相等反转*/
- (UIColor *)zlGetDarkByEqualColor;

//
///**颜色值返回十六进制*/
- (NSInteger)zlGetHexStringByColor:(CGFloat *)alpha;
@end

NS_ASSUME_NONNULL_END
