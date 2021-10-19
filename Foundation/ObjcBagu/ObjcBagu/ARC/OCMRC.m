//
//  OCMRC.m
//  ObjcBagu
//
//  Created by Ryder Fang on 2021/10/19.
//  Copyright © 2021 Ryder. All rights reserved.
//

#import "OCMRC.h"

@interface OCMRC ()

@property (nonatomic, retain) NSString *testString;

@end

@implementation OCMRC

+ (void)run {
    OCMRC *mrc = [OCMRC new];
    mrc.testString = @"hello";
    [mrc testPool];
    [mrc release];
}

- (void)dealloc {
    [self.testString release];
    
    // call [super dealloc] after release all
    [super dealloc];
}

- (void)testPool {
    for (int i = 0; i < PAGE_SIZE / 1000; i++) {
        // 手动 创建/清空 释放池
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        NSString *str = [[@"Hello, World" retain] autorelease];
        str = [str uppercaseString];
        str = [NSString stringWithFormat:@"%@ %d", str, i];
        NSLog(@"str");
        [pool drain];
    }
}

@end
