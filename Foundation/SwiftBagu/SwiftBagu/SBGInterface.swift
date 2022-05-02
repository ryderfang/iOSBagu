//
//  SBGInterface.swift
//  SwiftBagu
//
//  Created by Ryder Fang on 2022/4/30.
//

import Foundation

open class SBGInterface {
    public init() {
        
    }
    
    final public func testKeyWords() {
        let foo =  SBGKWords()
        foo.defaultValue = 2.0
        foo.hello()
    }
    
    public func testClosures() {
        let foo = SBGClosures()
        foo.hello()
    }
    
    open func testTimer() {
        
    }
}
