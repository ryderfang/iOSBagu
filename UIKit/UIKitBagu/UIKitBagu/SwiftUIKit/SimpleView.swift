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
    var name: String
    @State private var width: CGFloat?
    private static let cornerRadiusMultiplier = 0.2

    init(name: String = "turtlerock") {
        self.name = name
    }

    var body: some View {
        VStack {
            Image(name)
                .resizable()
                .readSize { width = $0.width }
                .clipShape(
                    RoundedRectangle(cornerRadius: width.map {
                        $0 * Self.cornerRadiusMultiplier
                    } ?? 0, style: .continuous)
                )
            Spacer().frame(height: 30)
            CircleImage(image: Image("turtlerock"))
            Text("Hello, World!").font(.title)
            Text("Glad to meet you.")
        }
    }
}

struct SimpleView_Preview : PreviewProvider {
    static var previews: some View {
        SimpleView().background(Color.white)
    }
}
