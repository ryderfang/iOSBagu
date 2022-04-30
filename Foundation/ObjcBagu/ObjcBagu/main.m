//
//  main.m
//  ObjcBagu
//
//  Created by Ryder Fang on 2021/10/13.
//  Copyright © 2021 Ryder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCAutoReleasePool.h"
#import "OCBlock.h"
#import "OCCategory.h"
#import "OCGCD.h"
#import "OCMRC.h"
#import "OCMethodSwizzling.h"
#import "OCMsgForwarding.h"
#import "OCProperty.h"
#import "OCProtocolImpl.h"
#import "OCRuntime.h"
#import "OCSwift.h"
#import "OCTimer.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
//        [OCAutoReleasePool run];
//        [OCBlock run];
//        [OCCategory run];
//        [OCGCD run];
//        [OCMRC run];
//        [OCMethodSwizzling run];
//        [OCMsgForwarding run];
        [OCProperty run];
//        [OCProtocolImpl run];
//        [OCRuntime run];
//        [OCTimer run];
//        [OCSwift run];

    }
    return 0;
}


