# 什么是 Runtime？

当我们在讲 `Runtime` 的时候，我们在说什么？

根据官方文档的定义，

[Objective-C Runtime](https://developer.apple.com/documentation/objectivec/objective-c_runtime?language=objc)

[Objective-C Runtime Programming Guide](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Introduction/Introduction.html#//apple_ref/doc/uid/TP40008048-CH1-SW1)

Runtime 是一个动态库 (/usr/lib/libobjc.A.dylib)，用于实现 OC 语言的动态性。

动态性主要体现在三个方法：

- Dynamic Typing 运行时才能决定对象的类型，也就是说编译器不检查类型合法性
- Dynamic Binding 运行时才能知道方法被如何执行，也就是消息机制 (messaging)
- Dynamic Loading 允许动态添加类、方法等

## 几个关键概念

### `isa / objc_object`

定义在 `#import <objc/objc.h>` 中

```
/// An opaque type that represents an Objective-C class.
typedef struct objc_class *Class;

/// Represents an instance of a class.
struct objc_object {
    Class _Nonnull isa  OBJC_ISA_AVAILABILITY;
};

/// A pointer to an instance of a class.
typedef struct objc_object *id;
```

id 表示所有对象的实例类型，objc_object 表示一个类的实例，其中只有一个指针，就是 isa，指向的是这个实例的类。

### `objc_class`

定义在 `#import <objc/runtime.h>` 中

```
struct objc_class {
    Class _Nonnull isa  OBJC_ISA_AVAILABILITY;

#if !__OBJC2__
    Class _Nullable super_class                              OBJC2_UNAVAILABLE;
    const char * _Nonnull name                               OBJC2_UNAVAILABLE;
    long version                                             OBJC2_UNAVAILABLE;
    long info                                                OBJC2_UNAVAILABLE;
    long instance_size                                       OBJC2_UNAVAILABLE;
    struct objc_ivar_list * _Nullable ivars                  OBJC2_UNAVAILABLE;
    struct objc_method_list * _Nullable * _Nullable methodLists                    OBJC2_UNAVAILABLE;
    struct objc_cache * _Nonnull cache                       OBJC2_UNAVAILABLE;
    struct objc_protocol_list * _Nullable protocols          OBJC2_UNAVAILABLE;
#endif

} OBJC2_UNAVAILABLE;
/* Use `Class` instead of `struct objc_class *` */
```

在底层实现中 objc_class 是继承自 objc_object 的

objc_class 中也有一个 isa 指针，指向了自己的元类。

### `NSObject`

NSObject 是所有 OC 对象的基类 (除 CGRect 这类结构体)，也可以称为根类 (Root Class)。

### `class` 的本质

在 NSObject 中定义了两种 class 方法：

```
- (Class)class OBJC_SWIFT_UNAVAILABLE("use 'type(of: anObject)' instead");
// 实例方法，返回 isa 指针，也就是类对象
- (Class)class {
   return object_getClass(self);
}

Class object_getClass(id obj) {
   if (obj) return obj->getIsa();
   else return Nil;
}

+ (Class)class OBJC_SWIFT_UNAVAILABLE("use 'aClass.self' instead");
// 类方法，返回自身
+ (Class)class {
   return self;
}
```

## 常用的 Runtime 方法

