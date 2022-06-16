//
//  JuWebViewManage.h
//  PABase
//
//  Created by 朱天伟(平安租赁事业群(汽融商用车)信息科技部科技三团队) on 2021/6/1.
//

#import <Foundation/Foundation.h>
//#import "PABridgeManage.h"
//#import "PAWKWebView.h"
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JuWebViewManage : NSObject

+ (instancetype) sharedInstance;

//@property (nonatomic,strong) NSMutableArray <WKWebView *> *zl_arrWeb;

-(WKWebView *)juGetWebview;

@end

NS_ASSUME_NONNULL_END
