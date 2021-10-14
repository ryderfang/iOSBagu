//
//  OCMsgForwarding.m
//  ObjcBagu
//
//  Created by Ryder Fang on 2021/10/14.
//  Copyright © 2021 Ryder. All rights reserved.
//

#import "OCMsgForwarding.h"

@interface MFoo : NSObject
@end

@implementation MFoo

- (void)testMethod {
    NSLog(@"Hello world");
}

@end

@interface OCMsgForwarding ()

@end

@implementation OCMsgForwarding

+ (void)run {
    OCMsgForwarding *mf = [OCMsgForwarding new];
    // 什么也不做，直接调用未实现的方法，会报 "unrecognized selector sent to instance xx" 异常并 crash
    [mf performSelector:@selector(testMethod)];
    // 当一个对象方法列表中找不到该方法时，会进入消息转发流程
    // 消息转发分成三步:
    // 1. 方法解析处理 +resolveInstanceMethod / +resolveClassMethod
    // 2. 快速转发 -forwardingTargetForSelector
    // 3. 常规转发 -methodSignatureForSelector / -forwardInvocation
}

#pragma mark Solution1: 用 runtime 动态添加一个方法
// 实例方法添加到类中
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if ([NSStringFromSelector(sel) isEqualToString:@"testMethod"]) {
        // TODO:
        return YES;
    } else {
        return [super resolveInstanceMethod:sel];
    }
}

// 类方法添加到元类中
+ (BOOL)resolveClassMethod:(SEL)sel {
    if ([NSStringFromSelector(sel) isEqualToString:@"testMethod"]) {
        // TODO:
        return YES;
    } else {
        return [super resolveInstanceMethod:sel];
    }
}

#pragma mark Solution2: 快速转发，交给别的类处理
// resolveInstanceMethod 不管返回什么，都不影响 forwardingTargetForSelector 的调用
//- (id)forwardingTargetForSelector:(SEL)aSelector {
//    if ([NSStringFromSelector(aSelector) isEqualToString:@"testMethod"]) {
//        // 这里返回另一个类，就会直接调用该类的方法
//        return [MFoo new];
//    } else {
//        return [super forwardingTargetForSelector:aSelector];
//    }
//}

#pragma mark Solution3: 创建签名，转发调用
// 只有这一步还不够，有返回 sig 时，会调用 forwardInvocation
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if ([NSStringFromSelector(aSelector) isEqualToString:@"testMethod"]) {
        NSMethodSignature *sign = [NSMethodSignature signatureWithObjCTypes:"v@:"];
        return sign;
    } else {
        return [super methodSignatureForSelector:aSelector];
    }
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    SEL sel = anInvocation.selector;
    MFoo *foo = [MFoo new];
    if ([foo respondsToSelector:sel]) {
        return [anInvocation invokeWithTarget:foo];
    } else {
        // 最终抛异常
        [self doesNotRecognizeSelector:sel];
    }
}

@end
