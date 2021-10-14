//
//  OCWeakObj.m
//  ObjcBagu
//
//  Created by Ryder Fang on 2021/10/14.
//  Copyright © 2021 Ryder. All rights reserved.
//

#import "OCWeakObj.h"

@implementation NSTimer (OCWeakObj)

+ (NSTimer *)RRKit_weakTimerWithTimeInterval:(NSTimeInterval)ti
                                      target:(id)aTarget
                                    selector:(SEL)aSelector
                                    userInfo:(nullable id)userInfo
                                     repeats:(BOOL)yesOrNo {
    OCWeakObj *weakObj = [OCWeakObj new];
    weakObj.target = aTarget;
    weakObj.selector = aSelector;
    weakObj.timer = [NSTimer scheduledTimerWithTimeInterval:ti target:weakObj selector:@selector(fire:) userInfo:userInfo repeats:yesOrNo];
    return weakObj.timer;
}

@end

@implementation OCWeakObj

- (void)fire:(NSTimer *)timer {
    if (self.target && [self.target respondsToSelector:self.selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.target performSelector:self.selector withObject:timer.userInfo];
#pragma clang diagnostic pop
    } else {
        [self.timer invalidate];
    }
}

@end
