//
//  UIView+highlight.m
//  PABase
//
//  Created by Juvid on 2018/10/18.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "UIView+highlight.h"
#import <objc/runtime.h>

@implementation UIView (highlight)
/***属性的增加***/
-(void)setOriginalColor:(UIColor *)originalColor{
    objc_setAssociatedObject(self, @selector(originalColor), originalColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UIColor *)originalColor{
    return objc_getAssociatedObject(self, @selector(originalColor));
}

-(void)setChangColors:(NSArray *)changColors{
    objc_setAssociatedObject(self, @selector(changColors), changColors, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSArray *)changColors{
    return objc_getAssociatedObject(self, @selector(changColors));
}
/********************************************/

-(void)setJuSelectColor:(UIColor *)juSelectColor{
    if (juSelectColor) {
        if(!self.originalColor){
            self.originalColor=self.backgroundColor?self.backgroundColor:JuColor_WhiteGray;
        }
        self.backgroundColor=juSelectColor;
    }else{
        self.backgroundColor=self.originalColor;
    }
    self.juSelect=juSelectColor?YES:NO;
}
-(void)setJuSelect:(BOOL)juSelect{
    self.alpha=juSelect?0.9:1;
    [self getSubViews:self isSelect:juSelect];
}
-(void)getSubViews:(UIView *)view isSelect:(BOOL)isSelect{

    for (UIView *subView in view.subviews) {
        if (isSelect) {/// 需要改变颜色
            BOOL isChangColor=[self isWhiteColor:subView.backgroundColor]&&![subView isKindOfClass:[UIImageView class]];
            if (isChangColor) {
                if(!subView.originalColor)subView.originalColor=subView.backgroundColor;
                subView.backgroundColor=self.backgroundColor;
            }
        }
//        需要变回颜色
        else if (!isSelect&&subView.originalColor) {
            subView.backgroundColor=subView.originalColor;
        }
        [self getSubViews:subView isSelect:isSelect];
    }
}
//改变白色背景
-(BOOL)isWhiteColor:(UIColor *)color{
    if (self.changColors.count) {
        for (UIColor *col in self.changColors) {
            if ([color isEqual:col]) {
                return YES;
            }
        }
    }
    return [color isEqual:JuColor_WhiteGray];
}


/*
- (BOOL)getRGBWithAlpha:(UIColor *)color {
    if (!color) {
        return NO;
    }
    CGFloat red = 0.0;
    CGFloat green = 0.0;
    CGFloat blue = 0.0;
    CGFloat alpha = 0.0;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];

    return alpha==1;
}
*/
@end
