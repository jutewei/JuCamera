//
//  UIScrollView+manager.m
//  JuCycleScroll
//
//  Created by Juvid on 2018/7/3.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "UIScrollView+manager.h"
#import <objc/runtime.h>
@implementation UIScrollView (manager)

-(void)setJu_originalContInsets:(UIEdgeInsets )ju_originalContInsets{
    objc_setAssociatedObject(self, @selector(ju_originalContInsets), [NSValue valueWithUIEdgeInsets:ju_originalContInsets], OBJC_ASSOCIATION_COPY);
}

-(UIEdgeInsets)ju_originalContInsets{
     return [objc_getAssociatedObject(self, @selector(ju_originalContInsets)) UIEdgeInsetsValue];
}
-(CGFloat)contentMinX
{
    return [objc_getAssociatedObject(self, @selector(contentMinX)) intValue];
}
-(void)setContentMinX:(CGFloat)contentMinX
{
    objc_setAssociatedObject(self, @selector(contentMinX), @(contentMinX), OBJC_ASSOCIATION_COPY);
}


-(void)juSetContentMinX:(CGFloat)minX animated:(BOOL)animated{

//    static CGFloat contentMinX=0;
    if (self.contentMinX!=minX) {
        CGFloat width=CGRectGetWidth(self.frame);
        //    中间位置
        CGFloat offsetX=minX-width/2.0;
               ///< 控制末端
        if (offsetX+width>self.contentSize.width) {
            offsetX=self.contentSize.width-width;
        }
        [self setContentOffset:CGPointMake(MAX(0, offsetX), 0) animated:animated];
    }

    self.contentMinX=minX;
//    contentMinX=minX;
}
-(CGFloat)juTopEdge{
    CGFloat insetTop=self.contentInset.top;
    if (@available(iOS 11.0, *)) {
        insetTop+=self.adjustedContentInset.top;
    }
    return insetTop;
}
-(void)shSetEdgeBottom:(CGFloat)bottom{
    if (bottom>0) {
        self.ju_originalContInsets=self.contentInset;
    }
}
@end
