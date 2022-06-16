//
//  EasyUseVersion.h
//  models
//
//  Created by juvid on 13-9-23.
//  Copyright (c) 2013年 Juvid(zhutianwei). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JUEasyUse : NSObject

+(UIImage *)juStretchableImg:(NSString *)imgName leftW:(float)width topH:(float)height;

//呼叫
+(void)tellPhone:(NSString *)phoneNum;
//获取文件路径方法

//单个文件的大小
+ (long long) fileSizeAtPath:(NSString*) filePath;

//遍历文件夹获得文件夹大小，返回多少M
+ (float ) folderSizeAtPath:(NSString*) folderPath;

+(NSString *)appVersion;

+(NSString *)appBuildNumber;

+(NSString *)appBundleId;

/** 设备型号 */
+ (NSString *)deviceModel ;

/** iOS系统版本号 */
+ (NSString *)sysVersion;

/**app名字**/
+(NSString *)appDisplayName;

+(void)juNotificationOff:(BOOL)isShow;
//+(NSString *)getOpenUDID ;

//+(void)mtNotificationCheck;

/**
 复制视图
 
 @param view 被复制的视图
 @return 复制的视图
 */
+(UIView *)juCopyView:(UIView *)view;

/**
 安全区域

 @return 边距距离
 */
+(UIEdgeInsets)juSafeAreaInsets;

//+(void)juSetAgreeOn;
//
//+(BOOL)isAgreeOn;

+(void)juCheckSDKUserAgent:(NSString *)name;

/**UA设置*/
+(void)juSetUserAgent:(NSString *)name
    completionHandler:(void (^)(NSString *newAgent))handler;

+(NSString *)getTokenString:(NSData *)deviceToken;

+(UIWindow *)mainWindow;

+(UITabBarController *)juRootWindowVC;
/**ios13删除老启动页**/
+(void)juRemoveSplashBoard;

//+(NSString *)juUUIDString;
//
//+ (NSString *)juIDFVString;

//+ (NSString *)idfaString:(void(^)(NSString *idfas))complete;

@end

