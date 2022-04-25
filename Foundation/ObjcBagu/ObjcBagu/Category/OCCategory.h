//
//  OCCategory.h
//  ObjcBagu
//
//  Created by Ryder Fang on 2021/10/19.
//  Copyright © 2021 Ryder. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
 * 结论：
 * load 方法在 main 函数前执行，调用顺序：父类->子类->分类
 * initialzie 方法在的实例被访问时调用，分类会覆盖原类
 */

@interface OCCategory : NSObject <CommonProtocol>

- (void)testSameMethod;

@end

@interface OCCategorySubClass : OCCategory

@end

NS_ASSUME_NONNULL_END
