//
//  WKWebView+payfor.h
//  libwebp
//
//  Created by Juvid on 2020/3/19.
//

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKWebView (payfor)

/// 支付相关设置
/// @param request webView当前请求
/// @param schemes APP 支付 Schemes
- (BOOL)mtPayForManageRequest:(NSURLRequest *)request schemes:(NSArray *)schemes;

/// 跳出APP Scheme管理
/// @param requestUrl webView当前请求地址
-(BOOL)mtSchemeManage:(NSURL *)requestUrl;

@end

NS_ASSUME_NONNULL_END
