//
//  OCSwift.m
//  ObjcBagu
//
//  Created by Ryder Fang on 2022/4/28.
//  Copyright © 2022 Ryder. All rights reserved.
//

#import "OCSwift.h"
#import <BGStaticLib/BGStaticLib.h>
// OC -> Swift
#import "ObjcBagu-Swift.h"
#import <SwiftBagu/SwiftBagu-Swift.h>

@implementation OCSwift

+ (void)run {
    // call oc lib
//    [BGStaticLib hello];
    
    // call swift method
    SWTemp *temp = [[SWTemp alloc] init];
    [temp hello];

    // call swift lib
//    StringFormatter *formatter = [StringFormatter new];
//    [formatter hello];
}

@end
