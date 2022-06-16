//
//  JuPhotoAlert.h
//  TestImage
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/4/27.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "JuPhotoConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface JuPhotoAlert : NSObject

+(UIAlertController *)juAlertTitle:(nullable NSString *)title
                           message:(nullable NSString *)message;

+(UIAlertController *)juAlertTitle:(nullable NSString *)title
                           message:(nullable NSString *)message
                            withVc:(nullable UIViewController *)vc;

+(UIAlertController *)juSheetControll:(nullable NSString *)title
                          actionItems:(NSArray *)items
                              handler:(void (^)(UIAlertAction *action))handle;

+(UIAlertController *)juAlertControllTitle:(nullable NSString *)title
                                     message:(nullable NSString *)message
                                 actionItems:(NSArray *)items
                              preferredStyle:(UIAlertControllerStyle)preferredStyle
                                    withVC:(nullable UIViewController *)vc
                                   handler:( void (^_Nullable)(UIAlertAction *action))handle;

+(UIViewController *)topViewControll;
@end

NS_ASSUME_NONNULL_END
