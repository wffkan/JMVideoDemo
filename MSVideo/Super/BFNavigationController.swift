//
//  BFNavigationController.swift
//  MSIM-Swift
//
//  Created by benny wang on 2021/7/28.
//

import UIKit

class BFNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
        }
        navigationBar.tintColor = UIColor.d_color(light: .darkText, dark: .lightText)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if viewControllers.count != 0 {
            viewController.hidesBottomBarWhenPushed = true
            tabBarController?.tabBar.isHidden = true
        }
        super.pushViewController(viewController, animated: animated)
    }
}
