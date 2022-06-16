//
//  JuCookieManage.m
//  JuTestTest
//
//  Created by Juvid on 2020/1/10.
//  Copyright © 2020 Juvid. All rights reserved.
//

#import "JuCookieManage.h"
@implementation JuCookieManage
#pragma mark - WKWebview

+ (instancetype)shareInstance {
    static JuCookieManage *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[JuCookieManage alloc] init];
    });
    return manager;
}

-(void)setCookieWithUserCC:(WKUserContentController *)userContentController
                   request:(NSMutableURLRequest *)request{

    if (!_juCookie) return;

    NSHTTPCookie *cookie=_juCookie;
    NSString *string = [NSString stringWithFormat:@"%@=%@;domain=%@;expires=%@;path=%@",
                              cookie.name,
                              cookie.value,
                              cookie.domain,
                              cookie.expiresDate,
                              cookie.path ?: @"/"
                        ];

    NSString *cookieJs=[NSString stringWithFormat:@"document.cookie ='%@';",string];
    WKUserScript * cookieScript = [[WKUserScript alloc] initWithSource:cookieJs injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [userContentController addUserScript:cookieScript];

    [request setValue:string forHTTPHeaderField:@"Cookie"];
}

//在初始化 WKWebView 的时候，通过 WKUserScript 设置，使用Javascript 注入 Cookie。
+(void)setCookieWithUserCC:(WKUserContentController *)userContentController
                 cookieKey:(NSString *)cookieKey
               cookieValue:(NSString *)cookieValue{
    NSString *cookieJs=[NSString stringWithFormat:@"document.cookie ='%@=%@';",cookieKey,cookieValue];
//    NSString *cookieJs=[NSString stringWithFormat:@"document.cookie ='zhu=%@';document.cookie ='juTokenTest=zhutianwei1';document.cookie ='juTokenDomument=223456789823456';", cookieValue];
    WKUserScript * cookieScript = [[WKUserScript alloc] initWithSource:cookieJs injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [userContentController addUserScript:cookieScript];
}

/// 请求t提加cookie
/// @param request 网络请求
+(void)setCookieWithRequest:(NSMutableURLRequest *)request
                  cookieKey:(NSString *)cookieKey
                cookieValue:(NSString *)cookieValue{
    [request setValue:[NSString stringWithFormat:@"%@=%@",cookieKey, cookieValue] forHTTPHeaderField:@"Cookie"];
}

/// 设置cookie
+ (NSHTTPCookie *)setWkCookie:(NSURL *)cookieHost
          cookieKey:(NSString *)cookieKey
        cookieValue:(NSString *)cookieValue
  completionHandler:(nullable void (^)(void))comple {

    if (!cookieHost.host)  return nil;

//    NSURL *cookieHost =wkWebview.URL;
    NSString *path=[cookieHost.path stringByDeletingLastPathComponent];
    // 设定 cookie
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             [cookieHost host], NSHTTPCookieDomain,
                             path, NSHTTPCookiePath,
                             cookieKey,  NSHTTPCookieName,
                             cookieValue, NSHTTPCookieValue,
                             [NSDate dateWithTimeIntervalSinceNow:120*24*60*60],NSHTTPCookieExpires,
                             nil]];

    // 加入cookie
    //发送请求前插入cookie；


    if (@available(iOS 11.0, *)) {

        WKHTTPCookieStore *cookieStore = [WKWebsiteDataStore defaultDataStore].httpCookieStore;
        [cookieStore setCookie:cookie completionHandler:^{
            comple?comple():nil;
        }];
        WKWebView *web=[[WKWebView alloc]init];
        WKWebViewConfiguration *config= web.configuration;
        WKHTTPCookieStore *storeWeb=config.websiteDataStore.httpCookieStore;
        [storeWeb setCookie:cookie completionHandler:^{
            ;
        }];

    }
//        else {
           // 加入cookie
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];

//    }
    [JuCookieManage shareInstance].juCookie=cookie;
    return cookie;
}



/**iOS11之后**/
+(void)juGetCookies:(void (^)(NSArray<NSHTTPCookie *> *))completionHandler{
    //WKHTTPCookieStore的使用
    if (@available(iOS 11.0, *)) {
        WKHTTPCookieStore *cookieStore = [WKWebsiteDataStore defaultDataStore].httpCookieStore;
        //get cookies
        [cookieStore getAllCookies:^(NSArray<NSHTTPCookie *> * _Nonnull cookies) {
            NSLog(@"All WKHTTPCookies %@",cookies);
            if (completionHandler) {
                completionHandler(cookies);
            }
        }];
    }
//        else {
        NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        NSArray *cookies=[cookieJar cookies];
        NSLog(@"All NSHTTPCookies %@",cookies);
        if (completionHandler) {
            completionHandler(cookies);
        }
        // Fallback on earlier versions
//    }
}

+(void)juDeleteCookieWithDomain:(NSString *)domain withName:(NSString *)name{

    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
        if (domain&&[cookie.domain isEqual:domain]) {
            [cookieJar deleteCookie:cookie];
        }
        if (name&&[cookie.name isEqual:name]) {
            [cookieJar deleteCookie:cookie];
        }
    }

    if (@available(iOS 11.0, *)) {
        WKHTTPCookieStore *cookieStore = [WKWebsiteDataStore defaultDataStore].httpCookieStore;
        //get cookies
        [cookieStore getAllCookies:^(NSArray<NSHTTPCookie *> * _Nonnull cookies) {
            for (NSHTTPCookie *cookie in cookies) {
                if (domain&&[cookie.domain isEqual:domain]) {
                    [cookieStore deleteCookie:cookie completionHandler:nil];
                }
                if (name&&[cookie.name isEqual:name]) {
                    [cookieStore deleteCookie:cookie completionHandler:nil];
                }
            }
        }];
    }

    if (@available(iOS 9.0, *)) {//iOS9及以上
        [[WKWebsiteDataStore defaultDataStore] fetchDataRecordsOfTypes:[WKWebsiteDataStore allWebsiteDataTypes]
                         completionHandler:^(NSArray<WKWebsiteDataRecord *> * __nonnull records) {
            for (WKWebsiteDataRecord *record in records){
                if (domain&&[record.displayName containsString:domain]){ //取消备注，可以针对某域名做专门的清除，否则是全部清除
                    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:record.dataTypes
                                                              forDataRecords:@[record]
                                                           completionHandler:^{
                        NSLog(@"Cookies for %@ deleted successfully",record.displayName);
                    }];
                }
            }
        }];
//        按时间删除
//        NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
//            [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:[NSDate date] completionHandler:^{
//                NSLog(@"clear webView cache");
//            }];
    }
    else { //iOS9以下
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        NSError *errors;
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
    }
    
    [JuCookieManage shareInstance].juCookie=nil;
}
// 清除全部缓存
+ (void)juDeleteWebCache {
    //allWebsiteDataTypes清除所有缓存
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{

    }];
}
/*
在磁盘缓存上。
WKWebsiteDataTypeDiskCache,

html离线Web应用程序缓存。
WKWebsiteDataTypeOfflineWebApplicationCache,

内存缓存。
WKWebsiteDataTypeMemoryCache,

本地存储。
WKWebsiteDataTypeLocalStorage,

Cookies
WKWebsiteDataTypeCookies,

会话存储
WKWebsiteDataTypeSessionStorage,

IndexedDB数据库。
WKWebsiteDataTypeIndexedDBDatabases,

查询数据库。
WKWebsiteDataTypeWebSQLDatabases
*/
@end
