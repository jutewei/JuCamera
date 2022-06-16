//
//  JuButton.m
//  PABase
//
//  Created by Juvid on 2019/5/21.
//  Copyright © 2019 Juvid. All rights reserved.
//

#import "JuButton.h"

@implementation JuButton{
     UIColor *_selectColor;
     UIColor *_highlightColor;
     UIColor *_borderColor;
}

-(void)juTouchUpInside:(JuButtonHandle)handler{
    self.ju_handler=handler;
    [self addTarget:self action:@selector(juTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
}
-(void)juTouchUpInside{
    if (self.ju_handler) {
        self.ju_handler();
    }
}
/**设置不可点状态**/
-(void)setNormalColor:(UIColor *)normalColor{
    _normalColor=normalColor;
    self.backgroundColor=_normalColor;
}

-(void)setIsEnable:(BOOL)isEnable{
    self.enabled=isEnable;
    if (isEnable){
        self.backgroundColor=_normalColor;
        self.alpha=1.0;
    }else{
    //        self.backgroundColor=PFB_Color_ButtonEnable;
        self.alpha=0.5;
    }
}

/**设置背景图片**/
-(void)setSelectColor:(UIColor *)selectColor normalColor:(UIColor *)normalColor{
    if (selectColor) _selectColor=selectColor;
    if (normalColor) _normalColor=normalColor;
    [self setBackgroundImage];
}

-(void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [super traitCollectionDidChange:previousTraitCollection];
    if (_borderColor) {
        [self.layer setBorderColor:_borderColor.CGColor];
    }
    [self setBackgroundImage];
}
-(void)setBackgroundImage{
    if (_normalColor) {
        [self setBackgroundImage:[self colorImage:_normalColor] forState:UIControlStateNormal];
    }
    if (_selectColor) {
         [self setBackgroundImage:[self colorImage:_selectColor] forState:UIControlStateSelected];
    }
}
/*设置高亮状态*/
-(void) highlightColor:(UIColor *)highlightColor  normalColor:(UIColor *) normalColor{
    if (highlightColor) _highlightColor=highlightColor;
    if (normalColor) {
        _normalColor=normalColor;
        self.backgroundColor=normalColor;
    }
}
- (void) setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];

    if (!_highlightColor)   return;

    if (highlighted) {
        self.backgroundColor = _highlightColor;
    } else if (!highlighted && _normalColor) {
        self.backgroundColor = _normalColor;
    }

    for (UIView * view in self.subviews) {
        if ([view isKindOfClass:[UIControl class]]||[view isKindOfClass:[UILabel class]]) {
            [view setValue:@(highlighted) forKey:@"highlighted"];
        }
    }
}

- (UIImage *)colorImage:(UIColor *)color {
    CGSize size = CGSizeMake(3, 3);
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
