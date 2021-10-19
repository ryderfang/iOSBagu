//
//  OCMsgForwarding.m
//  ObjcBagu
//
//  Created by Ryder Fang on 2021/10/14.
//  Copyright © 2021 Ryder. All rights reserved.
//

#import "OCMsgForwarding.h"
#import <objc/runtime.h>

@interface MFoo : NSObject
@end

@implementation MFoo

- (void)testMethod:(NSString *)v {
    NSLog(@"Hello world: %@", v);
}

@end

static NSString *const kInstanceMethodName = @"unRecognizedInstanceSelector";
static NSString *const kClassMethodName = @"unRecognizedClassSelector";

@interface OCMsgForwarding ()

@end

@implementation OCMsgForwarding

+ (void)run {
    OCMsgForwarding *mf = [OCMsgForwarding new];
    // 什么也不做，直接调用未实现的方法，会报 "unrecognized selector sent to instance xx" 异常并 crash
    [mf performSelector:@selector(unRecognizedInstanceSelector) withObject:@"Ryder"];
    [OCMsgForwarding performSelector:@selector(unRecognizedClassSelector) withObject:@"Ryder"];
    // 当一个对象方法列表中找不到该方法时，会进入消息转发流程
    // 消息转发分成三步:
    // 1. 方法解析处理 +resolveInstanceMethod // +resolveClassMethod
    // 2. 快速转发 -forwardingTargetForSelector // +forwardingTargetForSelector
    // 3. 常规转发 -methodSignatureForSelector / -forwardInvocation // +methodSignatureForSelector / +forwardInvocation
}

#pragma mark Solution1: 用 runtime 动态添加一个方法
void dynamicMethod(id self, SEL _cmd, NSString *v) {
    NSLog(@"Whooo: %@", v);
}

void dynamicMethod2(id self, SEL _cmd, NSString *v) {
    NSLog(@"Ohooo: %@", v);
}


// 实例方法添加到类中
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if ([NSStringFromSelector(sel) isEqualToString:kInstanceMethodName]) {
//        class_addMethod([self class], sel, (IMP)dynamicMethod, "v@:@");
        return YES;
    } else {
        return [super resolveInstanceMethod:sel];
    }
}

// 类方法添加到元类中
+ (BOOL)resolveClassMethod:(SEL)sel {
    if ([NSStringFromSelector(sel) isEqualToString:kClassMethodName]) {
//        class_addMethod(objc_getMetaClass(class_getName([self class])), sel, (IMP)dynamicMethod2, "v@:@");
        return YES;
    } else {
        return [super resolveInstanceMethod:sel];
    }
}

#pragma mark Solution2: 快速转发，交给别的类处理
// resolveInstanceMethod 不管返回什么，都不影响 forwardingTargetForSelector 的调用，除非动态添加过方法
- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([NSStringFromSelector(aSelector) isEqualToString:kInstanceMethodName]) {
        // 这里返回另一个类，就会直接调用该类的方法
        // 如果返回的类，无法处理该方法，也会报错
        return nil;
//        return [MFoo new];
    } else {
        return [super forwardingTargetForSelector:aSelector];
    }
}

#pragma mark Solution3: 创建签名，转发调用
// 只有这一步还不够，有返回 sig 时，会调用 forwardInvocation
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if ([NSStringFromSelector(aSelector) isEqualToString:kInstanceMethodName]) {
        NSMethodSignature *sign = [NSMethodSignature signatureWithObjCTypes:"v@:@"];
        return sign;
    } else {
        return [super methodSignatureForSelector:aSelector];
    }
}

// 注意: 类方法本质上就是元类的实例方法
+ (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if ([NSStringFromSelector(aSelector) isEqualToString:kClassMethodName]) {
        NSMethodSignature *sign = [NSMethodSignature signatureWithObjCTypes:"v@:@"];
        return sign;
    } else {
        return [super methodSignatureForSelector:aSelector];
    }
}

// anInvocation.selector 来自 performSelector
// anInvocation.methodSignature 来自 methodSignatureForSelector 的返回值
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    SEL sel = anInvocation.selector;
    MFoo *foo = [MFoo new];
    if ([NSStringFromSelector(sel) isEqualToString:kInstanceMethodName]) {
        // 这个 selector 与实际使用的不一致，所以修改一下
        anInvocation.selector = @selector(testMethod:);
        // index 0: self
        // index 1: _cmd
        NSString *v = @"Fang";
        [anInvocation setArgument:&v atIndex:2];
        return [anInvocation invokeWithTarget:foo];
    } else {
        // 最终抛异常
        [self doesNotRecognizeSelector:sel];
    }
}

+ (void)forwardInvocation:(NSInvocation *)anInvocation {
    SEL sel = anInvocation.selector;
    MFoo *foo = [MFoo new];
    if ([NSStringFromSelector(sel) isEqualToString:kClassMethodName]) {
        // 这个 selector 与实际使用的不一致，所以修改一下
        anInvocation.selector = @selector(testMethod:);
        // index 0: self
        // index 1: _cmd
        NSString *v = @"Rui";
        [anInvocation setArgument:&v atIndex:2];
        return [anInvocation invokeWithTarget:foo];
    } else {
        // 最终抛异常
        [self doesNotRecognizeSelector:sel];
    }
}

@end
