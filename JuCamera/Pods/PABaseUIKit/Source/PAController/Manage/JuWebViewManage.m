//
//  JuWebViewManage.m
//  PABase
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/6/1.
//

#import "JuWebViewManage.h"
@implementation JuWebViewManage{
    WKWebView *ju_wkWebView;
    WKWebView *ju_cacheWeb;
}

+(void)load{
    juDis_mian_after(3, ^{
        [JuWebViewManage sharedInstance];
    });
}

+ (instancetype) sharedInstance{
    static JuWebViewManage *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance webPreLoad];
    });
    return sharedInstance;
}

//初始化WKWebview内核
-(void)webPreLoad{
    ju_cacheWeb=[[WKWebView alloc]init];
    [ju_cacheWeb loadRequest:[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    juDis_mian_after(3, ^{
        self->ju_cacheWeb=nil;
    });
    [self juSetWebView];
}

-(WKWebView *)juGetWebview{
    WKWebView *webView=[self juSetWebView];
    ju_wkWebView=nil;
    [self juResetWebView];
    return webView;
}

-(WKWebView *)juSetWebView{
    if (!ju_wkWebView) {
        WKWebView  *_zl_webView=[[WKWebView alloc]init];
        _zl_webView.allowsBackForwardNavigationGestures=YES;
        _zl_webView.opaque = NO;
        ju_wkWebView=_zl_webView;
//        NSLog(@"webView初始化完成");
    }
    return ju_wkWebView;
}

-(void)juResetWebView{
    juDis_mian_after(3, ^{
        self->ju_wkWebView=nil;
        [self juSetWebView];
    });
}

@end



