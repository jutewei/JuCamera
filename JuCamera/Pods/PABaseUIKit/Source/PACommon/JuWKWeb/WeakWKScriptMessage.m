//
//  WeakScriptMessageDelegate.m
//  JuTestTest
//
//  Created by Juvid on 2018/10/12.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "WeakWKScriptMessage.h"

@implementation WeakWKScriptMessage

+ (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate{
    return [[WeakWKScriptMessage alloc]initWithDelegate:scriptDelegate];
}

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate
{
    self = [super init];
    if (self) {
        _scriptDelegate = scriptDelegate;
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
}

@end
