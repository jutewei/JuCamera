//
//  MBProgressHUD+Share.h
//  PABase
//
//  Created by Juvid on 2016/11/18.
//  Copyright © 2016年 Juvid(zhutianwei). All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Share)
+(void )juShowWindowHUD:(NSInteger)tag;
+(void)juShowHideHUD:(NSInteger)tag;
/**
 弹框文本提示

 @param str 弹框内容
 @return 弹框view
 */
+(MBProgressHUD *)juShowHUDText:(NSString *)str;
+(MBProgressHUD *)juShowHUDCenter:(NSString *)str;
+(MBProgressHUD *)juShowHUDCenter:(NSString *)str afterDelay:(NSTimeInterval)delay;
/**
 弹框文本加图片提示

 @param str 弹框文本
 @param status 图片资源
 @return 弹框
 */
+(MBProgressHUD *)juShowHUDText:(NSString *)str withStaus:(NSString *)status ;

/**
 独立的弹框

 @param str 内容
 @return 描述
 */
+(MBProgressHUD *)juShowTopHint:(NSString *)str;
/**
 弹框单例

 @param view supview
 @return 弹框
 */
+(MBProgressHUD *)juShowHUDShare:(UIView *)view;

/**
 弹框单例加载中

 @param info 名字
 */
+ (MBProgressHUD *)juShowHUDLoad:(NSString *)info;
/**
 弹框消失
 */
+(void)juHideLoadHUD;
@end
