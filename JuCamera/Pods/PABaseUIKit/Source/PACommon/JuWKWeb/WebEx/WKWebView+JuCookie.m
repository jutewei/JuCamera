//
//  WKWebView+JuCookie.m
//  JuCycleScroll
//
//  Created by Juvid on 2019/6/19.
//  Copyright © 2019 Juvid. All rights reserved.
//
#define PAWKCookiesKey @"mtmfWk_cookie"
#import "WKWebView+JuCookie.h"

@implementation WKWebView (JuCookie)

/*-(void)setUserContentController:(NSString *)token{
//    JS携带cookie的形式
    WKUserContentController* userContentController= self.configuration.userContentController;
    if (!userContentController) {
        userContentController= WKUserContentController.new;
    }
//    document.cookie ='TeskCookieKey1=TeskCookieValue1';document.cookie = 'TeskCookieKey2=TeskCookieValue2';
    NSString *sringCookie=[NSString stringWithFormat:@"document.cookie ='juToken1=%@';",token];
    WKUserScript * cookieScript = [[WKUserScript alloc] initWithSource:sringCookie injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [userContentController addUserScript:cookieScript];

    WKWebViewConfiguration* webViewConfig = self.configuration;
    if (!webViewConfig) {
        webViewConfig=WKWebViewConfiguration.new;
    }
    webViewConfig.userContentController = userContentController;

}


- (void)setJavaScriptCookie:(NSString *)token{

    NSString *sringCookie=[NSString stringWithFormat:@"document.cookie ='juToken2=%@';",token];
    [self evaluateJavaScript:sringCookie completionHandler:^(id result, NSError *error) {
        ;
    }];


}

-(void)setRequest:(NSMutableURLRequest *)request withCookies:(NSString *)token{
    [request setValue:[NSString stringWithFormat:@"juToken3=%@", token] forHTTPHeaderField:@"Cookie"];
}

-(void)setJsCookie{

    //js函数
    NSString *JSFuncString =
    @"function setCookie(name,value,expires)\
    {\
    var oDate=new Date();\
    oDate.setDate(oDate.getDate()+expires);\
    document.cookie=name+'='+value+';expires='+oDate+';domain=www.jutewei.com;path=/'\
    }\
    function getCookie(name)\
    {\
    var arr = document.cookie.match(new RegExp('(^| )'+name+'=({FNXX==XXFN}*)(;|$)'));\
    if(arr != null) return unescape(arr[2]); return null;\
    }\
    function delCookie(name)\
    {\
    var exp = new Date();\
    exp.setTime(exp.getTime() - 1);\
    var cval=getCookie(name);\
    if(cval!=null) document.cookie= name + '='+cval+';expires='+exp.toGMTString();\
    }";

    //关联cookie时host 关联。
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    //拼凑js字符串
    NSMutableString *JSCookieString = JSFuncString.mutableCopy;
    for (NSHTTPCookie *cookie in cookieStorage.cookies) {
        NSString *excuteJSString = [NSString stringWithFormat:@"setCookie('%@', '%@', 36000);", @"juToken10", cookie.value];
        [JSCookieString appendString:excuteJSString];
    }
    //执行js
    [self evaluateJavaScript:JSCookieString completionHandler:^(id obj, NSError * _Nullable error) {
        ;
    }];
    [self evaluateJavaScript:@"getCookie('juToken10')" completionHandler:^(id obj, NSError * _Nullable error) {
        NSLog(@"获取cookies%@",obj);
    }];
}
*/
/***=============================================================================****/

/*+(NSString *)juGetCookieString{
    NSMutableDictionary *cookieDic = [NSMutableDictionary dictionary];
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
        [cookieDic setObject:cookie.value forKey:cookie.name];
    }

    NSMutableString *cookieValue = [NSMutableString stringWithFormat:@""];
    // cookie重复，先放到字典进行去重，再进行拼接
    for (NSString *key in cookieDic) {
        NSString *appendString = [NSString stringWithFormat:@"%@=%@;", key, [cookieDic valueForKey:key]];
        [cookieValue appendString:appendString];
    }
//    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
//    [request addValue:cookieValue forHTTPHeaderField:@"Cookie"];
//    NSLog(@"添加cookie");
//    [self loadRequest:request];
    return cookieValue;
}*/
- (void)setCookieValue:(NSString *)value expires:(NSString *)expires{

    if (value) {
        NSMutableDictionary *cookiePropertiesUser = [NSMutableDictionary dictionary];
        [cookiePropertiesUser setObject:@"juToken3" forKey:NSHTTPCookieName];
        [cookiePropertiesUser setObject:value forKey:NSHTTPCookieValue];
        [cookiePropertiesUser setObject:self.URL.host forKey:NSHTTPCookieDomain];
//        [cookiePropertiesUser setObject:@"www.baidu.com" forKey:NSHTTPCookieCommentURL];

        [cookiePropertiesUser setObject:@"/" forKey:NSHTTPCookiePath];
        [cookiePropertiesUser setObject:@"0" forKey:NSHTTPCookieVersion];

        [cookiePropertiesUser setObject:[[NSDate date] dateByAddingTimeInterval:expires.longLongValue] forKey:NSHTTPCookieExpires];
        NSHTTPCookie *cookieuser = [NSHTTPCookie cookieWithProperties:cookiePropertiesUser];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieuser];
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        NSLog(@"自定义cookies %@",[cookieStorage cookies]);

    }

    // set expiration to one month from now or any NSDate of your choosing
    // this makes the cookie sessionless and it will persist across web sessions and app launches
    /// if you want the cookie to be destroyed when your app exits, don't set this
//    [cookiePropertiesUser setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];

}
//清除cookie
+ (void)deleteCookie{

    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
        if ([cookie.name isEqual:@"mtSkinToken"]) {
            [cookieJar deleteCookie: cookie];
        }
    }
    if (@available(iOS 9.0, *)) {//iOS9及以上
        WKWebsiteDataStore *dateStore = [WKWebsiteDataStore defaultDataStore];
        [dateStore fetchDataRecordsOfTypes:[WKWebsiteDataStore allWebsiteDataTypes]
                         completionHandler:^(NSArray<WKWebsiteDataRecord *> * __nonnull records){
                             for (WKWebsiteDataRecord *record in records)
                             {
                                 if ( [record.displayName containsString:@"meitu.com"]) //取消备注，可以针对某域名做专门的清除，否则是全部清除
                                 {
                                 [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:record.dataTypes
                                                                           forDataRecords:@[record]
                                                                        completionHandler:^{
                                                                            NSLog(@"Cookies for %@ deleted successfully",record.displayName);
                                 }];
                                 }
                             }
        }];

//        NSArray * types=@[WKWebsiteDataTypeCookies,WKWebsiteDataTypeLocalStorage];
//        NSSet *websiteDataTypes= [NSSet setWithArray:types];
//        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
//        [dateStore removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{

//        }];
    } //iOS9以下
    else{
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        NSError *errors;
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
    }

}

// 清除全部缓存
+ (void)deleteWebCache {
    //allWebsiteDataTypes清除所有缓存
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{

    }];
}
// 自定义清除缓存
+ (void)customDeleteWebCache {
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
    NSArray * types=@[WKWebsiteDataTypeCookies,WKWebsiteDataTypeLocalStorage,WKWebsiteDataTypeDiskCache,WKWebsiteDataTypeMemoryCache,WKWebsiteDataTypeOfflineWebApplicationCache];

    NSSet *websiteDataTypes= [NSSet setWithArray:types];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];

    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{

    }];

}
/*
 *在收到响应后，决定是否跳转（同上）
 *该方法执行在内容返回之前*
 */
/*- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)navigationResponse.response;
    NSArray *cookies =[NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:response.URL];
    //读取wkwebview中的cookie 方法1
    for (NSHTTPCookie *cookie in cookies) {
        if (@available(iOS 11.0, *)) {
            //            [_webView.configuration.websiteDataStore.httpCookieStore setCookie:cookie completionHandler:^{
            //
            //            }];
        } else {
            // Fallback on earlier versions
        }
        //[[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        //NSLog(@"wkwebview中的cookie:%@", cookie);
        //s_cookie = cookie;
    }
    //读取wkwebview中的cookie 方法2 读取Set-Cookie字段
    NSString *cookieString = [[response allHeaderFields] valueForKey:@"Set-Cookie"];
    NSLog(@"wkwebview中的cookie:%@", cookieString);

    //看看存入到了NSHTTPCookieStorage了没有
    NSHTTPCookieStorage *cookieJar2 = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in cookieJar2.cookies) {
        NSLog(@"NSHTTPCookieStorage中的cookie%@", cookie);
    }

    decisionHandler(WKNavigationResponsePolicyAllow);

}*/

/***=============================================================================****/
/**iOS11之后**/
-(void)juGetCookie{
    //WKHTTPCookieStore的使用
    if (@available(iOS 11.0, *)) {
        WKHTTPCookieStore *cookieStore = self.configuration.websiteDataStore.httpCookieStore;
        //get cookies
        [cookieStore getAllCookies:^(NSArray<NSHTTPCookie *> * _Nonnull cookies) {
            NSLog(@"All cookies %@",cookies);
        }];
    } else {
        NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        NSArray *cookies=[cookieJar cookies];
        NSLog(@"All cookies %@",cookies);
        // Fallback on earlier versions
    }

}

-(void)juSetCookie{
    //发送请求前插入cookie；
    if (@available(iOS 11.0, *)) {
//        WKHTTPCookieStore *cookieStore = self.configuration.websiteDataStore.httpCookieStore;
//        [cookieStore setCookie:cookie completionHandler:nil];
    } else {
        // Fallback on earlier versions
    }
}

/***=============================================================================****/
//1. cookie的插入
- (void)insertCookie:(NSHTTPCookie *)cookie
{
    @autoreleasepool {

        if (@available(iOS 11.0, *)) {
            WKHTTPCookieStore *cookieStore = self.configuration.websiteDataStore.httpCookieStore;
            [cookieStore setCookie:cookie completionHandler:nil];
            return;
        }

        NSMutableArray *TempCookies = [NSMutableArray array];
        NSMutableArray *localCookies =[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey: PAWKCookiesKey]];
        for (int i = 0; i < localCookies.count; i++) {
            NSHTTPCookie *TempCookie = [localCookies objectAtIndex:i];
            if ([cookie.name isEqualToString:TempCookie.name]) {
                [localCookies removeObject:TempCookie];
                i--;
                break;
            }
        }
        [TempCookies addObjectsFromArray:localCookies];
        [TempCookies addObject:cookie];
        NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: TempCookies];
        [[NSUserDefaults standardUserDefaults] setObject:cookiesData forKey:PAWKCookiesKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

//2.NSHTTPCookieStorage 和本地磁盘cookie的同步
- (NSMutableArray *)sharedHTTPCookieStorage
{
    @autoreleasepool {
        NSMutableArray *cookiesArr = [NSMutableArray array];
        /** 获取NSHTTPCookieStorage cookies */
        NSHTTPCookieStorage * shareCookie = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie *cookie in shareCookie.cookies){
            [cookiesArr addObject:cookie];
        }

        /** 获取自定义存储的cookies */
        NSMutableArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey: PAWKCookiesKey]];

        //清除过期的cookies
        for (int i = 0; i < cookies.count; i++) {
            NSHTTPCookie *cookie = [cookies objectAtIndex:i];
            if (!cookie.expiresDate) {
                continue;
            }
            if ([cookie.expiresDate compare:[NSDate date]]) {
                [cookiesArr addObject:cookie];
            }else
            {
                [cookies removeObject:cookie];
                i--;
            }
        }
        //存储最新的cookies
        NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: cookies];
        [[NSUserDefaults standardUserDefaults] setObject:cookiesData forKey:PAWKCookiesKey];
        [[NSUserDefaults standardUserDefaults] synchronize];

        return cookiesArr;
    }
}

//3.WKHTTPCookieStore Cookie同步
- (void)syncCookiesToWKHTTPCookieStore:(WKHTTPCookieStore *)cookieStore API_AVAILABLE(macosx(10.13), ios(11.0))
{
    NSMutableArray *cookieArr = [self sharedHTTPCookieStorage];
    if (cookieArr.count == 0)return;
    for (NSHTTPCookie *cookie in cookieArr) {
        [cookieStore setCookie:cookie completionHandler:nil];
    }
}



//4.清除Cookie
/*- (void)deleteAllWKCookies
{
    if (@available(iOS 11.0, *)) {
        NSSet *websiteDataTypes = [NSSet setWithObject:WKWebsiteDataTypeCookies];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{

        }];
    }

    NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: @[]];
    [[NSUserDefaults standardUserDefaults] setObject:cookiesData forKey:PAWKCookiesKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}*/

@end
