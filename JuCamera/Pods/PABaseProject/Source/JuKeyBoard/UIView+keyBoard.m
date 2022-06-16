//
//  UIView+keyBoard.m
//  PABase
//
//  Created by Juvid on 2018/12/11.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "UIView+keyBoard.h"
#import <objc/runtime.h>
@implementation UIView (keyBoard)

-(void)setJu_moveView:(UIView *)ju_moveView{
    objc_setAssociatedObject(self, @selector(ju_moveView), ju_moveView, OBJC_ASSOCIATION_ASSIGN);
}

-(UIView *)ju_moveView{
    return objc_getAssociatedObject(self, @selector(ju_moveView));
}
//获取控制器
-(UIViewController*)viewController
{
    UIResponder *nextResponder =  self;
    do
    {
        nextResponder = [nextResponder nextResponder];

        if ([nextResponder isKindOfClass:[UIViewController class]])
            return (UIViewController*)nextResponder;

    } while (nextResponder != nil);

    return nil;
}

@end
