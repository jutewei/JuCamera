//
//  UIView+highlight.h
//  PABase
//
//  Created by Juvid on 2018/10/18.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (highlight)
/*
 *注意：点击的视图无默认色时，会统一处理成白色
 */
@property (nonatomic,strong) UIColor *originalColor;///< 原始背景色
@property (nonatomic,strong) NSArray <UIColor *> *changColors;///< 需要改变的颜色
-(void)setJuSelectColor:(UIColor *)juSelectColor;
-(void)setJuSelect:(BOOL)juSelect;



@end
