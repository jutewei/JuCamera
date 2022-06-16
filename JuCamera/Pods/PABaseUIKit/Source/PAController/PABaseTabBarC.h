//
//  PABaseTabBarC.h
//  PABase
//
//  Created by Juvid on 2021/4/19.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,JuTabbarClick) {
    ZLTabbarClickNone   =0,  ///< 切换回当前页
    ZLTabbarClickSingle =1,///< 当前页单机
    ZLTabbarClickDouble =2,///< 当前页双击
};
NS_ASSUME_NONNULL_BEGIN

@interface PABaseTabBarC : UITabBarController<UITabBarControllerDelegate>
-(void)zlInitViewControllers;
@end

NS_ASSUME_NONNULL_END
