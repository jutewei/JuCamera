//
//  UIView+keyBoard.h
//  PABase
//
//  Created by Juvid on 2018/12/11.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (keyBoard)
@property (weak,nonatomic) UIView *ju_moveView;
//获取控制器
-(UIViewController*)viewController;

@end

NS_ASSUME_NONNULL_END
