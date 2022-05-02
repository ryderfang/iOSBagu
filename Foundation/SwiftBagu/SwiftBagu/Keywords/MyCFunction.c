//
//  MyCFunction.c
//  SwiftBagu
//
//  Created by Ryder Fang on 2022/5/1.
//

#include "MyCFunction.h"

CGFloat myCFunction(CGFloat (callback)(CGFloat x, CGFloat y)) {
    return callback(1.1, 2.2);
}
