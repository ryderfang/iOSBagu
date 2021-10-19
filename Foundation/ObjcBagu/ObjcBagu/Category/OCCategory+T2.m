//
//  OCCategory+T2.m
//  ObjcBagu
//
//  Created by Ryder Fang on 2021/10/19.
//  Copyright © 2021 Ryder. All rights reserved.
//

#import "OCCategory+T2.h"

@implementation OCCategory (T2)

+ (void)load {
    NSLog(@"category T2 load.");
}

// 与普通方法一样，会覆盖类的实现，调用最后编译的分类方法
+ (void)initialize {
    NSLog(@"category T2 initialize.");
}

- (void)testSameMethod {
    NSLog(@"category T2 method called.");
}

@end
