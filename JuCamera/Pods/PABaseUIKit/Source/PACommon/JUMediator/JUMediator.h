//
//  JUMediator.h
//  JuTestTest
//
//  Created by Juvid on 2018/10/12.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString * const kJUMediatorTargetModuleKey;

@interface JUMediator : NSObject

+ (instancetype)sharedInstance;
/*
 scheme://[target]/[action]?[params]
 url sample:
 aaa://targetA/actionB?id=1234
 */
// 远程调用
-(id)performActionWithUrl:(NSURL *)url  completion:(void(^)(NSDictionary *parameter))completion;
//本地端口调用
-(id)performActtionWithTarget:(NSString *)targetName action:(NSString *)actionName parameter:(NSDictionary *)parameter cacheTarget:(BOOL)cacheTarget;
//清理缓存target
-(void)cleanCachedTargetWithName:(NSString *)targetName;

@end
