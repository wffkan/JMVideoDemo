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
        
//        if self.responds(to: #selector(getter: interactivePopGestureRecognizer)) {
//            self.interactivePopGestureRecognizer?.delegate = self
//        }
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if viewControllers.count != 0 {
            viewController.hidesBottomBarWhenPushed = true
            tabBarController?.tabBar.isHidden = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    override var childForStatusBarHidden: UIViewController? {
        return self.topViewController
    }

    override var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
}

//extension BFNavigationController: UIGestureRecognizerDelegate {
//    
//    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        if self.viewControllers.count == 1 {
//            return false
//        }
//        return true
//    }
//    
//    //修复有水平方向滚动的ScrollView时边缘返回手势失效的问题
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
//    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return gestureRecognizer.isKind(of: UIScreenEdgePanGestureRecognizer.self)
//    }
//}
