//
//  JuWeakTimer.h
//  PABase
//
//  Created by Juvid on 2019/1/15.
//  Copyright © 2019 Juvid. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "NSTimer+Addition.h"

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
    Stuff; \
    _Pragma("clang diagnostic pop") \
} while (0)

NS_ASSUME_NONNULL_BEGIN

@interface JuWeakTimer : NSObject

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      target:(id)aTarget
                                    selector:(SEL)aSelector
                                    userInfo:(nullable id)userInfo
                                     repeats:(BOOL)repeats;

+ (NSTimer*)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                   repeats:(BOOL)repeats
                                blockTimer:(void (^)(NSTimer *))block;

dispatch_source_t juCreateDispatchTimer(uint64_t interval,dispatch_queue_t queue, dispatch_block_t block);

@end


@interface NSTimer (Addition)

- (void)pauseTimer;
- (void)resumeTimer;
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;
@end

NS_ASSUME_NONNULL_END
