//
//  BGPreLoader.h
//  BGStaticLib
//
//  Created by Ryder Fang on 2022/6/8.
//

#import <Foundation/Foundation.h>

typedef struct {
    char *key;
    char *val;
    int idx;
} my_data_t;

// 在 main 之前从 mach-O 中预加载一部分数据
@interface BGPreLoader : NSObject

@end

