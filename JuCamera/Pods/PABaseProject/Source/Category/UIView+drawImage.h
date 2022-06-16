//
//  UIView+drawImage.h
//  PABaseProject
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2022/5/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (drawImage)

/// 截屏
/// @param isPortrait 页面所有元素
+ (UIImage *)imageWithScreenshot:(BOOL)isPortrait;


/// 当前页面截屏
- (UIImage *)screenView;

@end

NS_ASSUME_NONNULL_END
