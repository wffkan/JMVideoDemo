//
//  UIImage+Ezt.swift
//  MSIM-Swift
//
//  Created by benny wang on 2021/7/28.
//

import UIKit

public extension UIImage {
    
    class func bf_imageNamed(name: String) -> UIImage? {
        
        let path = Bundle.bf_resourceBundle.bundlePath
        return UIImage(named: "\(path)/\(name)")
    }
    
    class func bf_emoji(name: String) -> UIImage? {
        
        let path = Bundle.bf_emojiBundle.bundlePath
        return UIImage(named: "\(path)/\(name)")
    }
    
    func drawRoundedRectImage(cornerRadius:CGFloat, width:CGFloat, height:CGFloat) -> UIImage? {
        let size = CGSize.init(width: width, height: height)
        let rect = CGRect.init(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        let context = UIGraphicsGetCurrentContext()
        context?.addPath(UIBezierPath.init(roundedRect: rect, cornerRadius: cornerRadius).cgPath)
        context?.clip()
        self.draw(in: rect)
        context?.drawPath(using: .fillStroke)
        let output = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return output
    }
    
    func drawCircleImage() -> UIImage? {
        let side = min(self.size.width, self.size.height)
        let size = CGSize.init(width: side, height: side)
        let rect = CGRect.init(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        let context = UIGraphicsGetCurrentContext()
        context?.addPath(UIBezierPath.init(roundedRect: rect, cornerRadius: side).cgPath)
        context?.clip()
        self.draw(in: rect)
        context?.drawPath(using: .fillStroke)
        let output = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return output
    }
}
