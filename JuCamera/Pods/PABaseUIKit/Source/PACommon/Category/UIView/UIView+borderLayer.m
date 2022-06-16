//
//  UIView+borderLayer.m
//  PABase
//
//  Created by Juvid on 2018/1/11.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "UIView+borderLayer.h"
typedef NS_OPTIONS(NSUInteger, UIBorderSideType) {
    UIBorderSideTypeAll  = 0,
    UIBorderSideTypeTop = 1 << 0,
    UIBorderSideTypeBottom = 1 << 1,
    UIBorderSideTypeLeft = 1 << 2,
    UIBorderSideTypeRight = 1 << 3,
};

@implementation UIView (borderLayer)

-(void )juSetBorder:(CGRect)frame{
   
    [self juSetBorder:frame radius:0];

}
-(void )juSetBorder:(CGRect)frame radius:(CGFloat)radius{
    CAShapeLayer *border = [CAShapeLayer layer];

    border.strokeColor = UINormalColorHex(0x969696).CGColor;

    border.fillColor = nil;

    border.frame = frame;

    border.lineWidth = 1.0f;
//    border.lineCap = kCALineCapSquare;  // 线条拐角
//    border.lineJoin = kCALineCapRound;   //  终点处理
//    border.lineCap = @"square";

    if (radius>0) {
        border.cornerRadius = radius;
        UIRectCorner corners = UIRectCornerAllCorners;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:frame byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
        border.path = path.CGPath;
        border.lineDashPattern = @[@6, @6];//画虚线
    }else{
        border.path = [UIBezierPath bezierPathWithRect:frame].CGPath;
        border.lineDashPattern = @[@4, @2];
    }

    [self.layer addSublayer:border];

}

-(void)juSetRadii:(CGFloat)radii byRoundingCorners:(UIRectCorner)corners{
    [self juSetRadii:radii byRoundingCorners:corners frame:self.bounds];
}
-(void)juSetRadii:(CGFloat)radii byRoundingCorners:(UIRectCorner)corners frame:(CGRect)frame{
    [self.superview layoutIfNeeded];
    UIBezierPath *maskPath= [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radii, radii)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = frame;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}
-(void)juSetRadii:(CGFloat)radii byRoundingCorners:(UIRectCorner)corners borderStatu:(NSInteger)status{
    [self.superview layoutIfNeeded];
    UIBezierPath *maskPath= [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radii, radii)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    CGRect frame=self.bounds;
    maskLayer.frame = frame;
    maskLayer.path = maskPath.CGPath;
    /// 线的路径
    UIBezierPath * bezierPath = [UIBezierPath bezierPath];
    /// 左侧
    if (status==1) {
        [bezierPath moveToPoint:CGPointMake(0.0f, self.frame.size.height)];
        [bezierPath addArcWithCenter:CGPointMake(radii, radii) radius:radii startAngle:M_PI endAngle:3*M_PI/2 clockwise:YES];
        [bezierPath addArcWithCenter:CGPointMake(self.frame.size.width-radii, radii) radius:radii startAngle:3*M_PI/2 endAngle:2*M_PI clockwise:YES];
        [bezierPath addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
    }else if (status==2){
        [bezierPath moveToPoint:CGPointMake(0.0f, 0.0)];
        [bezierPath addArcWithCenter:CGPointMake(radii, self.frame.size.height-radii) radius:radii startAngle:M_PI endAngle:M_PI/2 clockwise:NO];
        [bezierPath addArcWithCenter:CGPointMake(self.frame.size.width-radii, self.frame.size.height-radii) radius:radii startAngle:M_PI/2 endAngle:2*M_PI clockwise:NO];
        [bezierPath addLineToPoint:CGPointMake(self.frame.size.width, 0)];
    }
        /// 左侧线路径

    CAShapeLayer *borderLayer=[CAShapeLayer layer];
//    frame.origin.y=2;
    borderLayer.path= bezierPath.CGPath;

    borderLayer.fillColor=JuColor_WhiteGray.CGColor;

//    borderLayer.strokeColor =UINormalColorHex(0x999999).CGColor;

    borderLayer.lineWidth= 1;
    borderLayer.shadowColor=UINormalColorHex(0x999999).CGColor;
    borderLayer.shadowOpacity=1;
    borderLayer.frame=frame;
    borderLayer.shadowOffset = CGSizeMake(0,1.5);
    borderLayer.shadowRadius=3;
    [self.layer insertSublayer:borderLayer atIndex:0];
    self.layer.mask = maskLayer;

//    self.layer.masksToBounds = NO;
//    self.layer.shadowOpacity = 1;
//    self.layer.shadowOffset = CGSizeZero;
//    self.layer.shadowColor=[UIColor redColor].CGColor;

}
/**
 设置view指定位置的边框

 @param originalView   原view
 @param color          边框颜色
 @param borderWidth    边框宽度
 @param borderType     边框类型 例子: UIBorderSideTypeTop|UIBorderSideTypeBottom
 @return  view
 */
- (UIView *)borderForView:(UIView *)originalView color:(UIColor *)color borderWidth:(CGFloat)borderWidth borderType:(NSInteger)borderType {

    if (borderType == UIBorderSideTypeAll) {
        originalView.layer.borderWidth = borderWidth;
        originalView.layer.borderColor = color.CGColor;
        return originalView;
    }

    /// 线的路径
    UIBezierPath * bezierPath = [UIBezierPath bezierPath];

    /// 左侧
    if (borderType & UIBorderSideTypeLeft) {
        /// 左侧线路径
        [bezierPath moveToPoint:CGPointMake(0.0f, originalView.frame.size.height)];
        [bezierPath addLineToPoint:CGPointMake(0.0f, 0.0f)];
    }

    /// 右侧
    if (borderType & UIBorderSideTypeRight) {
        /// 右侧线路径
        [bezierPath moveToPoint:CGPointMake(originalView.frame.size.width, 0.0f)];
        [bezierPath addLineToPoint:CGPointMake( originalView.frame.size.width, originalView.frame.size.height)];
    }

    /// top
    if (borderType & UIBorderSideTypeTop) {
        /// top线路径
        [bezierPath moveToPoint:CGPointMake(0.0f, 0.0f)];
        [bezierPath addLineToPoint:CGPointMake(originalView.frame.size.width, 0.0f)];
    }

    /// bottom
    if (borderType & UIBorderSideTypeBottom) {
        /// bottom线路径
        [bezierPath moveToPoint:CGPointMake(0.0f, originalView.frame.size.height)];
        [bezierPath addLineToPoint:CGPointMake( originalView.frame.size.width, originalView.frame.size.height)];
    }

    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = color.CGColor;
    shapeLayer.fillColor  = [UIColor clearColor].CGColor;
    /// 添加路径
    shapeLayer.path = bezierPath.CGPath;
    /// 线宽度
    shapeLayer.lineWidth = borderWidth;

    [originalView.layer addSublayer:shapeLayer];

    return originalView;
}

-(void)juCornerRadius:(CGFloat)radius{
    [self juBorderColor:nil radius:radius lineWidth:0];
}

-(void)juBorderColor:(UIColor *)color radius:(CGFloat)radius{
    [self juBorderColor:color radius:radius lineWidth:0.5];
}

-(void)juBorderColor:(UIColor *)color radius:(CGFloat)radius lineWidth:(CGFloat)lineWidth{
    [self.superview layoutIfNeeded];
    if (!self.layer.mask) {
        CGRect sBounds=self.bounds;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:sBounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius,radius)];

        if (radius>0) {
            //创建 layer
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = sBounds;
            //赋值
            maskLayer.path = maskPath.CGPath;
            self.layer.mask=maskLayer;
        }

        if (color) {
            //创建 layer
            CAShapeLayer *borderLayer = [[CAShapeLayer alloc] init];
            borderLayer.frame = sBounds;
            //赋值
            borderLayer.path = maskPath.CGPath;
            borderLayer.lineWidth = lineWidth;
            borderLayer.strokeColor = color.CGColor;
            borderLayer.fillColor = [UIColor clearColor].CGColor;
            [self.layer insertSublayer:borderLayer atIndex:0];
        }
    }
}

@end
