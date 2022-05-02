//
//  SBGClosures.swift
//  SwiftBagu
//
//  Created by Ryder Fang on 2022/5/2.
//

import Foundation

class SBGClosures {
    var handler : ((Float) -> Void)?
    var defaultHandler : () -> Void = {
        print("Hello Closures.")
    }
    
    init() {
        self.defaultHandler()
        self.handler = {
            arg in
            print(arg)
        }
        
//        self.handler?(2.0)
    }
    
    func hello() {
        let handler : (Float) -> Void = {
            (_ arg: Float) -> Void in
            print(arg)
        }
        
        let handler2 : (Float) -> Void = {
            arg in
            print(arg)
        }
        
        // Optional Closure
        typealias CompletionHandler = ((Float) -> Int)?
        
        var completion : CompletionHandler = {
            Int($0) * 2
        }
//        if let handler = completion {
//            print(handler(1.0))
//        }
        print(completion?(1.0))
       
//        self.methodA {
//            print(2.0)
//        }
//
//        self.methodB {
//            print($0)
//        }
//
//        self.methodC(closure: { a in
//            print(a)
//        }, arg: 0)
    }
    
    func methodA(closure: () -> Void) {
        closure()
    }
    
    typealias ParamClosure = ((_ a : Float, _ b : String) -> Void)
    
    func methodB(closure: ParamClosure) {
        closure(1.0, "Hello")
    }
    
    func methodC(closure: (_ a : Float) -> Void, arg: Int) {
        closure(3.0)
    }
}
