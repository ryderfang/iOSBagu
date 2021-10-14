//
//  main.m
//  ObjcBagu
//
//  Created by Ryder Fang on 2021/10/13.
//  Copyright © 2021 Ryder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCProperty.h"
#import "OCTimer.h"
#import "OCMsgForwarding.h"

// iOS runtime: https://github.com/RetVal/objc-runtime


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        [OCProperty run];
//        [OCTimer run];
//        [OCMsgForwarding run];
    }
    return 0;
}


