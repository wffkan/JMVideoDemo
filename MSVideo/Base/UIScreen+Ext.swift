//
//  UIScreen+Ext.swift
//  MSIM-Swift
//
//  Created by benny wang on 2021/7/28.
//

import UIKit

public extension UIScreen {
    
    // 是否横屏
    static var isHorizontal: Bool {
        return UIScreen.main.bounds.width > UIScreen.main.bounds.height
    }
    static var width: CGFloat {
        return UIScreen.main.bounds.width
    }
    static var height: CGFloat {
        return UIScreen.main.bounds.height
    }
    static let minSide: CGFloat = min(UIScreen.width, UIScreen.height)
    static let maxSide: CGFloat = max(UIScreen.width, UIScreen.height)
    static let size: CGSize = UIScreen.main.bounds.size
    static let statusbarHeight: CGFloat = UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.size.height ?? 0
    static let safeAreaTopHeight: CGFloat = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
    static let safeAreaBottomHeight: CGFloat = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
    static let navBarHeight: CGFloat = 44.0
    static let tabBarHeight: CGFloat = 49.0
    static let status_navi_height: CGFloat = UIScreen.statusbarHeight + UIScreen.navBarHeight
    static let isIphoneX: Bool = (UIApplication.shared.windows.first?.safeAreaInsets.bottom == 34 || UIApplication.shared.windows.first?.safeAreaInsets.bottom == 21)
    static let scaleW: CGFloat = UIScreen.main.bounds.width / 375
    static let scaleH: CGFloat = UIScreen.main.bounds.height / 667
}
