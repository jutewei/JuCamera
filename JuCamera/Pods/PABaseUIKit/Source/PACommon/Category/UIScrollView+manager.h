//
//  UIScrollView+manager.h
//  JuCycleScroll
//
//  Created by Juvid on 2018/7/3.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (manager)
@property (nonatomic,assign) UIEdgeInsets ju_originalContInsets;///< 原始边界值
-(void)juSetContentMinX:(CGFloat)minX animated:(BOOL)animated;
-(CGFloat)juTopEdge;
@end
