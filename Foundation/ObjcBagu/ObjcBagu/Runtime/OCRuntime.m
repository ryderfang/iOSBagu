//
//  OCRuntime.m
//  ObjcBagu
//
//  Created by Ryder Fang on 2021/10/19.
//  Copyright © 2021 Ryder. All rights reserved.
//

#import "OCRuntime.h"
#import <objc/runtime.h>

@interface RTBar : NSObject
@end
@implementation RTBar
@end

@interface RTFoo : RTBar
@end

@implementation RTFoo

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


/*  OC 底层数据结构在 objc.h 中定义
 * objc_object 是所有实例对象的底层结构，内部只有一个 isa 指针，指向类对象 objc_class
 * objc_class 是所有类/元类对象的底层结构，objc_class 继承自 objc_object，所以它也有一个 isa 指针，指向自己的元类
 * 元类指向链: 实例对象 -> 类对象 -> 元类对象 -> 根元类
 * 类的继承链 (super_class): 子类 -> 父类 -> NSObject
 * 元类的继承链 (super_class): 子类元类 -> 父类元类 -> 根元类 -> NSObject -> nil
*/
#import <objc/objc.h>
// --- 下面几个定义在 objc.h 中 --- //
//typedef struct objc_class *Class;
//
//struct objc_object {
//    Class _Nonnull isa  OBJC_ISA_AVAILABILITY;
//};
//
//typedef struct objc_object *id;
#import <objc/runtime.h>
// --- 定义在 runtime.h 中 --- //
//struct objc_class {
//    Class _Nonnull isa  OBJC_ISA_AVAILABILITY;
//
//#if !__OBJC2__
//    Class _Nullable super_class                              OBJC2_UNAVAILABLE;
//    const char * _Nonnull name                               OBJC2_UNAVAILABLE;
//    long version                                             OBJC2_UNAVAILABLE;
//    long info                                                OBJC2_UNAVAILABLE;
//    long instance_size                                       OBJC2_UNAVAILABLE;
//    struct objc_ivar_list * _Nullable ivars                  OBJC2_UNAVAILABLE;
//    struct objc_method_list * _Nullable * _Nullable methodLists                    OBJC2_UNAVAILABLE;
//    struct objc_cache * _Nonnull cache                       OBJC2_UNAVAILABLE;
//    struct objc_protocol_list * _Nullable protocols          OBJC2_UNAVAILABLE;
//#endif
//
//} OBJC2_UNAVAILABLE;

@interface OCRuntime ()

@end

@implementation OCRuntime

+ (void)run {
    OCRuntime *rt = [OCRuntime new];
    [rt testMethod];
    [rt testMethodSignature];
    [rt testInvocation];
    [rt testISA];
}

- (void)testMethod {
    Method method = class_getInstanceMethod(NSClassFromString(@"RTFoo"), @selector(testTypeEncodings:arg2:));
    const char *types = method_getTypeEncoding(method);
    NSString *str = [NSString stringWithCString:types encoding:NSUTF8StringEncoding];
    // @28@0:8i16@20
    // 去掉数字是 @@:i@
    // 分别表示 @[返回对象]@[self]:[_cmd]i[参数是int]@[参数是对象]
    NSLog(@"%@", str);
}

- (void)testMethodSignature {
    RTFoo *foo = [RTFoo new];
    NSMethodSignature *sign1 = [foo methodSignatureForSelector:@selector(testTypeEncodings:arg2:)];
    NSMethodSignature *sign2 = [RTFoo instanceMethodSignatureForSelector:@selector(testTypeEncodings:arg2:)];
    NSMethodSignature *sign3 = [NSMethodSignature signatureWithObjCTypes:"@@:i@"];
    // sign1 == sign2
    NSLog(@"%@ %@ %@", sign1, sign2, sign3);
}

- (void)testInvocation {
    NSMethodSignature *sign = [NSMethodSignature signatureWithObjCTypes:"@@:i@"];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sign];
    RTFoo *foo = [RTFoo new];
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

// https://juejin.cn/post/6844904134286524429
- (void)testISA {
    
}

@end
