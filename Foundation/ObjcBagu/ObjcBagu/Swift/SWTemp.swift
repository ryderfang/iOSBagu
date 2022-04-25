//
//  SWTemp.swift
//  ObjcBagu
//
//  Created by Ryder Fang on 2022/4/21.
//  Copyright © 2022 Ryder. All rights reserved.
//

import Foundation

class SWTemp : NSObject {
    @objc func hello() {
        print("Hello, Swift!")
        
//        self.createTimer();
        self.testVariable();
    }
    
    func testVariable () {
        var a : Int? = nil
        if (a != nil) {
            
        }
    }
    
    
    func createTimer() {
        let timer = OCTimer();
        timer.start();
    }
}

