//
//  SimpleView.swift
//  UIKitBagu
//
//  Created by Ryder Fang on 2022/7/5.
//  Copyright © 2022 Ryder. All rights reserved.
//

import Foundation
import SwiftUI

struct SimpleView : View {
    var body: some View {
        VStack {
            Text("Hello, World!").font(.title)
            Text("Glad to meet you.")
        }
    }
}

struct SimpleView_Preview : PreviewProvider {
    static var previews: some View {
        SimpleView().background(Color.red)
    }
}
