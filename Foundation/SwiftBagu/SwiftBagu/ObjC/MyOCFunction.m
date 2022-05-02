//
//  MyOCFunction.m
//  SwiftBagu
//
//  Created by Ryder Fang on 2022/5/1.
//

#import "MyOCFunction.h"

@implementation MyOCFunction

- (void)callBlock:(CGFloat (^)(CGFloat , CGFloat ))block {
    NSLog(@"%.2f", block(1.1, 2.2));
}

@end
