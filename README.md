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

需要了解几个关键概念：

* isa

* objc_object

* objc_class

* NSObject

* class 的本质

---
## UIKit

> UIKit/AppKit 与界面相关的八股知识点