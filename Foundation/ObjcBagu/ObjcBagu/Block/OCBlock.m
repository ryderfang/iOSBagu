//
//  OCBlock.m
//  ObjcBagu
//
//  Created by Ryder Fang on 2022/4/26.
//  Copyright © 2022 Ryder. All rights reserved.
//

#import "OCBlock.h"

typedef double (^Multiplier)(double, double);

@interface OCBlock ()

@property (nonatomic, copy) Multiplier multiply;
@property (nonatomic, copy) void (^voidBlock)(void);

@end

@implementation OCBlock

+ (void)run {
    OCBlock *temp = [OCBlock new];
    //[temp testBlock];
    [temp testBlockAssign];
}

- (void)testSyntax {
    // 局部变量
    __unused double (^multiply1)(double, double) = ^double(double a, double b) {
        return a * b;
    };
    __unused double (^multiply2)(double, double) = ^(double a, double b) {
        return a * b;
    };
    __unused void (^voidBlock)(void) = ^{
        
    };
    
    // 参数调用
    [self someMethodCallBlock:^(double a, double b) {
        return a * b;
    }];
}

- (void)someMethodCallBlock:(double (^_Nonnull)(double, double))multiply {
    
}

- (void)testBlock {
    __block NSObject *obj = nil;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (YES) {
            // Thread 2: EXC_BREAKPOINT (code=1, subcode=0x1a1384438)
            // 这里会有概率访问野指针
            NSLog(@"%@", [obj description]);
        }
    });
    
    while (YES) {
        obj = [NSObject new];
        NSLog(@"new obj");
    }
}

- (void)testBlockAssign {
    __block NSInteger i = 1;
    __block NSString *str = @"hello";
    __block NSMutableString *mStr = nil;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // mStr 有概率读到主线程的赋值
        NSLog(@"[block inside]%ld %@ %@", (long)i, str, mStr);
        i = 3;
        str = @"world";
    });
    mStr = [NSMutableString stringWithFormat:@"%ld+%@", i, str];
    NSLog(@"[block outside]%ld %@ %@", (long)i, str, mStr);
}

@end
