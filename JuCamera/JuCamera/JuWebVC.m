//
//  JuWebVC.m
//  JuCamera
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2022/6/16.
//  Copyright © 2022 Juvid. All rights reserved.
//

#import "JuWebVC.h"
#import "JuAlertView+actiont.h"
#import "NSString+Format.h"

@interface JuWebVC ()

@end

@implementation JuWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *image=[UIImage imageNamed:@"show_more"];
    [self setBarRightItem:image];
    self.ju_rightBarItem.tintColor=[UIColor blackColor];
    [self.ju_rightBarItem setImage:image forState:UIControlStateNormal];

    // Do any additional setup after loading the view.
}

-(void)zlTouchRightItems:(UIButton *)sender{
    NSURL *url=self.zl_webView.URL?:[NSURL URLWithString:self.zl_url];
    if (!url) return;
    [JuAlertView juSheetControll:nil actionItems:@[@"复制",@"浏览器打开",@"取消"] handler:^(UIAlertAction *action) {
        if ([action.title isEqual:@"复制"]) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string=url.absoluteString;
            [MBProgressHUD juShowHUDText:@"复制成功"];
        }else if([action.title isEqual:@"浏览器打开"]){
            [[UIApplication sharedApplication]openURL:url];
        }
    }];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if (navigationAction.targetFrame==nil) {
        [webView loadRequest:navigationAction.request];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    NSURL* url = navigationAction.request.URL;
    if (url.scheme&&![url.scheme hasPrefix:@"http"]) {
        [[UIApplication sharedApplication]openURL:url];
        zl_loadIngView.ju_loadingType=JuLoadingSuccess;
        decisionHandler(WKNavigationActionPolicyCancel);
    }else{
        decisionHandler(WKNavigationActionPolicyAllow);
    }
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
