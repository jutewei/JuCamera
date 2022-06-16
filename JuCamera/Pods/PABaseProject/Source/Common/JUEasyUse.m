//
//  EasyUseVersion.m
//  models
//
//  Created by juvid on 13-9-23.
//  Copyright (c) 2013年 Juvid(zhutianwei). All rights reserved.
//

#import "JUEasyUse.h"
#import <CommonCrypto/CommonCrypto.h>
#import <sys/utsname.h>
#import <WebKit/WebKit.h>
#import <AdSupport/AdSupport.h>
#import "JuSystemDefine.h"
#import "NSObject+Safety.h"

@implementation JUEasyUse


+(UIImage *)juStretchableImg:(NSString *)imgName leftW:(float)width topH:(float)height{
    UIImage *stretchImg = [[UIImage imageNamed:imgName] stretchableImageWithLeftCapWidth:width  topCapHeight:height];
    return stretchImg;
}

+(void)tellPhone:(NSString *)phoneNum{
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]]];
}


//单个文件的大小
+ (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
//遍历文件夹获得文件夹大小，返回多少M
+ (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}
+(NSString *)appVersion{
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *nowVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
    return nowVersion;
}
+(NSString *)appBuildNumber{
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *nowVersion = [infoDict objectForKey:@"CFBundleVersion"];
    return nowVersion;
}
+(NSString *)appBundleId{
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *appBundleId = [infoDict objectForKey:@"CFBundleIdentifier"];
    return appBundleId;
}

+(NSString *)appDisplayName{
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *displayName=[infoDict objectForKey:@"CFBundleName"];
    return displayName;
}


/** 设备型号 */
+ (NSString *)deviceModel {
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}
/** iOS系统版本号 */
+ (NSString *)sysVersion {
    return [UIDevice currentDevice].systemVersion;
}
/** OpenUDID */
//+ (NSString *)getOpenUDID {
//    @synchronized (self) {
//        NSString *openUDID  = [NSUSER_DEFAULTS objectForKey:@"JU_OpenUDID"] ;
//        if ([openUDID safeStr].length == 0) {
//            unsigned char result[16];
//            const char *cStr = [[[NSProcessInfo processInfo] globallyUniqueString] UTF8String];
//            CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
//            openUDID = [NSString stringWithFormat:
//                        @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%08x%08x",
//                        result[0], result[1], result[2], result[3],
//                        result[4], result[5], result[6], result[7],
//                        result[8], result[9], result[10], result[11],
//                        result[12], result[13], result[14], result[15],
//                        (unsigned int)(arc4random() % UINT32_MAX),
//                        (unsigned int)([[NSDate date] timeIntervalSince1970])];
//            [NSUSER_DEFAULTS setObject:openUDID forKey:@"JU_OpenUDID"];
//        }
//        
//        return openUDID;
//    }
//}

+(UIEdgeInsets)juSafeAreaInsets{
    if (@available(iOS 11.0, *)) {
        return [UIApplication sharedApplication].keyWindow.safeAreaInsets;
    } else {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

+(UIView *)juCopyView:(UIView *)view{
    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:view];
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
}
/**同意用户协议**/
//+(void)juSetAgreeOn{
//    [NSUSER_DEFAULTS setBool:YES forKey:@"PAUserAgree"];
//}
//+(BOOL)isAgreeOn{
//    return   [NSUSER_DEFAULTS boolForKey:@"PAUserAgree"];
//}

+(void)juCheckSDKUserAgent:(NSString *)name{
    [self juSetUserAgent:[NSString stringWithFormat:@"paManage_%@_ios/%@",name,[self appVersion]] completionHandler:^(NSString *newAgent) {
    }];
}

+(void)juSetUserAgent:(NSString *)name completionHandler:(void (^)(NSString *newAgent))handler{
    WKWebView *webView = [[WKWebView alloc] init];
    [webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(NSString *results, NSError * _Nullable error) {
        if (!error){
            __strong typeof(webView) strongWeb=webView;
            NSString *newAgent = results;
            if (![results containsString:name]) {///< 只加一次
                newAgent = [results stringByAppendingFormat:@" %@",name];
                [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":newAgent}];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [strongWeb setCustomUserAgent:newAgent];
            }
            if (handler) {
                handler(newAgent);
            }
        }
    }];
}
+(UIWindow *)mainWindow{
    UIWindow *window=[UIApplication sharedApplication].delegate.window;
    if (!window) {
        window=[UIApplication sharedApplication].windows.firstObject;
    }
    return window;
}
+(UITabBarController *)juRootWindowVC{
    UIViewController *tabVc=[UIApplication sharedApplication].delegate.window.rootViewController;
    if ([tabVc isKindOfClass:[UITabBarController class]]) {
        return (UITabBarController *)tabVc;
    }
    return nil;
}
/**获取推送token*/
+(NSString *)getTokenString:(NSData *)deviceToken{
    if ([deviceToken isEqual:[NSData data]]) {
        NSMutableString *deviceTokenString = [NSMutableString string];
        const char *bytes = deviceToken.bytes;
        NSInteger dCount = deviceToken.length;
        for (int i = 0; i < dCount; i++) {
            [deviceTokenString appendFormat:@"%02x", bytes[i]&0x000000FF];
        }
        return deviceTokenString;
    }
    return @"";
}
/**ios13删除老启动页**/
+(void)juRemoveSplashBoard{
    if (![[NSUSER_DEFAULTS objectForKey:@"launch_version"]isEqualToString:[JUEasyUse appVersion]]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask, YES);
        NSString *path=[paths.firstObject stringByAppendingPathComponent:@"SplashBoard"];
        NSError *error=nil;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:path]) {
            [fileManager removeItemAtPath:path error:&error];
        }
        [NSUSER_DEFAULTS setValue:[JUEasyUse appVersion] forKey:@"launch_version"];
    }
}
+(void)juNotificationOff:(BOOL)isShow{
    if (!TARGET_IPHONE_SIMULATOR){///< 真机提示
        NSTimeInterval nowTime=[[NSDate date]timeIntervalSince1970];
        NSInteger showTimes=[NSUSER_DEFAULTS integerForKey:@"remoteNotiicationWarn"];
        NSTimeInterval moreTime=nowTime-showTimes;
        
        if ((showTimes>0&&moreTime>10*60)||isShow) {
            [NSUSER_DEFAULTS setValue:@([[NSDate date]timeIntervalSince1970]) forKey:@"remoteNotiicationWarn"];
            [NSUSER_DEFAULTS synchronize];
//            [EasyUse mtNotificationCheck];
        }
    }
}
//+(NSString *)juUUIDString{
//    return [self getIdfv:YES];
//}
//
//+ (NSString *)juIDFVString
//{
////    if([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {
////        return [[UIDevice currentDevice].identifierForVendor UUIDString];
////    }
//    return [self getIdfv:NO];
//}
//
//+ (NSString *)getIdfv:(BOOL)isSample{
//    NSString *uuid=[UIDevice currentDevice].identifierForVendor.UUIDString;
//    if (isSample&&uuid.length) {
//        uuid = [uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
//    }
//    return uuid;
//}


//+ (NSString *)idfaString:(void(^)(NSString *idfas))complete {
//    return [self advertisingIdentifier];
//}
//
//+(NSString *)advertisingIdentifier{
//    NSString *idfa = @"";
//    ASIdentifierManager *asIM = [ASIdentifierManager sharedManager];
//    if ([asIM isAdvertisingTrackingEnabled]) {
//        idfa = [asIM.advertisingIdentifier UUIDString];
//    }
//    if (idfa.length) {
//        // iOS10 开启 "广告限制追踪" 会返回一个全0的值
//        NSString *tempStr = [idfa stringByReplacingOccurrencesOfString:@"0" withString:@""];
//        tempStr = [tempStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
//        if (!tempStr.length) {
//            idfa = @"";
//        }
//    }
//    return idfa;
//}

@end



