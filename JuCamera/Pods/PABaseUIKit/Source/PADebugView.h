//
//  PADebugView.h
//  PAImagePick
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2022/5/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PADebugView : UIControl

+ (instancetype) sharedInstance;

+(void)zlShowView:(dispatch_block_t)handle;

@end

NS_ASSUME_NONNULL_END
