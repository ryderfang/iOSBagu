//
//  ImgExt.swift
//  UIKitBagu
//
//  Created by ryfang on 2022/7/21.
//  Copyright © 2022 Ryder. All rights reserved.
//

import SwiftUI

struct CircleImage: View {
    var image: Image

    var body: some View {
        image
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 4))
            .shadow(radius: 10)
    }
}
