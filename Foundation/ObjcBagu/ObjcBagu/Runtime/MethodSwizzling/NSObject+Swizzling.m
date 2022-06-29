//
//  NSObject+Swizzling.m
//  ObjcBagu
//
//  Created by Ryder Fang on 2022/6/29.
//  Copyright © 2022 Ryder. All rights reserved.
//

#import "NSObject+Swizzling.h"
#import <objc/runtime.h>

@implementation NSObject (Swizzling)

//MARK: 实例方法
+ (BOOL)swizzleMethod:(SEL)oriSel with:(SEL)altSel {
    Method oriMethod = class_getInstanceMethod([self class], oriSel);
    Method altMethod = class_getInstanceMethod([self class], altSel);
    if (!oriMethod || !altMethod) {
        return NO;
    }
    if (class_addMethod([self class], oriSel, method_getImplementation(altMethod), method_getTypeEncoding(altMethod))) {
        class_replaceMethod([self class], altSel, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    } else {
        method_exchangeImplementations(oriMethod, altMethod);
    }
    return YES;
}

// class_replaceMethod 比 method_exchangeImplementations 更快 ?!
// 原因在于 flushCaches 比较耗时
+ (BOOL)_swizzleMethod:(SEL)oriSel with:(SEL)altSel {
    Method oriMethod = class_getInstanceMethod(self, oriSel);
    Method altMethod = class_getInstanceMethod(self, altSel);
    if (!oriMethod || !altMethod) {
        return NO;
    }
    class_addMethod(self,
                    oriSel,
                    class_getMethodImplementation(self, oriSel),
                    method_getTypeEncoding(oriMethod));
    class_addMethod(self,
                    altSel,
                    class_getMethodImplementation(self, altSel),
                    method_getTypeEncoding(altMethod));
       
    IMP oriIMP = method_getImplementation(class_getInstanceMethod(self, oriSel));
        
    /* 1. 替换 altSel 实现
     * altSel -> oriIMP
     * oriSel -> oriIMP
     */
    IMP altIMP = class_replaceMethod(self, altSel, oriIMP, method_getTypeEncoding(oriMethod));
    /* 这时可能存在另一个 swizzle 导致
     * oriSel -> otherIMP
     * otherSel -> oriIMP
     */
    
    /* 2. 替换原始实现
     * altSel -> oriIMP
     * oriSel -> altIMP
     * otherSel -> oriIMP
     */
    IMP otherIMP = class_replaceMethod(self, oriSel, altIMP, method_getTypeEncoding(altMethod));
    if (otherIMP && otherIMP != oriIMP) {
        /* 3. 将 altSel 替换回去，保证另一个 swizzle 能生效
         * altSel -> otherIMP
         * oriSel -> altIMP
         * otherSel -> oriIMP
         */
        class_replaceMethod(self, altSel, otherIMP, method_getTypeEncoding(oriMethod));
    }
    return YES;
}

/* replace [self altSel] to call oriIMP
* ((void (*)(id, SEL))oriIMP)(self, oriSel)
*/
+ (IMP)oriIMP4SwizzleMethod:(SEL)oriSel with:(SEL)altSel {
    Method oriMethod = class_getInstanceMethod(self, oriSel);
    Method altMethod = class_getInstanceMethod(self, altSel);
    if (!oriMethod || !altMethod) {
        return nil;
    }
        
    class_addMethod(self,
                    oriSel,
                    class_getMethodImplementation(self, oriSel),
                    method_getTypeEncoding(oriMethod));
    class_addMethod(self,
                    altSel,
                    class_getMethodImplementation(self, altSel),
                    method_getTypeEncoding(altMethod));
   
    IMP altIMP = method_getImplementation(class_getInstanceMethod(self, altSel));
        
    IMP oriIMP = class_replaceMethod(self, oriSel, altIMP, method_getTypeEncoding(altMethod));
    return oriIMP;
}

+ (BOOL)swizzleMethod:(SEL)oriSel with:(SEL)altSel altClass:(Class)altCls {
    Method oriMethod = class_getInstanceMethod([self class], oriSel);
    Method altMethod = class_getInstanceMethod(altCls, altSel);
    if (!oriMethod || !altMethod) {
        return NO;
    }
    if (class_addMethod([self class], oriSel, method_getImplementation(altMethod), method_getTypeEncoding(altMethod))) {
        class_replaceMethod(altCls, altSel, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    } else {
        method_exchangeImplementations(oriMethod, altMethod);
    }
    return YES;
}

+ (BOOL)swizzleMethod:(SEL)oriSel fromClass:(Class)fromCls with:(SEL)altSel {
    return [fromCls swizzleMethod:oriSel with:altSel altClass:self];
}

+ (BOOL)swizzleMethod:(SEL)oriSel fromClass:(Class)fromCls with:(SEL)altSel altClass:(Class)altCls {
    return [fromCls swizzleMethod:oriSel with:altSel altClass:altCls];
}

//MARK: 类方法
+ (BOOL)swizzleClassMethod:(SEL)oriSel with:(SEL)altSel {
    Class metaCls = object_getClass(self);
    return [metaCls swizzleMethod:oriSel with:altSel];
}

@end
