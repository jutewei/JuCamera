//
//  UIButton+juEnable.m
//  PABase
//
//  Created by Juvid on 2018/12/4.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "UIButton+juEnable.h"
#import <objc/runtime.h>
@implementation UIButton (juEnable)

-(void)setOrgFontColor:(UIColor *)orgFontColor{
    objc_setAssociatedObject(self, @selector(orgFontColor), orgFontColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UIColor *)orgFontColor{
    return objc_getAssociatedObject(self, @selector(orgFontColor));
}

-(void)setFontEnable:(BOOL)enable{
    if (!self.orgFontColor) {
        self.orgFontColor=self.backgroundColor;
    }
    if (enable) {
        self.userInteractionEnabled=YES;
        [self setTitleColor:self.orgFontColor forState:UIControlStateNormal];
        self.alpha=1.0;
    }else{
        [self setTitleColor:JUColor_ButtonEnable forState:UIControlStateNormal];
        self.alpha=0.8;
        self.userInteractionEnabled=NO;
    }
}

-(void)setBackEnable:(BOOL)enable{
    if (!self.orgFontColor) {
        self.orgFontColor=self.backgroundColor;
    }
    if (enable) {
        self.userInteractionEnabled=YES;
        self.backgroundColor=self.backgroundColor;
        self.alpha=1.0;
    }else{
        self.backgroundColor=JUColor_ButtonEnable;
        self.alpha=0.8;
        self.userInteractionEnabled=NO;
    }
}
@end
