//
//  NSTimer+RRKit.m
//  ObjcBagu
//
//  Created by Ryder Fang on 2021/10/14.
//  Copyright © 2021 Ryder. All rights reserved.
//

#import "NSTimer+RRKit.h"

@implementation NSTimer (RRKit)

+ (NSTimer *)RRKit_timerWithTimeInterval:(NSTimeInterval)interval
                              repeats:(BOOL)repeats
                                   block:(void (^)(NSTimer *timer))block {
    if (@available(iOS 10.0, *)) {
        // 系统实现
        return [self timerWithTimeInterval:interval repeats:repeats block:block];
    } else {
        return [self timerWithTimeInterval:interval target:self selector:@selector(RR_timerTick:) userInfo:[block copy] repeats:repeats];
    }
}

+ (NSTimer *)RRKit_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                       repeats:(BOOL)repeats
                                            block:(void (^)(NSTimer *timer))block {
    if (@available(iOS 10.0, *)) {
        // 系统实现
        return [self scheduledTimerWithTimeInterval:interval repeats:repeats block:block];
    } else {
        return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(RR_timerTick:) userInfo:[block copy] repeats:repeats];
    }
}

+ (void)RR_timerTick:(NSTimer *)timer {
    void (^block)(NSTimer *) = timer.userInfo;
    if (block) {
        block(timer);
    }
}

@end
