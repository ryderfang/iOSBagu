//
//  OCRunloop.m
//  ObjcBagu
//
//  Created by Ryder Fang on 2021/10/15.
//  Copyright © 2021 Ryder. All rights reserved.
//

#import "OCRunloop.h"

// https://blog.ibireme.com/2015/05/18/runloop/

// Runloop 实现在 CoreFoundation 中，而不是 runtime
// https://opensource.apple.com/tarballs/CF/
/*
 * Runloop 与线程一一对应，对应关系存在全局字典中
 * 主线程的 runloop 是默认创建并启动的
 * 子线程默认不会创建 runloop，直到主要获取 ([NSRunLoop currentRunLoop])
 *   也不会主动启动 runloop，只能手动启动 ([runloop run])
 * source0 - 应用层事件
 * source1 - 系统事件，进程间消息或内核消息
 */

// 全局的Dictionary，key 是 pthread_t，value 是 CFRunLoopRef
static CFMutableDictionaryRef loopsDic;

@implementation OCRunloop

@end
