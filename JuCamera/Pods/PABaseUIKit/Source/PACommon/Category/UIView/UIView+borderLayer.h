//
//  UIView+borderLayer.h
//  PABase
//
//  Created by Juvid on 2018/1/11.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import <UIKit/UIKit.h>
#define CornersDirectionTop UIRectCornerTopLeft|UIRectCornerTopRight
#define CornersDirectionBottom UIRectCornerBottomLeft|UIRectCornerBottomRight
@interface UIView (borderLayer)

/**
 绘制虚线框

 @param frame 坐标
 */
-(void)juSetBorder:(CGRect)frame;

-(void)juSetBorder:(CGRect)frame radius:(CGFloat)radius;

-(void)juSetRadii:(CGFloat)radii byRoundingCorners:(UIRectCorner)corners;

-(void)juSetRadii:(CGFloat)radii byRoundingCorners:(UIRectCorner)corners frame:(CGRect)frame;

-(void)juSetRadii:(CGFloat)radii byRoundingCorners:(UIRectCorner)corners borderStatu:(NSInteger)status;

/*设置四个圆角***/
-(void)juCornerRadius:(CGFloat)radius;

-(void)juBorderColor:(UIColor *)color radius:(CGFloat)radius;

-(void)juBorderColor:(UIColor *)color radius:(CGFloat)radius lineWidth:(CGFloat)lineWidth;

@end
