//
//  DemoViewController.m
//  UIKitBagu
//
//  Created by Ryder Fang on 2022/5/24.
//  Copyright © 2022 Ryder. All rights reserved.
//

#import "DemoViewController.h"

@interface DemoViewController ()

// weak 的 timer 本身已经打破了 vc --> timer -> vc 的循环引用
@property (nonatomic, weak) NSTimer *timer;

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor greenColor];
    
    [self createTimer];
}

- (void)dealloc {
    NSLog(@"DemoViewController dealloced");
}

- (void)fire:(NSTimer *)timer {
    NSLog(@"_timer tick");
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // 打破 runloop -> timer 的引用，关键在于及时释放 timer
    [self.timer invalidate];
    self.timer = nil;
}

- (void)createTimer {
    NSTimer *timer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:1] interval:1 target:self selector:@selector(fire:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    _timer = timer;
}

@end
