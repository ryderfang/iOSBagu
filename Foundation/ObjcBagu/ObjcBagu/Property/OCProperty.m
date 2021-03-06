//
//  OCProperty.m
//  ObjcBagu
//
//  Created by Ryder Fang on 2021/10/13.
//  Copyright © 2021 Ryder. All rights reserved.
//

#import "OCProperty.h"

@interface PFoo : NSObject
@property (nonatomic, strong) id delegate;
@end
@implementation PFoo

//- (void)setDelegate:(id)delegate {
//    NSLog(@"Super PFoo delegate");
//    _delegate = delegate;
//}

@end

@interface PBar : PFoo
// Auto property synthesis will not synthesize property 'delegate'; it will be implemented by its superclass, use @dynamic to acknowledge intention
@property (nonatomic, strong) id delegate;
@end

@implementation PBar

// 只是为了消除 warning
@dynamic delegate;

- (void)testDelegate {
    self.delegate = [NSObject new];
    NSLog(@"%@", self.delegate);
}

@end


// !! @property 的本质就是 ivar(实例变量) + get/set 方法
// @synthesize 是默认的，就是由系统创建 get/set
/*
 - 线程相关: atomic, nonatomic
 - 权限相关: readonly, readwrite
 - ARC: assign, strong, weak, copy
 - MRC: assign, retain, copy
 */
@interface OCProperty () {
    // @dynamic 时不会创建实例变量，需要手动创建
    BOOL _dyBool;
}

@property (nonatomic, assign) PFoo *assignFoo;
@property (nonatomic, weak) PFoo *weakFoo;
@property (nonatomic, copy) NSString *strCopy;
@property (nonatomic, strong) NSString *strStrong;
@property (nonatomic, assign) BOOL dyBool;
@property (nonatomic, strong) NSArray *synArray;

@end

@implementation OCProperty

+ (void)run {
    OCProperty *p = [OCProperty new];
    // readonly 会生成 ivar + getter，没有 setter 方法
    p->_rbIns = YES;
    [p testAssign];
    [p testWeak];
    [p testCopy];
    [p testDynamic];
}

- (void)testAssign {
    // warn: Assigning retained object to unsafe property; object will be released after assignment
    self.assignFoo = [PFoo new];
    // 访问已释放的内存区域，会导致运行时出错
    // err: EXC_BAD_ACCESS (code=1, address=0x18)
//    NSLog(@"%@", self.assignFoo);
}

- (void)testWeak {
    // warn: Assigning retained object to weak variable; object will be released after assignment
    id __weak weakFoo = [PFoo new];
    // ARC 会自动添加 release，导致创建之后就被释放，weak 对象自动置空
    NSLog(@"weakFoo dealloc. %@", weakFoo);
    // weak 释放原理
    // 1. 全局维护了一张 hash map，key 是引用对象的地址，value 是 weak 指针的数组
    // 2. 引用的对象释放后，将 value 数组中的指针清空
    // 3. 涉及的数据结构有 SideTable / weak_table_t / weak_entry_t
}

/*
 * 当源是 mutable 时，使用 copy 更安全；
 * 当源是 immutable 时，两者一样，copy 也不会创建新对象。
 * 所以，NSString 作为属性，使用 [copy] 万无一失。
 */
- (void)testCopy {
    // I. NSMutableString -> NSString
    NSMutableString *sourceStr = [[NSMutableString alloc] initWithFormat:@"You're in %@", [NSLocale currentLocale].countryCode];
    // NSString 作为属性时，使用 copy，在这一步时会自动调用 [sourceStr copy] 方法，深拷贝一次，避免源改变后，属性随之改变
    self.strCopy = sourceStr;
    self.strStrong = sourceStr;
    // source: 0x108e17fa0, copy: 0x108e18030, strong: 0x108e17fa0
    NSLog(@"source: %p, copy: %p, strong: %p", sourceStr, self.strCopy, self.strStrong);
    // 修改源
    NSUInteger index = sourceStr.length - 2;
    [sourceStr replaceCharactersInRange:NSMakeRange(index, 2) withString:@"US"];
    // 同样的，修改属性，也会影响源
//    [(NSMutableString *)self.strStrong replaceCharactersInRange:NSMakeRange(index, 2) withString:@"US"];
    // source: You're in US, copy: You're in CN, strong: You're in US
    // 可以看出来，strong 修饰的属性被修改了
    NSLog(@"source: %@, copy: %@, strong: %@", sourceStr, self.strCopy, self.strStrong);
    
    NSLog(@"===========================");
    
#pragma mark 这种情况 copy 和 strong 是一样的
    // II. NSString -> NSString
    NSString *srcStr = [[NSString alloc] initWithFormat:@"You're in %@", [NSLocale currentLocale].countryCode];
    self.strCopy = srcStr;
    self.strStrong = srcStr;
    // source: 0x10f216b50, copy: 0x10f216b50, strong: 0x10f216b50 地址一样!
    NSLog(@"source: %p, copy: %p, strong: %p", srcStr, self.strCopy, self.strStrong);
    // 修改源
    srcStr = @"Woooo";
    // source: 0x10000c670, copy: 0x10f216b50, strong: 0x10f216b50
    // 也可以避免被修改，因为 NSString 重新赋值，相当于构建了一个新对象 (source 地址变化)
    NSLog(@"source: %p, copy: %p, strong: %p", srcStr, self.strCopy, self.strStrong);
    // source: Hoooo, copy: Hello, World, strong: Hello, World
    NSLog(@"source: %@, copy: %@, strong: %@", srcStr, self.strCopy, self.strStrong);
}

@dynamic dyBool;

- (void)testDynamic {
    // 如果不自己实现 set 方法，会抛 NSInvalidArgumentException 异常
    self.dyBool = YES;
    // 如果不自己实现 get 方法，会抛 NSInvalidArgumentException 异常
//    NSLog(@"get:: %d", self.dyBool);
    
    PBar *bar = [PBar new];
    [bar testDelegate];
}

- (void)setDyBool:(BOOL)dyBool {
    _dyBool = dyBool;
}

- (BOOL)dyBool {
    return _dyBool;
}

// 如果不用 @synthesize 会报错，因为同时实现了 getter/setter 后，系统不再生成 ivar
// Use of undeclared identifier '_synArray'
@synthesize synArray = _synArray;

- (NSArray *)synArray {
    return _synArray;
}

- (void)setSynArray:(NSArray *)synArray {
    _synArray = synArray;
}

@end
