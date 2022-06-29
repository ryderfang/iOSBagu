//
//  OCMethodSwizzling.h
//  ObjcBagu
//
//  Created by Ryder Fang on 2021/10/19.
//  Copyright © 2021 Ryder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCMethodSwizzlingSuper : NSObject

- (void)sp_instanceMethod;

@end

@interface OCMethodSwizzling : OCMethodSwizzlingSuper <CommonProtocol>

@end

