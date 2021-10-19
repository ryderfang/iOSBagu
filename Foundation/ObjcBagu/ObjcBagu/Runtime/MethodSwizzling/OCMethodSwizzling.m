//
//  OCMethodSwizzling.m
//  ObjcBagu
//
//  Created by Ryder Fang on 2021/10/19.
//  Copyright © 2021 Ryder. All rights reserved.
//

#import "OCMethodSwizzling.h"
#import <objc/runtime.h>

@interface MSFoo : NSObject
@end

@implementation MSFoo

// Type Encodings: https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
- (NSString *)testTypeEncodings:(int)arg1 arg2:(NSString *)arg2 {
    NSLog(@"%d %@", arg1, arg2);
    return [NSString stringWithFormat:@"%d + %@", arg1, arg2];
}

@end

/*
 * SEL: 函数名编号
 * IMP: 函数指针
 * Method: objc_method 对象
 */

// 本质上就是一个 hash 值，整数
typedef uintptr_t SEL;
typedef struct objc_selector *SEL;

// 函数指针，前两个参数固定是 target 和 SEL
typedef void (*IMP)(void /* id, SEL, ... */ );

struct objc_method {
    SEL _Nonnull method_name ;
    char * _Nullable method_types;
    IMP _Nonnull method_imp;
};

typedef struct objc_method *Method;

@interface OCMethodSwizzling ()

@end

@implementation OCMethodSwizzling

+ (void)run {
    OCMethodSwizzling *ms = [OCMethodSwizzling new];
    [ms testMethod];
    [ms testMethodSignature];
    [ms testInvocation];
}

- (void)testMethod {
    Method method = class_getInstanceMethod(NSClassFromString(@"MSFoo"), @selector(testTypeEncodings:arg2:));
    const char *types = method_getTypeEncoding(method);
    NSString *str = [NSString stringWithCString:types encoding:NSUTF8StringEncoding];
    // @28@0:8i16@20
    // 去掉数字是 @@:i@
    // 分别表示 @[返回对象]@[self]:[_cmd]i[参数是int]@[参数是对象]
    NSLog(@"%@", str);
}

- (void)testMethodSignature {
    MSFoo *foo = [MSFoo new];
    NSMethodSignature *sign1 = [foo methodSignatureForSelector:@selector(testTypeEncodings:arg2:)];
    NSMethodSignature *sign2 = [MSFoo instanceMethodSignatureForSelector:@selector(testTypeEncodings:arg2:)];
    NSMethodSignature *sign3 = [NSMethodSignature signatureWithObjCTypes:"@@:i@"];
    // sign1 == sign2
    NSLog(@"%@ %@ %@", sign1, sign2, sign3);
}

- (void)testInvocation {
    NSMethodSignature *sign = [NSMethodSignature signatureWithObjCTypes:"@@:i@"];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sign];
    MSFoo *foo = [MSFoo new];
    invocation.target = foo;
    invocation.selector = @selector(testTypeEncodings:arg2:);
    int arg1 = 10;
    NSString *arg2 = @"world";
    [invocation setArgument:&arg1 atIndex:2];
    [invocation setArgument:&arg2 atIndex:3];
    [invocation invoke];
    // https://stackoverflow.com/questions/22018272/nsinvocation-returns-value-but-makes-app-crash-with-exc-bad-access
    // Hint: 由于 getReturnValue 方法只是将返回值 copy 到给定内存，并不会 retain
    // 所以 ARC 中 autoreleasepool 向这个对象发送 release 方法会导致 crash!
    {
        // sol1 (recommend)
        void *returnVal = nil;
        [invocation getReturnValue:&returnVal];
        NSLog(@"sol1: %@", (__bridge NSString *)returnVal);
    }
    {
        // sol2
        NSString *__unsafe_unretained returnVal = nil;
        [invocation getReturnValue:&returnVal];
        NSLog(@"sol2: %@", returnVal);
    }
}

@end
