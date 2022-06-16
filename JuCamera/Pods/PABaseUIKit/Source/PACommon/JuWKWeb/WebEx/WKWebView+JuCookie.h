//
//  WKWebView+JuCookie.h
//  JuCycleScroll
//
//  Created by Juvid on 2019/6/19.
//  Copyright © 2019 Juvid. All rights reserved.
//


/**WKWebView携带cookie方法
 *1、js携带
 *2.请求头携带
 **/
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKWebView (JuCookie)

//-(void)setUserContentController:(NSString *)token;

//- (void)setJavaScriptCookie:(NSString *)token;

//- (void)setRequest:(NSMutableURLRequest *)request withCookies:(NSString *)token;

-(void)juGetCookie;

//-(void)setJsCookie;

//+ (NSString *)juGetCookieString;

- (void)setCookieValue:(NSString *)value  expires:(NSString *)expires;

+ (void)deleteCookie;

@end

NS_ASSUME_NONNULL_END
/*
 *WKWebView如何清除缓存
 WKWebView如何清除缓存

 而iOS8.0是有WKWebView， 但8.0的WKWebView没有删除缓存方法。iOS9.0之后就开始支持啦。
 所以使用时候一定要适配iOS9.0以上
 适用场景

 清除WKWebView的缓存，让H5页面一刷新就更新至最新的页面

 选择在合适逻辑加上以下代码：
 清除所有的缓存

 - (void)deleteWebCache {
 //allWebsiteDataTypes清除所有缓存
  NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];

     NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];

     [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{

     }];
 }
 自定义清除缓存

 - (void)deleteWebCache {

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

     NSArray * types=@[WKWebsiteDataTypeCookies,WKWebsiteDataTypeLocalStorage];

     NSSet *websiteDataTypes= [NSSet setWithArray:types];
     NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];

     [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{

     }];
 }
 但开发app必须要兼容所有iOS版本，可是iOS8，iOS7没有这种直接的方法，那该怎么办呢？
 （ 而iOS8.0是有WKWebView， 但8.0的WKWebView没有删除缓存方法。）
 针对与iOS7.0、iOS8.0、iOS9.0 WebView的缓存，我们找到了一个通吃的办法:
 NSString *libraryDir = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
 NSUserDomainMask, YES)[0];
 NSString *bundleId  =  [[[NSBundle mainBundle] infoDictionary]
 objectForKey:@"CFBundleIdentifier"];
 NSString *webkitFolderInLib = [NSString stringWithFormat:@"%@/WebKit",libraryDir];
 NSString *webKitFolderInCaches = [NSString
 stringWithFormat:@"%@/Caches/%@/WebKit",libraryDir,bundleId];
  NSString *webKitFolderInCachesfs = [NSString
  stringWithFormat:@"%@/Caches/%@/fsCachedData",libraryDir,bundleId];

 NSError *error;
 iOS8.0 WebView Cache的存放路径
 [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCaches error:&error];
 [[NSFileManager defaultManager] removeItemAtPath:webkitFolderInLib error:nil];

 iOS7.0 WebView Cache的存放路径
 [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCachesfs error:&error];
 *
 *
 */
