//
//  hello.m
//  ObjcBagu
//
//  Created by Ryder Fang on 2022/1/13.
//  Copyright © 2022 Ryder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Foo : NSObject

@property (nonatomic, assign) BOOL ppty1;
@property (nonatomic, copy) NSString *ppty2;

- (BOOL)iMethod1;

- (void)iMethod2:(NSString *)p1;

+ (void)cMethod1;

@end

@implementation Foo

- (BOOL)iMethod1 {
    return YES;
}

- (void)iMethod2:(NSString *)p1 {
    
}

+ (void)cMethod1 {
    
}

@end
