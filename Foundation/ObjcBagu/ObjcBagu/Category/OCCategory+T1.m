//
//  OCCategory+T1.m
//  ObjcBagu
//
//  Created by Ryder Fang on 2021/10/19.
//  Copyright © 2021 Ryder. All rights reserved.
//

#import "OCCategory+T1.h"

@implementation OCCategory (T1)

+ (void)load {
    NSLog(@"OCCategory+T1 load.");
}

+ (void)initialize {
    NSLog(@"OCCategory+T1 initialize.");
}

- (void)testSameMethod {
    NSLog(@"OCCategory+T1 method called.");
}

@end
