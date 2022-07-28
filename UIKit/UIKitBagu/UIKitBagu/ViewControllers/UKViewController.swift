//
//  UKViewController.swift
//  UIKitBagu
//
//  Created by ryfang on 2022/7/21.
//  Copyright © 2022 Ryder. All rights reserved.
//

import UIKit
import SnapKit

class UKViewController : UIViewController {
    let helloLabel : UILabel = {
        let label = UILabel()
        label.text = "Hello, Core Animation!"
        label.font = .systemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = true
        return label
    }()

    let aniButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .green
        button.setTitle("Start", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        return button
    }()

    let loadingView : ProgressView = {
        let progress = ProgressView(colors: [UIColor(hex: 0x4369f6)!, UIColor.red, UIColor.yellow, UIColor.blue], lineWidth: 5)
        progress.translatesAutoresizingMaskIntoConstraints = true
        return progress
    }()

    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.white
        setupUI()
    }

    private func setupUI() {
        view.addSubview(helloLabel)
        view.addSubview(loadingView)
        view.addSubview(aniButton)
        helloLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        loadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(loadingView.snp.width)
        }
        aniButton.snp.makeConstraints { make in
            make.top.equalTo(helloLabel.snp.top).offset(80)
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(30)
        }
    }

    @objc func buttonClicked() {
        helloLabel.isHidden = true
        loadingView.isAnimating = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
            self.loadingView.isAnimating = false
            self.helloLabel.isHidden = false
        }
    }
}
