//
//  UIView+DrawGradient.m
//  PABase
//
//  Created by Juvid on 2016/10/27.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import "UIView+drawGradient.h"

@implementation UIImage (DrawGradient)

+(UIImage *)juMainButton{
  return  [self juDrawGradientImage:CGSizeMake(8, 4) withColor:@[(id)UINormalColorHex(0xFF5E3D).CGColor,(id)UINormalColorHex(0xFF1382).CGColor] startPoint:CGPointMake(0, 2)];
}

/*
 *绘画渐变
 */
+(UIImage *)juDrawGradientImage:(CGSize)size withColor:(NSArray *)colors{

    return [self juDrawGradientImage:size withColor:colors startPoint:(CGPoint){0,0}];
}
+(UIImage *)juDrawGradientImage:(CGSize)size withColor:(NSArray *)colors startPoint:(CGPoint)startPoint {
    UIGraphicsBeginImageContextWithOptions (size, NO , 0.0 );
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = {0,0.5,1};

    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef) colors, locations);
    CGColorSpaceRelease(colorSpace);

    CGPoint endPoint=CGPointMake(size.width-startPoint.x, size.height-startPoint.y);

    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGGradientRelease(gradient);

    UIGraphicsPopContext();
    UIImage *newImage= UIGraphicsGetImageFromCurrentImageContext ();
    UIGraphicsEndImageContext ();
    return newImage;
}

@end

@implementation UIView (DrawGradient)

/*
 *绘制渐变背景
 */
-(void)juDrawGradientBack:(CGSize)size withColor:(NSArray *)colors{
    CAGradientLayer *gradient;
    for (CAGradientLayer *subLayer in self.layer.sublayers) {
        if ([subLayer isKindOfClass:[CAGradientLayer class]]) {
            gradient=subLayer;
        }
    }
    if (!gradient) {
        gradient= [CAGradientLayer layer];
        [self.layer insertSublayer:gradient atIndex:0];
    }
    gradient.frame = CGRectMake(0 , 0, size.width, size.height);
    gradient.colors = colors;
    gradient.startPoint=CGPointMake(0, 0);
    gradient.endPoint=CGPointMake(1, 1);
}
-(void)juDrawGradientBack:(CGSize)size withColor:(NSArray *)colors point:(CGPoint)point{
    CAGradientLayer *gradient;
    for (CAGradientLayer *subLayer in self.layer.sublayers) {
        if ([subLayer isKindOfClass:[CAGradientLayer class]]) {
            gradient=subLayer;
        }
    }
    if (!gradient) {
        gradient= [CAGradientLayer layer];
        [self.layer insertSublayer:gradient atIndex:0];
    }
    gradient.frame = CGRectMake(0 , 0, size.width, size.height);
    gradient.colors = colors;
    gradient.startPoint=CGPointMake(point.x, 0);
    gradient.endPoint=CGPointMake(point.x, point.y);
}
//-(NSArray *)shSwitchColors:(NSArray *)colors{
//    NSMutableArray *arrColor=[NSMutableArray array];
//}
@end
