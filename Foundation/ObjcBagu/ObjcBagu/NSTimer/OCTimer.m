//
//  OCTimer.m
//  ObjcBagu
//
//  Created by Ryder Fang on 2021/10/14.
//  Copyright © 2021 Ryder. All rights reserved.
//

#import "OCTimer.h"
#import "NSTimer+RRKit.h"
#import "OCWeakObj.h"
#import "OCWeakProxy.h"

// runloop -> timer -> view -> timer (timer 与 view 相互强引用，导致循环引用)
// 三种方法解决循环引用:
// 1. 在合适的时机 invalidate timer，如 VC 的 disappear 时，或者不再需要 timer 的时候
// 2. 通过 NSTimer 的 category，将两个强引用 self 的 timer 构造方法，改成 block 形式 (系统方法仅支持 iOS 10+)
// 3. 通过一个中间对象 (weakObj)，self -> timer，timer -> weakObj，但 self 弱引用 weakObj，打破循环引用
// - 中间对象的方法调用，有两种方案，一种是显式调用 (OCWeakObj)，一种是代理转发 (OCWeakProxy)

@interface OCTimer ()

@property (nonatomic, strong) dispatch_semaphore_t sem;
@property (nonatomic, strong) NSThread *residentThread;

@property (nonatomic, weak) NSTimer *realWeakTimer;

@property (nonatomic, strong) NSTimer *strongTimer;
@property (nonatomic, strong) NSTimer *weakTimer1;
@property (nonatomic, strong) NSTimer *weakTimer2;
@property (nonatomic, strong) NSTimer *weakTimer3;

@end

@implementation OCTimer

- (instancetype)init {
    if (self = [super init]) {
        _sem = dispatch_semaphore_create(0);
        _residentThread = [[NSThread alloc] initWithTarget:self selector:@selector(startThread) object:nil];
        
//        _realWeakTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(fire) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)fire:(NSTimer *)timer {
    NSLog(@"_realWeakTimer tick");
    static int tickCount = 0;
    tickCount++;
    if (tickCount == 3) {
        [self.realWeakTimer invalidate];
        self.realWeakTimer = nil;
        dispatch_semaphore_signal(self.sem);
    }
}

+ (void)run {
    OCTimer *t = [OCTimer new];
    [t.residentThread start];
    
    // 阻止 app 退出
    dispatch_semaphore_wait(t.sem, DISPATCH_TIME_FOREVER);
    
//    [NSThread sleepForTimeInterval:2];
}

- (void)start {
    [self.residentThread start];
    dispatch_semaphore_wait(self.sem, DISPATCH_TIME_FOREVER);
}

- (void)dealloc {
    NSLog(@"dealloc");
}

- (void)startThread {
    [[NSThread currentThread] setName:@"xx"];
    NSRunLoop *rl = [NSRunLoop currentRunLoop];
    // 存在 source/timer 时，runloop 才不会退出
    [rl addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
    
    [self createRealWeakTimer];
    [self createStrongTimer];
    
    // NSRunLoopCommonModes 是 (NSEventTrackingRunLoopMode | NSDefaultRunLoopMode) 模式
    // 在 scrollView 滚动时，runloop 自动切换到 NSEventTrackingRunLoopMode 模式，导致 timer 失效，使用 NSRunLoopCommonModes 解决这个问题
    [rl addTimer:self.strongTimer forMode:NSRunLoopCommonModes];
    [self createWeakTimers];
    [rl addTimer:self.weakTimer1 forMode:NSDefaultRunLoopMode];
    [rl addTimer:self.weakTimer2 forMode:NSDefaultRunLoopMode];
    [rl addTimer:self.weakTimer3 forMode:NSDefaultRunLoopMode];

    [rl run];
    // 所有 timer 销毁后，runloop 才会退出
    NSLog(@"thread exit");
    
//    [self.weakTimer2 invalidate];
//    self.weakTimer2 = nil;
//    [self.weakTimer3 invalidate];
//    self.weakTimer3 = nil;
}

- (void)createRealWeakTimer {
    NSTimer *timer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:1] interval:1 target:self selector:@selector(fire:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    _realWeakTimer = timer;
}

- (void)createStrongTimer {
    self.strongTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(strongTick) userInfo:nil repeats:YES];
}

- (void)createWeakTimers {
    __weak typeof(self) weakSelf = self;
    // timerWithTimeInterval 与 scheduledTimerWithTimeInterval 的区别在于：
    // 前者需要手动加入 runloop 才能运行，后者会以 NSDefaultRunLoopMode 加入到当前 runloop 中
    self.weakTimer1 = [NSTimer RRKit_timerWithTimeInterval:5 repeats:NO block:^(NSTimer *timer) {
        NSLog(@"weak timer1 stop");
        // 如果不强行 kill strongTimer，就会由于循环引用导致 self 不会被释放!
        [weakSelf.strongTimer invalidate];
        weakSelf.strongTimer = nil;
        dispatch_semaphore_signal(weakSelf.sem);
    }];
    
    self.weakTimer2 = [NSTimer RRKit_weakTimerWithTimeInterval:2 target:self selector:@selector(weakTick) userInfo:nil repeats:NO];
    self.weakTimer3 = [NSTimer scheduledTimerWithTimeInterval:3 target:[OCWeakProxy proxyWithTarget:self] selector:@selector(weakTick) userInfo:nil repeats:NO];
}

- (void)strongTick {
    NSLog(@"strongTick...");
}

- (void)weakTick {
    NSLog(@"weakTick...");
}

@end
