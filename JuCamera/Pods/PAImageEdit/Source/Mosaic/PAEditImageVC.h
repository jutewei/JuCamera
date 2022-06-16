//
//  JuImageRotatingView.h
//  图片旋转
//
//  Created by Juvid on 2020/12/22.
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/6/29.
//

#import <UIKit/UIKit.h>
#import "PAEditConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface PAEditImageVC : UIViewController

/// 初始化马赛克编辑控制器
/// @param image 传入需要打码的图片
/// @param handle 回调，返回打码后的图片
-(instancetype)initWithImage:(UIImage *)image
                      handle:(JuImageResult)handle;

@property(nonatomic,copy)dispatch_block_t handleBack;

@end

NS_ASSUME_NONNULL_END
