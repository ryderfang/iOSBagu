# iOS 八股大法

## Foundation

> 语言层面的八股知识点，尽可能刁钻的问题

看文章很难记住，还是代码跑起来比较直观：

`open ./Foundation/ObjcBagu/ObjcBagu.xcodeproj`

所以这里只简单列一些要点

### I. ARC/MRC ★★★☆☆

`ARC is supported in Xcode 4.2 for OS X v10.6 and v10.7 (64-bit applications) and for iOS 4 and iOS 5.`

现在除了一些老项目，基本没有 MRC 为主的代码了，所以只需要简单了解下 MRC 与 ARC 的区别即可

1. MRC 需要手动写 dealloc，并且一定要最后再调用父类的 dealloc；
   ARC 一般不需要写 dealloc，也不需要调用 [super dealloc]。移除 NSNotification Observer 和 KVC 例外。

2. 在 ARC 的工程中使用 MRC，需要在工程中设置源文件的编译选项 `-fno-objc-arc`

### II. AutoReleasePool ★★★★☆

### III. Block ★★★★★

### IV. Category ★★★★★

### V. HotPatch ★☆☆☆☆

### VI. KVC ★★☆☆☆

### VII. KVO ★★★★☆

### VIII. MultiThread ★★★★☆️

### IX. Network ★★★☆☆️

### X. NSTimer ★★★★★️

### XI. Property ★★★★★️

### XII. Runloop ★★★★☆️

### XIII. Runtime ★★★★★

> 详解：[Runtime 详解](Foundation/Notes/runtime.md)

需要了解几个关键概念：

* isa/objc_object

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

* objc_class

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

* NSObject

NSObject 是所有 OC 对象的基类 (除 CGRect 这类结构体)，也可以称为根类 (Root Class)。

* class 的本质

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

一图胜千言，引用 Runtime 工程师 [Greg Parker](http://www.sealiesoftware.com/blog/archive/2009/04/14/objc_explain_Classes_and_metaclasses.html) 在其博客中给出的经典图

![](Assets/class-diagram.png)

---
## UIKit

> UIKit/AppKit 与界面相关的八股知识点