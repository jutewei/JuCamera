//
//  JuWebVC.m
//  JuCamera
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2022/6/16.
//  Copyright © 2022 Juvid. All rights reserved.
//

#import "JuWebVC.h"

@interface JuWebVC ()

@end

@implementation JuWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if (navigationAction.targetFrame==nil) {
        [webView loadRequest:navigationAction.request];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    NSURL* url = navigationAction.request.URL;
    if (![url.scheme hasPrefix:@"http"]) {
        [[UIApplication sharedApplication]openURL:url];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
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
