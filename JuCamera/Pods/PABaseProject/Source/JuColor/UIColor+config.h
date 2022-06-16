//
//  UIColor+config.h
//  PABase
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/5/31.
//

#import <UIKit/UIKit.h>
#import "UIColor+Dark.h"
NS_ASSUME_NONNULL_BEGIN

@interface UIColor (config)

+(UIColor *)zlWhite;

+(UIColor *)zlBackground;

+(UIColor *)zlBlackText;

+(UIColor *)zlBlack;

+(UIColor *)zlBlackGray;

+(UIColor *)zlDark;

+(UIColor *)zlLightGray;

+(UIColor *)zlWhiteGray;

+(UIColor *)zlLoginBlue;

+(UIColor *)zlMain;

+(UIColor *)zlMessageRed;

+(UIColor *)zlStarYellow;

+(UIColor *)zlStatusBack;

+(UIColor *)zlStarContent;

+(UIColor *)zlChatBack;

+(UIColor *)zlImageBack;

@end

@interface UIFont (config)

+(UIFont *)zlTopBarTitle:(BOOL)isMedium;

+(UIFont *)zlTitleText:(BOOL)isMedium;

+(UIFont *)zlSecondText:(BOOL)isMedium;

+(UIFont *)zlNormalText:(BOOL)isMedium;

+(UIFont *)zlNormal2Text:(BOOL)isMedium;

+(UIFont *)zlLittleText:(BOOL)isMedium;

+(UIFont *)zlLittleText0:(BOOL)isMedium;

+(UIFont *)zlSmallText:(BOOL)isMedium;

@end

NS_ASSUME_NONNULL_END
