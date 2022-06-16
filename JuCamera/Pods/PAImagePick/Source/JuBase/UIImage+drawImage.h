//
//  UIImage+drawImage.h
//  PABase
//
//  Created by Juvid on 2017/8/23.
//  Copyright © 2017年 Juvid. All rights reserved.
//

#import <UIKit/UIKit.h>
static const NSString *DSRoundImagePreString = @"DSIsRound";
@interface UIImage (draw)


+ (UIImage *)juImageWithColor:(UIColor *)color;
/**
 生成指定颜色图片

 @param color 颜色
 @param size 大小
 @return 图片
 */
+ (UIImage *)juImageWithColor:(UIColor *)color size:(CGSize)size;

/**
 拉伸图片

 @param imgName 图片名
 @param width 左边宽度
 @param height 顶部高度
 @return 图片
 */
+(UIImage *)juStretchableImg:(NSString *)imgName leftW:(float)width topH:(float)height;
// 给图片添加文字水印?

/**
 图片加文字水印
 
 @param image 图片名
 @param text  水印文字
 @param point 位置
 @return 图片
 */
+ (UIImage *)juWaterImageWithImage:(UIImage *)image text:(NSAttributedString *)text textPoint:(CGPoint)point;

+ (UIImage *)screenView:(UIView *)view ;


/*以下方法暂时未使用*/
/**
 *  主要SDWebImage里使用，key会缓存key
 *
 *  @param image 原始图片
 *  @param key   缓存key
 *
 *  @return 圆角图片
 */
+ (UIImage *)createRoundedRectImage:(UIImage*)image withKey:(NSString *)key;


+ (UIImage *)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(int)radius;

@end


@interface UIColor (Image)

-(UIImage *)image;

@end
