//
//  WKWebView+payfor.m
//  libwebp
//
//  Created by Juvid on 2020/3/19.
//

#import "WKWebView+payfor.h"

@implementation WKWebView (payfor)

- (BOOL)mtPayForManageRequest:(NSURLRequest *)request schemes:(NSArray *)schemes{
    NSURL *requestUrl=request.URL;
    if (schemes.count==0) {
        return [self mtSchemeManage:requestUrl];
    }
    NSString *absoluteString = requestUrl.absoluteString;
    //    微信支付跳回APP
    if ([absoluteString hasPrefix:@"https://wx.tenpay.com/cgi-bin/mmpayweb-bin/checkmweb"]) {
        NSURL *referer=[NSURL URLWithString:(request.allHTTPHeaderFields[@"Referer"])];
        NSString *payScheme=[self mtGetScheme:schemes host:referer];
        NSString *wxRedirectUrl=[NSString stringWithFormat:@"redirect_url=%@://",payScheme];//@"redirect_url=meitu.paycenter.ehaoyao.com"
        if (payScheme&&![absoluteString containsString:wxRedirectUrl]) {
            NSString *redirectUrl = nil;
            if ([absoluteString containsString:@"redirect_url="]) {
                NSRange redirectRange = [absoluteString rangeOfString:@"redirect_url="];
                redirectUrl = [[absoluteString substringToIndex:redirectRange.location] stringByAppendingString:[NSString stringWithFormat:@"%@?skindocwxpayfor:%@",wxRedirectUrl,[absoluteString substringFromIndex:redirectRange.location+redirectRange.length]]];
            } else {
                redirectUrl = [absoluteString stringByAppendingString:[NSString stringWithFormat:@"%@",wxRedirectUrl]];
            }
            NSMutableURLRequest *newRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:redirectUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
            newRequest.allHTTPHeaderFields = request.allHTTPHeaderFields;
            [newRequest setValue:[NSString stringWithFormat:@"%@",payScheme] forHTTPHeaderField: @"Referer"];
            [self loadRequest:newRequest];
            return YES;
        }
    }
    //    微信支付后回调
    else if ([schemes containsObject:requestUrl.scheme]) {
        NSString *urlNew=requestUrl.resourceSpecifier;
        urlNew=[urlNew stringByReplacingOccurrencesOfString:@"?skindocwxpayfor:" withString:@""];
        NSMutableURLRequest *newRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlNew] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
        newRequest.allHTTPHeaderFields = request.allHTTPHeaderFields;
        [self loadRequest:newRequest];
        return YES;
     }
    //         支付宝支付调回APP
    else if ([absoluteString hasPrefix:@"alipay://alipayclient/"]){
         NSString *shchemeUrl=[absoluteString stringByReplacingOccurrencesOfString:@"alipays" withString:schemes.firstObject];
         requestUrl=[NSURL URLWithString:shchemeUrl];
         [[UIApplication sharedApplication] openURL:requestUrl];
         return YES;
     }
    return [self mtSchemeManage:requestUrl];
}

-(NSString *)mtGetScheme:(NSArray *)schemes host:(NSURL *)referer {
    for (NSString *scheme in schemes) {
        if (referer.host){///< 未被替换
            NSString *hostSuffix=scheme;
            NSMutableArray *hosts=[[scheme componentsSeparatedByString:@"."] mutableCopy];
            if (hosts.count>0) {
                [hosts removeObjectAtIndex:0];
            }
            hostSuffix=[hosts componentsJoinedByString:@"."];
            if ([referer.host hasSuffix:hostSuffix]) {
                return scheme;
            }
        }else if([scheme isEqual:referer.absoluteString]){///< 已被替换
            return scheme;
        }
    }
    return nil;
}

-(BOOL)mtSchemeManage:(NSURL *)requestUrl{
    NSArray *schemes=@[@"mailto",@"tel",@"alipays",@"alipay",@"weixin",@"wechat",@"mtskindoctor",@"mtskinpatient",@"tmall",@"taobao",@"tbopen"];///@"tmall",@"taobao",@"tbopen"
    if ([schemes containsObject:requestUrl.scheme]) {
        [[UIApplication sharedApplication] openURL:requestUrl];
        return YES;
    }
    return NO;
}

@end
