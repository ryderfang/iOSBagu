//
//  OCMethodSwizzling.m
//  ObjcBagu
//
//  Created by Ryder Fang on 2021/10/19.
//  Copyright © 2021 Ryder. All rights reserved.
//

#import "OCMethodSwizzling.h"
#import "NSObject+Swizzling.h"

@interface MSFoo : NSObject
@end
@implementation MSFoo

- (void)foo_instanceMethod {
    NSLog(@"foo_instanceMethod in cls: %@", [self class]);
}

+ (void)foo_classMethod {
    NSLog(@"foo_classMethod in cls: %@", [self class]);
}

@end

@interface MSBar : MSFoo
@end
@implementation MSBar

- (void)bar_instanceMethod {
    NSLog(@"bar_instanceMethod in cls: %@", [self class]);
}

@end

@implementation OCMethodSwizzlingSuper

- (void)sp_instanceMethod {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

@end

@interface OCMethodSwizzling ()

@end

@implementation OCMethodSwizzling

+ (void)run {
    OCMethodSwizzling *ms = [self new];
//    OCMethodSwizzlingSuper *sp = [OCMethodSwizzlingSuper new];
    //MARK: TEST1
//    [self swizzleMethod:@selector(sp_instanceMethod) with:@selector(swiz_instanceMethod)];
//    [ms swiz_instanceMethod];
//    // 子类的方法是被新增的，已经被替换成 swiz_
//    [ms sp_instanceMethod];
//    // 父类的方法不变
//    [sp sp_instanceMethod];
    
    //MARK: TEST2
//    IMP oriIMP = [self oriIMP4SwizzleMethod:@selector(sp_instanceMethod) with:@selector(swiz_instanceMethod)];
//    ((void (*)(id, SEL))oriIMP)(self, @selector(sp_instanceMethod));
//    // 子类的方法是被新增的，已经被替换成 swiz_
//    [ms sp_instanceMethod];
//    // 父类的方法不变
//    [sp sp_instanceMethod];
    
    //MARK: TEST3
   [OCMethodSwizzling swizzleMethod:@selector(swiz_instanceMethod) with:@selector(foo_instanceMethod) altClass:[MSBar class]];
    [OCMethodSwizzling swizzleMethod:@selector(swiz_instanceMethod) with:@selector(bar_instanceMethod) altClass:[MSBar class]];
    MSBar *bar = [MSBar new];
    [bar foo_instanceMethod];
    [bar bar_instanceMethod];
    [ms swiz_instanceMethod];
}

- (void)swiz_instanceMethod {
    NSLog(@"swiz_instanceMethod in cls: %@", [self class]);
}

- (void)swiz_classMethod {
    
}

@end
