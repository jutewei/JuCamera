//
//  UIControl+Touch.m
//  PABase
//
//  Created by Juvid on 2017/12/6.
//  Copyright © 2017年 Juvid. All rights reserved.
//

#import "UIControl+Touch.h"
#import <objc/runtime.h>
#define MinEdge  36

@implementation UIControl (Touch)

-(void)setCanEnable:(BOOL)isEnable{
    self.enabled=isEnable;
    self.alpha=isEnable?1:0.5;
}

-(void)setIsEnlargeEdge:(BOOL)isEnlargeEdge{
    objc_setAssociatedObject(self, @selector(isEnlargeEdge),[NSNumber numberWithBool:isEnlargeEdge], OBJC_ASSOCIATION_COPY);
}

-(BOOL)isEnlargeEdge{
    return [objc_getAssociatedObject(self, @selector(isEnlargeEdge)) boolValue];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    CGFloat width=CGRectGetWidth(self.frame);
    CGFloat height=CGRectGetHeight(self.frame);
    if (MIN(width, height)<MinEdge&&self.isEnlargeEdge) {
        CGRect bounds = CGRectInset(self.bounds, -MAX((MinEdge-width)/2, 0), -MAX((MinEdge-height)/2, 0));
        return CGRectContainsPoint(bounds, point);
    }
    return [super pointInside:point withEvent:event];
}

@end


@implementation UITouchEdgeButton

-(void)didMoveToSuperview{
    [super didMoveToSuperview];
    self.isEnlargeEdge=YES;
}

@end
