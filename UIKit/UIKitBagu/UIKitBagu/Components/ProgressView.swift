//
//  ProgressView.swift
//  UIKitBagu
//
//  Created by ryfang on 2022/7/28.
//  Copyright © 2022 Ryder. All rights reserved.
//

import UIKit

class ProgressView : UIView {
    let colors: [UIColor]
    let lineWidth: CGFloat

    private lazy var sharpLayer: CAShapeLayer = {
        let layer = CAShapeLayer.init()
        layer.strokeColor = colors.first!.cgColor
        layer.lineWidth = lineWidth
        layer.fillColor = UIColor.clear.cgColor
        layer.lineCap = .round
        return layer
    }()

    var isAnimating: Bool = false {
        didSet {
            if isAnimating {
                doAnimations()
            } else {
                sharpLayer.removeFromSuperlayer()
                layer.removeAllAnimations()
            }
        }
    }

    init(frame: CGRect, colors: [UIColor], lineWidth: CGFloat) {
        self.colors = colors
        self.lineWidth = lineWidth

        super.init(frame: frame)
        self.backgroundColor = .clear
    }

    convenience init(colors: [UIColor], lineWidth: CGFloat) {
        self.init(frame: .zero, colors: colors, lineWidth: lineWidth)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = self.frame.width / 2
//        let path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        let path = UIBezierPath(arcCenter: CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2),
                                radius: self.bounds.width / 2,
                                startAngle: CGFloat.pi * 3 / 2,
                                endAngle: -CGFloat.pi / 2,
                                clockwise: false)
        sharpLayer.path = path.cgPath
    }

    // MARK: animation
    func doAnimations() {
        strokeAnimation()
        colorAnimation()
        rotateAnimation()
    }

    private func strokeAnimation() {
        let start = CABasicAnimation()
        start.keyPath = "strokeStart"
        start.beginTime = 0.25
        start.fromValue = 0.0
        start.toValue = 1.0
        start.duration = 0.75

        let end = CABasicAnimation()
        end.keyPath = "strokeEnd"
        end.fromValue = 0.01
        end.toValue = 1.0
        end.duration = 0.75

        let group = CAAnimationGroup()
        group.duration = 1.0
        group.fillMode = .forwards
        group.repeatCount = .infinity
        group.animations = [start, end]

        sharpLayer.add(group, forKey: nil)
        layer.addSublayer(sharpLayer)
    }

    private func colorAnimation() {
        let colorAni = CAKeyframeAnimation()
        colorAni.keyPath = "strokeColor"
        colorAni.values = colors.map { $0.cgColor }
        colorAni.duration = 1.0 * Double(colors.count)
        colorAni.repeatCount = .greatestFiniteMagnitude
        colorAni.timingFunction = .init(name: .easeInEaseOut)
        sharpLayer.add(colorAni, forKey: nil)
    }

    private func rotateAnimation() {
        let rotate = CABasicAnimation()
        rotate.keyPath = "transform.rotation.z"
        rotate.fromValue = CGFloat.pi * 3 / 2
        rotate.toValue = -CGFloat.pi / 2
        rotate.duration = 2.0
        rotate.repeatCount = .greatestFiniteMagnitude

        layer.add(rotate, forKey: nil)
    }
}
