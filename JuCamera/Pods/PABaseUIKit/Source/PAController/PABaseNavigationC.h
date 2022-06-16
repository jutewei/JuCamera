//
//  PABaseNavigationC.h
//  PABase
//
//  Created by Juvid on 2021/4/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PABaseNavigationC : UINavigationController
@property BOOL isPreviewPush;///< 按压使用
/**
 *  @author Juvid, 21-03-19 11:07:16
 *
 *  初始化通用导航栏
 *
 *
 *  @return 导航栏
 */
+(instancetype)zlBasicNation:(UIViewController *)rootViewController;
@end

NS_ASSUME_NONNULL_END
