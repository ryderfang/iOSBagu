//
//  BGPreLoader.m
//  BGStaticLib
//
//  Created by Ryder Fang on 2022/6/8.
//

#import "BGPreLoader.h"
#include <dlfcn.h>
#import <mach-o/dyld.h>
#import <mach-o/getsect.h>
#import <iostream>

@implementation BGPreLoader

@end

static NSString * const s_myStr = @"The quick brown fox jumps over the lazy dog";

#define _PRELD_SECNAME "_my_pre_data"

#define _STR(name) (#name)

#define _PRELD_DATA(_k, _v, _i)\
__attribute((used, section("__DATA," _PRELD_SECNAME))) static my_data_t _dt##_k = \
{\
    _STR(_k),\
    _STR(_v),\
    _i,\
};\

__attribute((used, section("__DATA,_my_pre_data"))) static const char *quote = "Practice makes perfect.";

_PRELD_DATA(kkk, vvv, 1)
_PRELD_DATA(eee, aaa, 2)
_PRELD_DATA(yyy, lll, 3)

//__attribute((used, section("__DATA,_my_pre_data"))) static my_data_t dt1 = {
//    "kkk1",
//    "vvv1",
//};
//
//__attribute((used, section("__DATA,_my_pre_data"))) static my_data_t dt2 = {
//    "eee2",
//    "aaa2",
//};
//
//__attribute((used, section("__DATA,_my_pre_data"))) static my_data_t dt3 = {
//    "yyy3",
//    "lll3",
//};

static void dyld_func(const struct mach_header *header, intptr_t slide) {
//    Dl_info  DlInfo;
//    dladdr(header, &DlInfo);
//    const char* image_name = DlInfo.dli_fname;
//    std::cout << image_name << std::endl;
    unsigned long size = 0;
#if defined(__LP64__) && __LP64__
    const struct mach_header_64 *mhp64 = (const struct mach_header_64 *)header;
    uintptr_t *memory = (uintptr_t *)getsectiondata(mhp64, SEG_DATA, _PRELD_SECNAME, &size);
#else
    uintptr_t *memory = (uintptr_t *)getsectiondata(header, SEG_DATA, _PRELD_SECNAME, &size);
#endif
    unsigned long n = size / sizeof(my_data_t);
    my_data_t *data = (my_data_t *)memory;
    for (int i = 0; i < n; i++) {
        my_data_t tmp = data[i];
        std::cout << tmp.key << ": " << tmp.val << "(" << tmp.idx << ")" << std::endl;
    }
}

__attribute__((constructor)) void preMainMethod() {
    _dyld_register_func_for_add_image(dyld_func);
}
