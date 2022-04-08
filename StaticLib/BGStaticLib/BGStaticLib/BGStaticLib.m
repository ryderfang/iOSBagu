//
//  BGStaticLib.m
//  BGStaticLib
//
//  Created by Ryder Fang on 2022/4/8.
//

#import "BGStaticLib.h"
#import "BGProtocol.h"

@implementation BGStaticLib

- (instancetype)init {
    if (self = [super init]) {
//        NSProtocolFromString(@"BGProtocol");
        @protocol(BGProtocol);
    }
    return self;
}

@end
