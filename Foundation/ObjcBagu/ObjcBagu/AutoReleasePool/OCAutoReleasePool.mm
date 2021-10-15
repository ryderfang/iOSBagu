//
//  OCAutoReleasePool.m
//  ObjcBagu
//
//  Created by Ryder Fang on 2021/10/15.
//  Copyright © 2021 Ryder. All rights reserved.
//

#import "OCAutoReleasePool.h"

// https://draveness.me/autoreleasepool/#objc_autoreleasePoolPush
/*
 引用一段来自 runtime 的解释：
 A thread's autorelease pool is a stack of pointers.
 Each pointer is either an object to release, or POOL_BOUNDARY which is
    an autorelease pool boundary.
 A pool token is a pointer to the POOL_BOUNDARY for that pool. When
    the pool is popped, every object hotter than the sentinel is released.
 The stack is divided into a doubly-linked list of pages. Pages are added
    and deleted as necessary.
 Thread-local storage points to the hot page, where newly autoreleased
    objects are stored.
 ----
 1. AutoReleasePool 是一组指针组成的双向链表结构，同时也是一个栈式结构
 2. 每个指针都指向一个待释放的对象，或者是一个哨兵(sentinel) 对象，哨兵对象是 POOL_BOUNDARY，是一个空指针，用于标识当前 page 已满
 3. 核心数据结构 AutoreleasePoolPage
 3. 核心方法 AutoreleasePoolPage::autorelease(), AutoreleasePoolPage::push(), AutoreleasePoolPage::pop()
 */

struct magic_t {
    
};

// sentinel
#define POOL_BOUNDARY nil
 
// 每一个 AutoreleasePoolPage 对象占用 4096 个字节，为虚拟内存一个扇区的大小，有利于 4K 对齐，提高硬盘寿命
#define I386_PGBYTES 4096
// redefine
//#define PAGE_SIZE I386_PGBYTES

// ---------------------------------
/* 内存布局
0x100817000 |-----------------|
            |      end()      |
            |-----------------|
            |    objects..    |
            |                 |
0x100816048 |-----------------| <- next
            |   id *object    |
0x100816040 |-----------------|
            |  POOL_BOUNDARY  |
0x100816038 |-----------------|
            |      hiwat      |
0x100816034 |-----------------|
            |      depth      |
0x100816030 |-----------------|
            |      *child     |
0x100816028 |-----------------|
            |     *parent     |
0x100816020 |-----------------|
            |      thread     |
0x100816028 |-----------------|
            |      *next      |
0x100816010 |-----------------|
            |      magic      |
0x100816000 |-----------------|
            |      begin()    |
0x100816000 |-----------------|

*/
// ---------------------------------

class AutoreleasePoolPage;
struct AutoreleasePoolPageData {
    magic_t const magic;                    // 完整性校验
    __unsafe_unretained id *next;          // 在添加一个 autorelease 对象后，指向下一个空的内存区域
    pthread_t const thread;                 // 当前线程对象
    AutoreleasePoolPage * const parent;   // 指向上一页
    AutoreleasePoolPage *child;            // 指向下一页
    uint32_t const depth;                   // 节点个数
    uint32_t hiwat;                          // 水位线 (= p->depth*COUNT + (uint32_t)(p->next - p->begin()) )

    AutoreleasePoolPageData(__unsafe_unretained id* _next, pthread_t _thread, AutoreleasePoolPage* _parent, uint32_t _depth, uint32_t _hiwat)
        : magic(), next(_next), thread(_thread),
          parent(_parent), child(nil),
          depth(_depth), hiwat(_hiwat)
    {
    }
};

class AutoreleasePoolPage : private AutoreleasePoolPageData {
public:
//    static inline id autorelease(id obj) {
//        ASSERT(obj);
//        ASSERT(!obj->isTaggedPointer());
//        id *dest __unused = autoreleaseFast(obj);
//        ASSERT(!dest  ||  dest == EMPTY_POOL_PLACEHOLDER  ||  *dest == obj);
//        return obj;
//    }
//
//
//    static inline void *push() {
//        id *dest;
//        if (slowpath(DebugPoolAllocation)) {
//            // Each autorelease pool starts on a new pool page.
//            dest = autoreleaseNewPage(POOL_BOUNDARY);
//        } else {
//            dest = autoreleaseFast(POOL_BOUNDARY);
//        }
//        ASSERT(dest == EMPTY_POOL_PLACEHOLDER || *dest == POOL_BOUNDARY);
//        return dest;
//    }
//
//    static inline id *autoreleaseFast(id obj) {
//        AutoreleasePoolPage *page = hotPage();
//        if (page && !page->full()) {
//            return page->add(obj);
//        } else if (page) {
//            return autoreleaseFullPage(obj, page);
//        } else {
//            return autoreleaseNoPage(obj);
//        }
//    }
//
//    static inline void pop(void *token) {
//        AutoreleasePoolPage *page;
//        id *stop;
//        if (token == (void*)EMPTY_POOL_PLACEHOLDER) {
//            // Popping the top-level placeholder pool.
//            page = hotPage();
//            if (!page) {
//                // Pool was never used. Clear the placeholder.
//                return setHotPage(nil);
//            }
//            // Pool was used. Pop its contents normally.
//            // Pool pages remain allocated for re-use as usual.
//            page = coldPage();
//            token = page->begin();
//        } else {
//            page = pageForPointer(token);
//        }
//
//        stop = (id *)token;
//        if (*stop != POOL_BOUNDARY) {
//            if (stop == page->begin()  &&  !page->parent) {
//                // Start of coldest page may correctly not be POOL_BOUNDARY:
//                // 1. top-level pool is popped, leaving the cold page in place
//                // 2. an object is autoreleased with no pool
//            } else {
//                // Error. For bincompat purposes this is not
//                // fatal in executables built with old SDKs.
//                return badPop(token);
//            }
//        }
//
//        if (slowpath(PrintPoolHiwat || DebugPoolAllocation || DebugMissingPools)) {
//            return popPageDebug(token, page, stop);
//        }
//
//        return popPage<false>(token, page, stop);
//    }
};

//void *objc_autoreleasePoolPush(void) {
//    return AutoreleasePoolPage::push();
//}
//
//void objc_autoreleasePoolPop(void *ctxt) {
//    AutoreleasePoolPage::pop(ctxt);
//}

@interface OCAutoReleasePool ()

@property (nonatomic, copy) NSString *myStr;

@end

// TODO: 子线程 pool 需要手动创建
@implementation OCAutoReleasePool

+ (void)run {
    OCAutoReleasePool *pl = [OCAutoReleasePool new];
    [pl testRelease1];
    [pl testRelease2];
}

- (void)testRelease1 {
    for (int i = 0; i < PAGE_SIZE / 1000; i++) {
        // @autoreleasepool {} 是下面的简化形式
    //    void *obj = objc_autoreleasePoolPush();
    //    objc_autoreleasePoolPop(obj);
        @autoreleasepool {
            NSString *str = @"Hello, World";
            str = [str uppercaseString];
            str = [NSString stringWithFormat:@"%@ %d", str, i];
            NSLog(@"str");
        }
    }
    
    // 自动加入最近创建的 pool 中
    NSString * __autoreleasing tmp = @"Hooooo";
    self.myStr = tmp;
}

- (void)testRelease2 {
    NSArray *temp = @[@"1", @"2", @"3"];
    [temp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 这里存在一个 @autoreleasepool
        NSLog(@"%@", obj);
    }];
}

@end
