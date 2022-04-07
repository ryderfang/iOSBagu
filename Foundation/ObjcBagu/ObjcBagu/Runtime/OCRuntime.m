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
    NSLog(@"bar's name is: %@", self.name);
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

- (void)print {
    NSLog(@"foo's name is: %@", self.name);
}

- (void)callSuper {
    // will call [self print]? NO!
    [super print];
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

#import <objc/objc.h>
#import <objc/runtime.h>

@interface OCRuntime ()

@end

@implementation OCRuntime

+ (void)run {
    OCRuntime *rt = [OCRuntime new];
//    [rt testMethod];
//    [rt testMethodSignature];
//    [rt testInvocation];
    [rt testISA];
//    [rt testNSObject];
//    [rt testSuper];
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
// https://ryderfang.com/class-object-isa/
- (void)testISA {
    // 继承链 (instance -> class -> superClass -> NSObject -> nil)
    RTFoo *foo = [RTFoo new];
    NSLog(@"instance addr: %p", foo);
    id rootClass = nil;
    
    Class cls = [foo class];
    NSLog(@"[class] %p %p \n[self] %p [objc_getClass] %p\n[object_getClass] %p [NSClassFromString] %p", cls, [RTFoo class],
          [cls self], objc_getClass(object_getClassName(cls)), object_getClass(foo), NSClassFromString(@"RTFoo"));
    
    while (cls) {
        NSLog(@"class: %s addr: %p", object_getClassName(cls), cls);
        if (!class_getSuperclass(cls)) {
            rootClass = cls;
        }
        cls = class_getSuperclass(cls);
    }
    
    // isa 链 (instance -> class -> metaClass -> rootMetaClass <-> rootMetaClass)
    cls = [foo class];
    id rootMetaClass = nil;
    while (cls) {
        NSLog(@"isa: %s addr: %p", object_getClassName(cls), cls);
        Class tmp = object_getClass(cls);
        if (tmp == cls) {
            rootMetaClass = cls;
            break;
        }
        cls = tmp;
    }
    
    // meta 继承链 (metaClass -> superMetaClass -> rootMetaClass -> rootObject -> nil)
    cls = object_getClass([foo class]);
    while (cls) {
        NSLog(@"metaClass: %s addr: %p", object_getClassName(cls), cls);
        cls = class_getSuperclass(cls);
    }
    
    NSLog(@"rootClass: %p, rootMetaClass: %p", rootClass, rootMetaClass);
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

- (void)testSuper {
    RTFoo *foo = [[RTFoo alloc] init];
    [foo callSuper];
}

@end
