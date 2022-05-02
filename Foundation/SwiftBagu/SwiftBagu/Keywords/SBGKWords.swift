//
//  SBGKWords.swift
//  SwiftBagu
//
//  Created by Ryder Fang on 2022/4/29.
//

import Foundation

struct Meeting {
    var name : String
    var date : Date?
    init() {
        self.name = ""
        self.date = Date()
    }
    
    mutating func cancel() {
        self.date = nil
    }
}

internal class SBGKWords {
    var defaultValue : Double = 0 {
        willSet {
//            print("defaultValue willSet")
        }
        didSet {
//            print("defaultValue didSet")
        }
        
    }
    lazy var calculatedValue : Double = {
        print("caclulatedValue get")
        return self.defaultValue * 2.0
    }()
    
    init() {
        
    }
    
    func hello() {
//        let sema = DispatchSemaphore(value: 0);
//        self._autoclosure(1 < 2)
//        self._autoclosure({1 < 2}())
//        self._escapingclosure(3, 5, sema, { $0 + $1 })
//        self._convention()
//        self._defer()
//        self._extension()
//        self._fallthrough()
//        self._guard()
//        var num = 1
//        self._inout(num: &num)
//        print(num)
//        self._var()
//        self._lazy()
        self._closures()
                
//        if (sema.wait(timeout: .distantFuture) == .success) {
//
//        }
    }
    
    private func _autoclosure(_ bar: @autoclosure () -> Bool) {
        if bar() {
            print(#function)
        }
    }
    
    // 实参标签 参数名称: 参数类型
    // _ 参数名称: 参数类型
    
    // MARK: Closures
    private func _escapingclosure(_ arg1: Int, _ arg2: Int, _ sema: DispatchSemaphore, _ bar: @escaping (_ a: Int, _ b: Int) -> Int) {
        let concurrentQueue = DispatchQueue(label: "com.ryder.concurrent.queue1", attributes: .concurrent)
        concurrentQueue.asyncAfter(wallDeadline: .now() + 1.5) {
            print(bar(arg1, arg2))
            sema.signal()
        }
    }
    
    private func _convention() {
        // call c
        let cFunc : @convention(c) (Double, Double) -> Double = {
            (x, y) -> Double in
            return x + y
        }
        print(myCFunction(cFunc))
        
        // call oc
        let ocFunc : @convention(block) (Double, Double) -> Double = {
            (x, y) -> Double in
            return x + y
        }
        let ocCls = MyOCFunction()
        ocCls.call(ocFunc)
    }

    private func _defer() {
        var num = 1
        defer { print("Defer: \(num)") }
        num += 1
        print("Number: \(num)")
    }
   
    // MARK: 扩展
    private func _extension() {
        let ocCls = MyOCFunction(temp: 10);
        print(ocCls.fact)
    }
    
    private func _fallthrough() {
        enum CompassPoint : String {
            case north = "North"
            case south
            case east
            case west
        }
        var pos : CompassPoint = .north
        switch (pos) {
        case .north:
            print("Lots of planets have a " + CompassPoint.north.rawValue)
            fallthrough
        case .south:
            print("Watch out for penguins")
        case .east:
            print("Where the sun rises")
//        case .west:
//            print("Where the skies are blue")
        default:
            print("Not a safe place for humans")
        }
    }
    
    private func _guard() {
        let temp = 0
        guard temp != 0 else {
            print("zero checked.")
            return
        }
        print("After guard.")
    }
    
    private func _inout(num: inout Int) {
        num *= 2
    }
    
    private func _var() {
        var 🐶🐮 = "dogcow";
        🐶🐮 = "cowdog"
        print(🐶🐮)
        let 💩 = "shit"
        print(💩)
    }
    
    private func _lazy () {
//        print(self.calculatedValue)
        
        let array = Array(0..<10)
        let incArray = array.lazy.map{(item) -> Int in
            print("Calculating..")
            return item + 1
        }
        print(incArray[0], incArray[8])
    }
    
    private func _closures() {
        
    }
    
    // MARK: 析构
    deinit {
        print(String(format: "%@ dealloced.", String(describing: self)))
    }
}

extension MyOCFunction {
    private static var _temp = 0
    var fact: Int {
        get {
            return MyOCFunction._temp
        }
        set {
            MyOCFunction._temp = newValue
        }
    }
    convenience init(temp: Int) {
        self.init()
        self.fact = temp
    }
}
