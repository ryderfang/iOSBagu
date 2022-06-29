//
//  OCGCD.m
//  ObjcBagu
//
//  Created by Ryder Fang on 2022/4/10.
//  Copyright © 2022 Ryder. All rights reserved.
//

#import "OCGCD.h"

@interface OCGCD()

@property (nonatomic, strong) NSString *myStr;

@end

@implementation OCGCD

+ (void)run {
//    dispatch_get_current_queue();
    OCGCD *gcd = [OCGCD new];
//    [gcd testPerformSelector];
//    [gcd testAsyncManyTimes];
//    [gcd testOrder];
}

- (void)testPerformSelector {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    dispatch_async(queue, ^{
        NSLog(@"before performSelector");
        {
            // 子线程方法不会执行，因为子线程 runloop 默认没有唤醒 (定时器的实现依赖 runloop)
//            [self performSelector:@selector(_log:) withObject:sem afterDelay:0];
            // 可以手动唤醒，这样就能执行 log 了
//            [[NSRunLoop currentRunLoop] run];

            // gcd 的定时器没有这个问题，依赖 dispatch_source_set_timer 实现
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), queue, ^{
                [self _log:sem];
            });
        }
        {
            // 这个不依赖定时器，就可以调用
//            [self performSelector:@selector(_log:) withObject:sem];
        }
        NSLog(@"after performSelector");
        //dispatch_semaphore_signal(sem);
    });
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
}

- (void)_log:(dispatch_semaphore_t)sem {
    NSLog(@"_log");
    // 不手动唤醒 runloop，将永远 wait
    dispatch_semaphore_signal(sem);
}

- (void)testAsyncManyTimes {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 100000000; i++) {
//            self.myStr = [NSString stringWithFormat:@"%d_test", i];
            self.myStr = [NSString stringWithFormat:@"%d", i];
        }
    });
}

- (void)testOrder {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    // 1 2 3
    dispatch_async(queue, ^{
        NSLog(@"1");
    });
    dispatch_sync(queue, ^{
        sleep(1);
        NSLog(@"2");
    });
    dispatch_async(queue, ^{
        NSLog(@"3");
    });
}

@end
