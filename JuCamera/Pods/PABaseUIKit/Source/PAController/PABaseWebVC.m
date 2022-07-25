//
//  PABaseWebVC.m
//  PABase
//
//  Created by Juvid on 2021/4/19.
//

#import "PABaseWebVC.h"
//#import "PANetworkStatus.h"
#import "JuStringsManager.h"
#import <NSString+Format.h>
#import "JuWebViewManage.h"
#import "JuFileManage.h"

@interface PABaseWebVC (){
    JuWebProgressView *_progressView;
}

@end

@implementation PABaseWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self zlSetNavLeftItem:NO];
    isHasTitle=self.zl_barTitle;
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    zl_scrollView.delegate=self;
    [self.navigationController.navigationBar addSubview:_progressView];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_progressView removeFromSuperview];
    zl_scrollView.delegate=nil;
}

-(void)zlSetManageConfig{
    [super zlSetManageConfig];
    self.ju_dataManage.zl_noDataText=MTWarnWord(@"noProject");
}
//初始化WebView
-(void)zlSetScrollView{
    [self initWebView];
    [self.view addSubview:_zl_webView];
    [self zlSetContentFrame:_zl_webView];
    _zl_webView.backgroundColor=[UIColor whiteColor];
    self.zl_scrollView=_zl_webView.scrollView;
    [self zlSetObserver:YES];
    [self zlLoadRequest];

}
-(void)initWebView{
    _zl_webView=[[JuWebViewManage sharedInstance]juGetWebview];
    _zl_webView.navigationDelegate = self;
    _zl_webView.UIDelegate=self;
}
-(void)zlGetBaseData{
    if (_zl_webView.URL) {
        [_zl_webView reload];
        [self zlSetProgress];
    }else{
        [self zlLoadRequest];
    }
}

-(void)zlLoadRequest{
    self.zl_url=[self.zl_url juUrlEncoding];
    if([self.zl_url hasPrefix:@"file://"]){
        NSURL *baseURL = [NSURL URLWithString:self.zl_url];
        [self.zl_webView loadFileURL:baseURL allowingReadAccessToURL:baseURL];
        [self zlSetProgress];
    }
    else{
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_zl_url]];
//        if ([PANetworkStatus sharedNet].zl_connectionRequired) {
            [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
//        }
        [self zlSetRequestHeader:request];
        [request setTimeoutInterval:60];
        [self.zl_webView loadRequest:request];
        [self zlSetProgress];
    }

}
#pragma mark - 存储PDF文件
-(NSString *)juSaveFile:(NSString *)url {
    if (url.length) {
        NSData *fileData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url] options:NSDataReadingMappedIfSafe error:nil];
        NSString *path=[JuFileManage juSaveCacheData:fileData folder:@"PAFileCache" suffix:url.pathExtension];
        if (path) {
            NSURL *pathUrl=[NSURL fileURLWithPath:path];
            return pathUrl.absoluteString;
        }
    }
    return @"";
}
-(void)zlSetRequestHeader:(NSMutableURLRequest *)request{

}

-(void)zlTouchLeftItems:(UIButton *)sender{
    if (sender&&sender.tag==10&&self.zl_webView.canGoBack) {
        [self.zl_webView goBack];
    }
    else{
        [super zlTouchLeftItems:nil];
    }
}

-(void)zlSetProgress{
    WeakSelf
    if (!zl_loadIngView) {
        zl_loadIngView=[[JuLoadIngView alloc]initWithView:self.view];
        zl_loadIngView.ju_rereshHandle = ^{
            [weakSelf zlGetBaseData];
        };
    }
    if(!_progressView){
        _progressView = [JuWebProgressView juInitWithView:self.navigationController.navigationBar];
    }
    [_progressView setProgress:0 animated:YES];
    zl_loadIngView.ju_loadingType=JuLoadingIng;
}
//设置导航栏关闭按钮
-(void)zlSetNavLeftItem:(BOOL)isCanBack{

    if (self.ju_barStatus==JuNavBarStatusClear)  return;

    if (isCanBack) {
        [self setBarLeftItems:NSArray.juImages(@[@"main_NavBarBack",@"main_navBarClose"])];
    }else{
        [self setBarLeftItems:NSArray.juImages(@[@"main_NavBarBack"])];
    }
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if (navigationAction.targetFrame==nil) {
        [webView loadRequest:navigationAction.request];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
//    if (((NSHTTPURLResponse *)navigationResponse.response).statusCode == 403) {
//        [MBProgressHUD juShowHUDText:@"没有访问权限(403)"];
//        decisionHandler (WKNavigationResponsePolicyCancel);
//    } else {
        decisionHandler(WKNavigationResponsePolicyAllow);
//    }
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    zl_loadIngView.ju_loadingType=JuLoadingSuccess;
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    if (zl_loadIngView.ju_loadingType!=JuLoadingSuccess) {
        zl_loadIngView.ju_loadingType=JuLoadingFailure;
        [self setIsFailStatus:YES];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        //不要让进度条倒着走...有时候goback会出现这种情况
        if ([change[@"new"] floatValue] < [change[@"old"] floatValue]) {
            return;
        }
        [_progressView setProgress:[change[@"new"] floatValue] animated:YES];
    }else if([keyPath isEqualToString:@"title"]){
        [self zlGetTitle];
    }else if([keyPath isEqualToString:@"canGoBack"]){
        [self zlSetNavLeftItem:[change[@"new"]boolValue]];
    }
    else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

-(void)zlGetTitle{
    Ju_Share.ju_finishData=[NSDate date];
    if (_zl_webView.title.length==0) {
        return;
    }
    self.zl_barTitle=_zl_webView.title;
    if(!isHasTitle){
        self.title = self.zl_barTitle;
    }
}

-(NSArray *)observers{
    return @[@"estimatedProgress",@"title",@"canGoBack"];
}

-(void)zlSetObserver:(BOOL)isAdd{
    NSArray *list=self.observers;
    for (NSString *key in list) {
        if (isAdd) {
            [_zl_webView addObserver:self forKeyPath:key options:NSKeyValueObservingOptionNew context:nil];
        }else{
            [_zl_webView removeObserver:self forKeyPath:key];
        }
    }
}
-(void)dealloc{
    [self.zl_webView stopLoading];
    [self zlSetObserver:NO];
//    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    self.zl_webView.UIDelegate = nil;
    self.zl_webView = nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
