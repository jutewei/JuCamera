//
//  UIImage+Dark.h
//  PABase
//
//  Created by Juvid on 2020/3/23.
//  Copyright © 2020 Juvid. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Dark)

/// 图片颜色自动翻转（适用纯色图片）
/// @param name 图片名
/// @param darkHex 暗黑颜色十六进制值
+(UIImage *)imageNamed:(NSString *)name darkHex:(NSInteger)darkHex;


/// 图片颜色自动翻转（适用纯色图片）
/// @param name 图片名
/// @param darkColor 暗黑颜色
+(UIImage *)imageNamed:(NSString *)name darkColor:(UIColor *)darkColor;

@end

NS_ASSUME_NONNULL_END
