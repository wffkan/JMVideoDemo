//
//  BFTabBarController.swift
//  MSIM-Swift
//
//  Created by benny wang on 2021/7/28.
//

import UIKit



class BFTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }
        
        let homeVC = MSVideoListController()
        homeVC.tabBarItem.title = "Home_tab"
        homeVC.tabBarItem.image = UIImage(named: "home_tab_nor")
        homeVC.tabBarItem.selectedImage = UIImage(named: "home_tab_sel")
        let homeNav = BFNavigationController(rootViewController: homeVC)
        addChild(homeNav)
        
        let tactVC = BFBaseViewController()
        tactVC.tabBarItem.title = "Discovery_tab"
        tactVC.tabBarItem.image = UIImage(named: "contact_normal")
        tactVC.tabBarItem.selectedImage = UIImage(named: "contact_selected")
        let tactNav = BFNavigationController(rootViewController: tactVC)
        addChild(tactNav)
        
        let convVC = BFBaseViewController()
        convVC.tabBarItem.title = "Message_tab"
        convVC.tabBarItem.image = UIImage(named: "session_normal")
        convVC.tabBarItem.selectedImage = UIImage(named: "session_selected")
        let convNav = BFNavigationController(rootViewController: convVC)
        addChild(convNav)
        
        let profileVC = BFBaseViewController()
        profileVC.tabBarItem.title = "Profile_tab"
        profileVC.tabBarItem.image = UIImage(named: "myself_normal")
        profileVC.tabBarItem.selectedImage = UIImage(named: "myself_selected")
        let profileNav = BFNavigationController(rootViewController: profileVC)
        addChild(profileNav)
        
    }
    
    override var childForStatusBarHidden: UIViewController? {
        return self.selectedViewController
    }
    override var childForStatusBarStyle: UIViewController? {
        return self.selectedViewController
    }
}
