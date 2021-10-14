//
//  NSTimer+RRKit.h
//  ObjcBagu
//
//  Created by Ryder Fang on 2021/10/14.
//  Copyright © 2021 Ryder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (RRKit)

+ (NSTimer *)RRKit_timerWithTimeInterval:(NSTimeInterval)interval
                              repeats:(BOOL)repeats
                                block:(void (^)(NSTimer *timer))block;

+ (NSTimer *)RRKit_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                       repeats:(BOOL)repeats
                                         block:(void (^)(NSTimer *timer))block;

@end
