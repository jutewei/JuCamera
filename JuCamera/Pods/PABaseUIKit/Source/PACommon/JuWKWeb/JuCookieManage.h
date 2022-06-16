//
//  JuCookieManage.h
//  JuTestTest
//
//  Created by Juvid on 2020/1/10.
//  Copyright © 2020 Juvid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN


@interface JuCookieManage : NSObject
//@property (nonatomic, strong) NSString *domain;

@property (nonatomic, strong,nullable) NSHTTPCookie * juCookie;

+ (instancetype)shareInstance;

#pragma mark - WKWebview
-(void)setCookieWithUserCC:(WKUserContentController *)userContentController
                   request:(NSMutableURLRequest *)request;
//在初始化 WKWebView 的时候，通过 WKUserScript 设置，使用Javascript 注入 Cookie。
+(void)setCookieWithUserCC:(WKUserContentController *)userContentController
                 cookieKey:(NSString *)cookieKey
               cookieValue:(NSString *)cookieValue;

/// 请求t提加cookie
/// @param request 网络请求
+(void)setCookieWithRequest:(NSMutableURLRequest *)request
                  cookieKey:(NSString *)cookieKey
                cookieValue:(NSString *)cookieValue;

/// 设置cookie
/// @param cookieHost 网页地址
/// @param comple 回调
+ (NSHTTPCookie *)setWkCookie:(NSURL *)cookieHost
          cookieKey:(NSString *)cookieKey
        cookieValue:(NSString *)cookieValue
  completionHandler:(nullable void (^)(void))comple;

/// 获取所有cookie
/// @param completionHandler 回调
+(void)juGetCookies:(void (^)(NSArray<NSHTTPCookie *> *))completionHandler;

///  删除指定名字域名
/// @param domain 域名
/// @param name cookie名字
+(void)juDeleteCookieWithDomain:(NSString *)domain withName:(NSString *)name;

// 清除全部缓存
+ (void)juDeleteWebCache;
@end

NS_ASSUME_NONNULL_END
