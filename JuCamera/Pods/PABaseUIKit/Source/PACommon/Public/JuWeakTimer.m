//
//  JuWeakTimer.m
//  PABase
//
//  Created by Juvid on 2019/1/15.
//  Copyright © 2019 Juvid. All rights reserved.
//

#import "JuWeakTimer.h"

@interface JuWeakTimer ()
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, weak) NSTimer* timer;
@end


@implementation JuWeakTimer

- (void) timered:(NSTimer *)timer {
    if(self.target) {
        SuppressPerformSelectorLeakWarning([self.target performSelector:self.selector withObject:timer.userInfo]);
    } else {
        [self.timer invalidate];
    }
}

+ (NSTimer *) scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      target:(id)aTarget
                                    selector:(SEL)aSelector
                                    userInfo:(id)userInfo
                                     repeats:(BOOL)repeats {
    JuWeakTimer* timerTarget = [[JuWeakTimer alloc] init];
    timerTarget.target = aTarget;
    timerTarget.selector = aSelector;
    timerTarget.timer = [NSTimer scheduledTimerWithTimeInterval:interval
                                                         target:timerTarget
                                                       selector:@selector(timered:)
                                                       userInfo:userInfo
                                                        repeats:repeats];
    return timerTarget.timer;
}

+ (NSTimer*)scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats blockTimer:(void (^)(NSTimer *))block{
    NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(timered:) userInfo:[block copy] repeats:repeats];
    return timer;
}

+ (void)timered:(NSTimer*)timer {
    void (^block)(NSTimer *timer)  = timer.userInfo;
    block(timer);
}

dispatch_source_t juCreateDispatchTimer(uint64_t interval,dispatch_queue_t queue, dispatch_block_t block)
{
   dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,
                                                     0, 0, queue);
   if (timer){
      dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), interval*NSEC_PER_SEC, 0);
      dispatch_source_set_event_handler(timer, block);
      dispatch_resume(timer);
   }
   return timer;
}
@end

@implementation NSTimer (Addition)

-(void)pauseTimer
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate distantFuture]];
}


-(void)resumeTimer
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate date]];
}

- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}

@end
/**
 问题描述

 项目中使用到了从字符串创建选择器，编译时发现警告："performSelector may cause a leak because its selector is unknown"（因为performSelector的选择器未知可能会引起泄漏），为什么在ARC模式下会出现这个警告？

 经过搜索后，在Stackoverflow上发现了一个令人满意的答案。见http://stackoverflow.com/questions/7017281/performselector-may-cause-a-leak-because-its-selector-is-unknown 。

 原因

 在ARC模式下，运行时需要知道如何处理你正在调用的方法的返回值。这个返回值可以是任意值，如 void , int , char , NSString , id 等等。ARC通过头文件的函数定义来得到这些信息。所以平时我们用到的静态选择器就不会出现这个警告。因为在编译期间，这些信息都已经确定。

 如：

 ...
 [someController performSelector:@selector(someMethod)];
 ...
 - (void)someMethod
 {
   //bla bla...
 }
 而使用 [someController performSelector: NSSelectorFromString(@"someMethod")]; 时ARC并不知道该方法的返回值是什么，以及该如何处理？该忽略？还是标记为 ns_returns_retained 还是ns_returns_autoreleased ?

 解决办法

 1.使用函数指针方式

 SEL selector = NSSelectorFromString(@"someMethod");
 IMP imp = [_controller methodForSelector:selector];
 void (*func)(id, SEL) = (void *)imp;
 func(_controller, selector);
 当有额外参数时，如

 SEL selector = NSSelectorFromString(@"processRegion:ofView:");
 IMP imp = [_controller methodForSelector:selector];
 CGRect (*func)(id, SEL, CGRect, UIView *) = (void *)imp;
 CGRect result = func(_controller, selector, someRect, someView);
 2.使用宏忽略警告

 #define SuppressPerformSelectorLeakWarning(Stuff) \
     do { \
         _Pragma("clang diagnostic push") \
         _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
         Stuff; \
         _Pragma("clang diagnostic pop") \
     } while (0)
 在产生警告也就是 performSelector 的地方用使用该宏，如

 SuppressPerformSelectorLeakWarning(
     [_target performSelector:_action withObject:self]
 );
 如果需要 performSelector 返回值的话，

 id result;
 SuppressPerformSelectorLeakWarning(
     result = [_target performSelector:_action withObject:self]
 );
 3.使用afterDelay

 [self performSelector:aSelector withObject:nil afterDelay:0.0];
 如果在接受范围内，允许在下一个runloop执行，可以这么做。xCode5没问题，但据反映，xcode6的话这个不能消除警告。

 */
