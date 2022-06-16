//
//  UIButton+juEnable.h
//  PABase
//
//  Created by Juvid on 2018/12/4.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (juEnable)
@property (nonatomic,strong) UIColor *orgFontColor;///< 原始字体颜色
-(void)setFontEnable:(BOOL)enable;
-(void)setBackEnable:(BOOL)enable;
@end

NS_ASSUME_NONNULL_END
