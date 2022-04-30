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
    }
    
    func createTimer() {
        let timer = OCTimer();
        timer.start();
    }
}

