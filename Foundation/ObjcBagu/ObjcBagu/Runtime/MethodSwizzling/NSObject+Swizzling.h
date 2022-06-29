//
//  NSObject+Swizzling.h
//  ObjcBagu
//
//  Created by Ryder Fang on 2022/6/29.
//  Copyright © 2022 Ryder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Swizzling)

//MARK: 实例方法
// [self oriSel] <-> [self altSel]
+ (BOOL)swizzleMethod:(SEL)oriSel with:(SEL)altSel;
// [self oriSel] -> [self altSel] 单向替换，使用返回值调用原实现
+ (IMP)oriIMP4SwizzleMethod:(SEL)oriSel with:(SEL)altSel;

// [self oriSel] -> [altCls altSel]
+ (BOOL)swizzleMethod:(SEL)oriSel with:(SEL)altSel altClass:(Class)altCls;
// [fromCls oriSel] -> [self altSel]
+ (BOOL)swizzleMethod:(SEL)oriSel fromClass:(Class)fromCls with:(SEL)altSel;
// [fromCls oriSel] -> [altCls altSel]
+ (BOOL)swizzleMethod:(SEL)oriSel fromClass:(Class)fromCls with:(SEL)altSel altClass:(Class)altCls;

//MARK: 类方法
+ (BOOL)swizzleClassMethod:(SEL)oriSel with:(SEL)altSel;

@end

