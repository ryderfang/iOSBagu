//
//  SwiftUIViewFactory.swift
//  UIKitBagu
//
//  Created by ryfang on 2022/7/14.
//  Copyright © 2022 Ryder. All rights reserved.
//

import UIKit
import SwiftUI

@objcMembers
class SwiftUIViewFactory : NSObject {
    public static func createSimpleView() -> UIViewController {
        let spView = SimpleView()
        return UIHostingController(rootView: spView)
    }
}


