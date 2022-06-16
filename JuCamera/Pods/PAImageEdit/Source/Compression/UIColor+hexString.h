//
//  UIColor+hexString.h
//  TestImage
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/5/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (hexString)

+ (UIColor *)zlColorWithHexString:(NSString*)stringToConvert
                            alpha:(CGFloat)alpha;
@end

NS_ASSUME_NONNULL_END
