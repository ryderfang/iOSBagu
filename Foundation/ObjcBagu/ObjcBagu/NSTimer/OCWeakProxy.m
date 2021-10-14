//
//  OCWeakProxy.m
//  ObjcBagu
//
//  Created by Ryder Fang on 2021/10/14.
//  Copyright © 2021 Ryder. All rights reserved.
//

// 参考 YYKit https://github.com/ibireme/YYKit/blob/master/YYKit/Utility/YYWeakProxy.m
#import "OCWeakProxy.h"

@interface OCWeakProxy ()

@property (nonatomic, weak, readwrite) id target;

@end

@implementation OCWeakProxy

- (instancetype)initWithTarget:(id)target {
    _target = target;
    return self;
}

+ (instancetype)proxyWithTarget:(id)target {
    OCWeakProxy *weakObj = [[OCWeakProxy alloc] initWithTarget:target];
    return weakObj;
}

// 快速消息转发
- (id)forwardingTargetForSelector:(SEL)selector {
    return _target;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    SEL sel = invocation.selector;
    if ([self.target respondsToSelector:sel]) {
        [invocation invokeWithTarget:self.target];
    } else {
        if ([self respondsToSelector:sel]) {
            [super forwardInvocation:invocation];
        }
    }
}

// 标准消息转发
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    if ([self.target respondsToSelector:sel]) {
        return [self.target methodSignatureForSelector:sel];
    } else {
        return [super methodSignatureForSelector:sel];
    }
}

@end
