//
//  UIImage+drawImage.h.h
//  PABase
//
//  Created by Juvid on 2016/10/27.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImage (drawGradient)
+(UIImage *)juMainButton;
/**
 绘画渐变图片

 @param size   尺寸
 @param colors 颜色组

 @return 图片
 */
+(UIImage *)juDrawGradientImage:(CGSize)size withColor:(NSArray *)colors;
+(UIImage *)juDrawGradientImage:(CGSize)size withColor:(NSArray *)colors startPoint:(CGPoint)startPoint;

@end

@interface UIView (drawGradient)

/**
 绘制渐变背景

 @param size   尺寸
 @param colors 颜色组
 */
-(void)juDrawGradientBack:(CGSize)size withColor:(NSArray *)colors;
-(void)juDrawGradientBack:(CGSize)size withColor:(NSArray *)colors point:(CGPoint)point;
@end
