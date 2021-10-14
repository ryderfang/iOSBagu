//
//  OCWeakObj.h
//  ObjcBagu
//
//  Created by Ryder Fang on 2021/10/14.
//  Copyright © 2021 Ryder. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (OCWeakObj)

+ (NSTimer *)RRKit_weakTimerWithTimeInterval:(NSTimeInterval)ti
                                      target:(id)aTarget
                                    selector:(SEL)aSelector
                                    userInfo:(nullable id)userInfo
                                     repeats:(BOOL)yesOrNo;

@end

@interface OCWeakObj : NSObject

@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;

// 显示调用
- (void)fire:(NSTimer *)timer;

@end

NS_ASSUME_NONNULL_END
