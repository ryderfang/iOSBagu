//
//  MyOCFunction.h
//  SwiftBagu
//
//  Created by Ryder Fang on 2022/5/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyOCFunction : NSObject

- (void)callBlock:(CGFloat (^)(CGFloat a, CGFloat b))block;

@end

NS_ASSUME_NONNULL_END
