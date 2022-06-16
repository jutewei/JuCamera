//
//  JuAlertView+actiont.h
//  PABase
//
//  Created by Juvid on 2017/8/24.
//  Copyright © 2017年 Juvid. All rights reserved.
//

#import "JuAlertView.h"
//#import "JuImgDiaglogView.h"
@interface JuAlertView (actiont)

/// 带确定按钮弹框
/// @param title 标题
/// @param message 信息
+(UIAlertController *)juAlertControll:(nullable NSString *)title
                           message:(nullable NSString *)message;
/**
 中间弹框
 
 @param title   标题
 @param message 内容
 @param items   按钮
 @param handler 回调
 
 @return UIAlertController
 */
+(UIAlertController *)juAlertControll:(nullable NSString *)title
                           message:(nullable NSString *)message
                       actionItems:(NSArray *)items
                           handler:(void (^)(UIAlertAction *action))handler;


/// 中间弹框（指定控制器）
/// @param title 标题
/// @param message 内容
/// @param items 选项
/// @param vc 控制器
/// @param handler 回调
+(UIAlertController *)juAlertControll:(nullable NSString *)title
                           message:(nullable NSString *)message
                       actionItems:(NSArray *)items
                               withVC:(UIViewController *)vc
                              handler:(void (^)(UIAlertAction *action))handler;

/**
 底部弹框(默认vc)
 
 @param title   标题
 @param items   多个按钮
 @param handler 回调
 
 @return UIAlertController
 */
+(UIAlertController *)juSheetControll:(nullable NSString *)title
                       actionItems:(NSArray *)items
                           handler:(void (^)(UIAlertAction *action))handler;


/// 底部弹框（指定vc）
/// @param title 标题
/// @param items 选项
/// @param vc 控制器
/// @param handler 回调
+(UIAlertController *)juSheetControll:(nullable NSString *)title
                          actionItems:(NSArray *)items
                               withVC:(UIViewController *)vc
                              handler:(void (^)(UIAlertAction *action))handler;

@end
