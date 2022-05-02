//
//  SWTemp.swift
//  ObjcBagu
//
//  Created by Ryder Fang on 2022/4/21.
//  Copyright © 2022 Ryder. All rights reserved.
//

import Foundation
import SwiftBagu

class SWTemp : NSObject {
    @objc func hello() {
        print("Hello, Swift!")
        
//        self.createTimer();
        
        let interface = SBGInterface()
        interface.testClosures()
    }
    
    func createTimer() {
        let timer = OCTimer();
        timer.start();
    }
}

class MyInterface : SBGInterface {
    // Instance method overrides a 'final' instance method
//    override func testKeyWords() {
//        
//    }
    
    override func testTimer() {
        super.testTimer()
    }
}

// Cannot inherit from non-open class 'SBGStringFormatter' outside of its defining module
//class MyStringFormatter: SBGStringFormatter {
//
//}
