//
//  PABaseWebVC.h
//  PABase
//
//  Created by Juvid on 2021/4/19.
//

#import "PABaseScrollVC.h"
#import "JuWebProgressView.h"
#import <WebKit/WebKit.h>
#import <WebKit/WKPreferences.h>
#import "JuLoadIngView.h"
//#import "PAWKWebView.h"

@interface PABaseWebVC : PABaseScrollVC<WKNavigationDelegate,UINavigationControllerDelegate,WKUIDelegate>{
    JuLoadIngView *zl_loadIngView;
    BOOL isHasTitle;
}

@property (strong, nonatomic) WKWebView *zl_webView;
@property (nonatomic, strong) NSString *zl_url;
-(void)zlLoadRequest;
-(void)zlGetTitle;
-(void)zlSetRequestHeader:(NSMutableURLRequest *)request;
@end


