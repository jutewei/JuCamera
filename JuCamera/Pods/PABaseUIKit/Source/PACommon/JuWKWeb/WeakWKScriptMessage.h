//
//  WeakScriptMessageDelegate.h
//  JuTestTest
//
//  Created by Juvid on 2018/10/12.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import <WebKit/WKPreferences.h>

@interface WeakWKScriptMessage : NSObject<WKScriptMessageHandler>

@property (nonatomic, weak) id<WKScriptMessageHandler> scriptDelegate;

//- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;
+ (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;

@end
