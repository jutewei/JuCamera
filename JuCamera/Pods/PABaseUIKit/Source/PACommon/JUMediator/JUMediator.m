//
//  JUMediator.m
//  JuTestTest
//
//  Created by Juvid on 2018/10/12.
//  Copyright © 2018年 Juvid. All rights reserved.
//

#import "JUMediator.h"

NSString * const kJUMediatorTargetModuleKey = @"kJUMediatorTargetModuleKey";

@interface JUMediator ()

@property (nonatomic, strong) NSMutableDictionary *targets;

@end

@implementation JUMediator

#pragma mark - public methods
+ (instancetype)sharedInstance
{
    static JUMediator *mediator;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mediator = [[self alloc] init];
    });
    return mediator;
}

// 远程调用
-(id)performActionWithUrl:(NSURL *)url  completion:(void(^)(NSDictionary *parameter))completion{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *urlString = [url query];
    for (NSString *param in [urlString componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2) continue;
        [params setObject:[elts lastObject] forKey:[elts firstObject]];
    }
    // 防止远程调用本地私有模块。
    NSString *actionName = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    if ([actionName hasPrefix:@"native"]) {
        return @(NO);
    }
    id result = [self performActtionWithTarget:url.host action:actionName parameter:params cacheTarget:NO];
    if (completion) {
        if (result) {
            completion(@{@"result":result});
        } else {
            completion(nil);
        }
    }
    return result;
}

//本地端口调用
-(id)performActtionWithTarget:(NSString *)targetName action:(NSString *)actionName parameter:(NSDictionary *)parameter cacheTarget:(BOOL)cacheTarget{
    NSString *swiftModuleName = parameter[kJUMediatorTargetModuleKey];
    NSString *targetClassString = nil;
    if (swiftModuleName.length > 0) {
        targetClassString = [NSString stringWithFormat:@"%@.%@%@", swiftModuleName,self.juTargetName, targetName];
    } else {
        targetClassString = [NSString stringWithFormat:@"%@%@",self.juTargetName, targetName];
    }
    NSObject *target = self.targets[targetClassString];
    if (target == nil) {
        Class targetClass=NSClassFromString(targetClassString);
        target=[[targetClass alloc]init];
    }

    NSString *actionString = [NSString stringWithFormat:@"%@%@:", self.juActionName,actionName];
    SEL action = NSSelectorFromString(actionString);

    if (target == nil) {
        return nil;
    }

    if (cacheTarget) {
        self.targets[targetClassString] = target;
    }

    if ([target respondsToSelector:action]) {
        return [self safePerformAction:action target:target params:parameter];
    }else{
        // 这里也是处理无响应请求的地方，在notFound都没有的时候，这个demo是直接return了。实际开发过程中，可以用前面提到的固定的target顶上的。
        SEL action = NSSelectorFromString(@"notFound:");
        if ([target respondsToSelector:action]) {
            return [self safePerformAction:action target:target params:parameter];
        } else {
            // 这里也是处理无响应请求的地方，在notFound都没有的时候，这个demo是直接return了。实际开发过程中，可以用前面提到的固定的target顶上的。
            [self.targets removeObjectForKey:targetClassString];
            return nil;
        }
    }
    return nil;
}



- (id)safePerformAction:(SEL)action target:(NSObject *)target params:(NSDictionary *)params
{
    NSMethodSignature* methodSig = [target methodSignatureForSelector:action];
    if(methodSig == nil) {
        return nil;
    }
    const char* retType = [methodSig methodReturnType];

    if (strcmp(retType, @encode(void)) == 0) {
        [self safeInvocation:action target:target params:params methodSig:methodSig];
        return nil;
    }

    if (strcmp(retType, @encode(NSInteger)) == 0) {
        NSInvocation *invocation = [self safeInvocation:action target:target params:params methodSig:methodSig];
        NSInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }

    if (strcmp(retType, @encode(BOOL)) == 0) {
        NSInvocation *invocation = [self safeInvocation:action target:target params:params methodSig:methodSig];
        BOOL result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }

    if (strcmp(retType, @encode(CGFloat)) == 0) {
        NSInvocation *invocation =[self safeInvocation:action target:target params:params methodSig:methodSig];
        CGFloat result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }

    if (strcmp(retType, @encode(NSUInteger)) == 0) {
        NSInvocation *invocation = [self safeInvocation:action target:target params:params methodSig:methodSig];
        NSUInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [target performSelector:action withObject:params];
#pragma clang diagnostic pop
}

-(NSInvocation *)safeInvocation:(SEL)action target:(NSObject *)target params:(NSDictionary *)params methodSig:(NSMethodSignature *)methodSig{
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
    [invocation setArgument:&params atIndex:2];
    [invocation setSelector:action];
    [invocation setTarget:target];
    [invocation invoke];
    return invocation;
}

//清理缓存target
-(void)cleanCachedTargetWithName:(NSString *)targetName{
    NSString *targetClassString = [NSString stringWithFormat:@"%@%@",self.juTargetName, targetName];
    [self.targets removeObjectForKey:targetClassString];
}
#pragma mark - getters and setters
- (NSMutableDictionary *)cachedTarget
{
    if (_targets == nil) {
        _targets = [[NSMutableDictionary alloc] init];
    }
    return _targets;
}
-(NSString *)juTargetName{
    return @"JuTarget_";
}
-(NSString *)juActionName{
    return @"JuAction_";
}
@end
