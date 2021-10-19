//
//  OCCategory.m
//  ObjcBagu
//
//  Created by Ryder Fang on 2021/10/19.
//  Copyright © 2021 Ryder. All rights reserved.
//

#import "OCCategory.h"
#import "OCCategory+T1.h"
#import "OCCategory+T2.h"
#import <objc/runtime.h>

// https://nenhall.github.io/2019/02/22/iOS-Category/
@implementation OCCategory

//struct objc_object {
//private:
//    isa_t isa;
//};
//
//struct objc_class : objc_object {
//    Class superclass;
//    const char *name;
//    uint32_t version;
//    uint32_t info;
//    uint32_t instance_size;
//    struct old_ivar_list *ivars;
//    struct old_method_list **methodLists;
//    Cache cache;
//    struct old_protocol_list *protocols;
//    // CLS_EXT only
//    const uint8_t *ivar_layout;
//    struct old_class_ext *ext;
//};

//struct category_t {
//    const char *name;
//    classref_t cls;
//    WrappedPtr<method_list_t, PtrauthStrip> instanceMethods;
//    WrappedPtr<method_list_t, PtrauthStrip> classMethods;
//    struct protocol_list_t *protocols;
//    struct property_list_t *instanceProperties;
//    // Fields below this point are not always present on disk.
//    struct property_list_t *_classProperties;
//
//    method_list_t *methodsForMeta(bool isMeta) {
//        if (isMeta) return classMethods;
//        else return instanceMethods;
//    }
//
//    property_list_t *propertiesForMeta(bool isMeta, struct header_info *hi);
//
//    protocol_list_t *protocolsForMeta(bool isMeta) {
//        if (isMeta) return nullptr;
//        else return protocols;
//    }
//};

/*
 _objc_init
 load_images
 prepare_load_methods
     schedule_class_load
     add_class_to_loadable_list
     add_category_to_loadable_list
 call_load_methods
     call_class_loads
     call_category_loads
     (*load_method)(cls, SEL_load)
 */
// 先执行类的 load，再执行分类的；分类的 load 顺序由编译顺序决定，先编译的先执行。(Build Phases -> Compile Sources)
// load 方法是通过直接找到 load_method_t 函数指针，调用的，不走 objc_msgSend，所以不会只执行分类实现
+ (void)load {
    NSLog(@"primary load.");
}

+ (void)initialize {
    NSLog(@"primary initialize.");
}

+ (void)run {
    OCCategory *cate = [OCCategory new];
    [cate testSameMethod];
    [cate getAllInstanceMethods];
}

- (void)getAllInstanceMethods {
    
}

// 分类将类中的同名方法覆盖，是在运行时将方法列表插入原类的方法列表前实现的，并没有删除原类的实现。
// 多个分类同名方法，执行后编译的。
- (void)testSameMethod {
    NSLog(@"primary method called.");
}

// 分类不能添加变量，因为 category_t 的结构中没有 ivar_list; 另一方面，在运行时，对象的所占的空间大小已经确定，无法修改。
- (void)testAssociatedObject {
    
}

@end
