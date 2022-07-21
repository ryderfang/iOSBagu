//
//  RYTabBarController.swift
//  UIKitBagu
//
//  Created by ryfang on 2022/7/18.
//  Copyright © 2022 Ryder. All rights reserved.
//

import UIKit

@objcMembers
class RYTabBarController: UITabBarController {

    init() {
        super.init(nibName: nil, bundle: nil)

        // colors
        self.tabBar.backgroundColor = UIColor.black
        self.tabBar.tintColor = UIColor.yellow
        self.tabBar.unselectedItemTintColor = UIColor.white

        let mainVC: UIViewController = MainViewController()
        mainVC.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 0)
        let swuiVC: UIViewController = SWUIViewController()
        swuiVC.tabBarItem = UITabBarItem(tabBarSystemItem: .mostRecent, tag: 1)
        let ukVC : UIViewController = UKViewController()
        ukVC.tabBarItem = UITabBarItem(tabBarSystemItem: .mostViewed, tag: 2)
        let tabs = [mainVC, swuiVC, ukVC]
        self.setViewControllers(tabs, animated: false)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.green
    }
}
