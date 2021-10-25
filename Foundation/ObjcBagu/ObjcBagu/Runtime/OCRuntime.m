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

@property (nonatomic, strong) NSString *name;

@end
@implementation RTBar

- (void)print {
    NSLog(@"foo's name is: %@", self.name);
}

+ (void)print {
    NSLog(@"[ClassMethod] RTFoo's name...");
}

@end

@interface RTFoo : RTBar

@end

@implementation RTFoo

// Type Encodings: https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
- (NSString *)testTypeEncodings:(int)arg1 arg2:(NSString *)arg2 {
    NSLog(@"%d %@", arg1, arg2);
    return [NSString stringWithFormat:@"%d + %@", arg1, arg2];
}

- (instancetype)init {
    if (self = [super init]) {
        NSLog(@"[self class] is %@", [self class]);
        // [super class] 等于 [RTBar class]，父类如果没有实现，最终调用的是 [NSObject class]
        /*
         // NSObject 的实现，注意这里传入的参数是 self !!
         - (Class)class {
             return object_getClass(self);
         }
         
         Class object_getClass(id obj)
         {
             if (obj) return obj->getIsa();
             else return Nil;
         }
       */
        // 也就是说 [super class] 最终返回的是当前实例的类 (isa 指针)
        NSLog(@"[super class] is %@", [super class]);
        
        /* 所以这里最终都返回的当前类对象中的 superclass 变量
         // NSObject superclass 实现
         - (Class)superclass {
             return [self class]->superclass;
         }
         */
        NSLog(@"[self superclass] is %@", [self superclass]);
        NSLog(@"[super superclass] is %@", [super superclass]);
        
        self.name = @"Fooook";
    }
    return self;
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
 * 元类指向链: 实例对象 -> 类对象 -> 元类对象 -> 根元类 -> 根元类 (根元类的 isa 指向自己)
 * 类的继承链 (super_class): 子类 -> 父类 -> NSObject
 * 元类的继承链 (super_class): 子类元类 -> 父类元类 -> 根元类 -> NSObject -> nil (根元类的父类是 NSObject)
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
    [rt testNSObject];
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

- (void)testNSObject {
    __unused RTFoo *foo = [[RTFoo alloc] init];
    /*
     - (BOOL)isKindOfClass:(Class)cls {
         for (Class tcls = [self class]; tcls; tcls = tcls->superclass) {
             if (tcls == cls) return YES;
         }
         return NO;
     }
     + (BOOL)isKindOfClass:(Class)cls {
         for (Class tcls = self->ISA(); tcls; tcls = tcls->superclass) {
             if (tcls == cls) return YES;
         }
         return NO;
     }
     - (BOOL)isMemberOfClass:(Class)cls {
         return [self class] == cls;
     }
     + (BOOL)isMemberOfClass:(Class)cls {
         return self->ISA() == cls;
     }
     + (BOOL)isSubclassOfClass:(Class)cls {
         for (Class tcls = self; tcls; tcls = tcls->superclass) {
             if (tcls == cls) return YES;
         }
         return NO;
     }
     
     + (Class)class {
        return self;
     }
     - (Class)class {
        return object_getClass(self);
     }
     */
    // isKindOfClass 判断是否是该类的实例或者其子类的实例
    // isMemberOfClass 判断是否是该类的实例
    // !!! 实例的 class 返回自己，类的 class 返回其元类
    // https://www.jianshu.com/p/ae5c32708bc6
    // https://github.com/SummitXY/iOS-Blog/issues/22#issue-455257478
    // https://www.codenong.com/jsd88e4321c21a/
    // https://juejin.cn/post/6873793240655462413
    // https://zhuanlan.zhihu.com/p/387802000
    // 这里能相等是因为 根元类的 superclass 是 NSObject
    NSLog(@"[isKindOfClass: %d", [[NSObject class] isKindOfClass:[NSObject class]]);        // 1
    // NSObject->ISA() != NSObject
    NSLog(@"[isMemberOfClass: %d", [[NSObject class] isMemberOfClass:[NSObject class]]);   // 0
    NSLog(@"[isKindOfClass: %d", [[RTFoo class] isKindOfClass:[RTFoo class]]);              // 0
    NSLog(@"[isKindOfClass: %d", [foo isKindOfClass:[RTFoo class]]);                         // 1
    NSLog(@"[isMemberOfClass: %d", [[RTFoo class] isMemberOfClass:[RTFoo class]]);         // 0
    NSLog(@"[isMemberOfClass: %d", [foo isMemberOfClass:[RTFoo class]]);                    // 1
    
    id cls = [RTBar class];
    void *obj = &cls;
    [(__bridge id)obj print];
}

@end
