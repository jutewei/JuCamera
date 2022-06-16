//
//  JuWebJSBridge.h
//  JuTestTest
//
//  Created by Juvid on 2018/10/15.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKWebView+config.h"
typedef void(^JuCallBackHandler)(id name, NSDictionary *paramter);
typedef void(^JuCompletionHandler)(id name,NSError *error);

@interface JuWebJSBridge : NSObject

+ (instancetype)bridgeForWebView:(id)webView;
/**注入js*/
-(void)juAddUserSeript:(NSString *)javaScriptSource;
/**js调用oc的方法***/
-(void)juAddScriptMessageName:(NSString *)name callBackHandler:(JuCallBackHandler)handler;

-(void)juEvaluateJavaScript:(NSString *)jsString  completionHandler:(JuCompletionHandler)handler;
/***oc调用js方法***/
-(void)juEvaluateJavaScript:(NSString *)name parameter:(NSArray *)parameter completionHandler:(JuCompletionHandler)handler;
/*设置字体*/
-(void)juSetFont:(CGFloat)scale;

/**设置暗黑模式*/
-(void)juSetDarkColor;

-(WKWebView *)webView;

@end
