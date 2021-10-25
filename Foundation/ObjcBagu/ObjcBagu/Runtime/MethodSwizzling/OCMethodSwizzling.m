//
//  OCMethodSwizzling.m
//  ObjcBagu
//
//  Created by Ryder Fang on 2021/10/19.
//  Copyright © 2021 Ryder. All rights reserved.
//

#import "OCMethodSwizzling.h"
#import <objc/runtime.h>

@interface MSFoo : NSObject
@end
@implementation MSFoo

- (void)instanceMethod1 {
    NSLog(@"%s", __FUNCTION__);
}

+ (void)classMethod2 {
    NSLog(@"%s", __FUNCTION__);
}

@end

@interface OCMethodSwizzling ()

@end

@implementation OCMethodSwizzling

+ (void)run {
    OCMethodSwizzling *ms = [OCMethodSwizzling new];
    Method ori = class_getInstanceMethod([MSFoo class], @selector(instanceMethod1));
    Method my = class_getInstanceMethod([ms class], @selector(testSwizzleMethod1));
    method_exchangeImplementations(ori, my);
    
//    Method cls_ori = class_getClassMethod([MSFoo class], @selector(classMethod2));
//    method_exchangeImplementations(cls_ori, my);
    
    MSFoo *foo = [MSFoo new];
    [foo instanceMethod1];
    [ms testSwizzleMethod1];
//    [MSFoo classMethod2];
}

- (void)testSwizzleMethod1 {
    NSLog(@"swizzling instance method.");
}

@end
