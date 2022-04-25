//
//  UIColor+Ext.swift
//  MSIM-Swift
//
//  Created by benny wang on 2021/7/28.
//

import UIKit

public extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) {
        assert(r >= 0 && r <= 255, "Invalid red component")
        assert(g >= 0 && g <= 255, "Invalid green component")
        assert(b >= 0 && b <= 255, "Invalid blue component")
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: alpha)
    }

    convenience init(r: Int, g: Int, b: Int, alpha: CGFloat = 1.0) {
        assert(r >= 0 && r <= 255, "Invalid red component")
        assert(g >= 0 && g <= 255, "Invalid green component")
        assert(b >= 0 && b <= 255, "Invalid blue component")
        self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: alpha)
    }

    convenience init(hex: String) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0, blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: 1.0)
    }

    func alphaComponent(alpha: CGFloat) {
        self.withAlphaComponent(alpha)
    }
    
    class func radomColor() -> UIColor {
        return UIColor(r: Int(arc4random_uniform(256)), g: Int(arc4random_uniform(256)), b: Int(arc4random_uniform(256)))
    }
    
    class func d_color(light: UIColor, dark: UIColor) -> UIColor {
        
        return UIColor { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return dark
            }else {
                return light
            }
        };
    }
}
