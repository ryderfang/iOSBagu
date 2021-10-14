//
//  OCProperty.m
//  ObjcBagu
//
//  Created by Ryder Fang on 2021/10/13.
//  Copyright © 2021 Ryder. All rights reserved.
//

#import "OCProperty.h"

@interface Foo : NSObject
@end
@implementation Foo
@end

/*
 - 线程相关: atomic, nonatomic
 - 权限相关: readonly, readwrite
 - ARC: assign, strong, weak, copy
 - MRC: assign, retain, copy
 */
@interface OCProperty ()

@property (nonatomic, assign) Foo *assignFoo;
@property (nonatomic, weak) Foo *weakFoo;

@end

@implementation OCProperty

+ (void)run {
    OCProperty *p = [OCProperty new];
    [p testAssign];
    [p testWeak];
}

- (void)testAssign {
    // warn: Assigning retained object to unsafe property; object will be released after assignment
    self.assignFoo = [Foo new];
    // 访问已释放的内存区域，会导致运行时出错
    // err: EXC_BAD_ACCESS (code=1, address=0x18)
//    NSLog(@"%@", self.assignFoo);
}

- (void)testWeak {
    // warn: Assigning retained object to weak variable; object will be released after assignment
    id __weak weakFoo = [Foo new];
    // ARC 会自动添加 release，导致创建之后就被释放，weak 对象自动置空
    NSLog(@"%@", weakFoo);
    // weak 释放原理
    // 1. 全局维护了一张 hash map，key 是引用对象的地址，value 是 weak 指针的数组
    // 2. 引用的对象释放后，将 value 数组中的指针清空
    // 3. 涉及的数据结构有 SideTable / weak_table_t / weak_entry_t
}


@end
