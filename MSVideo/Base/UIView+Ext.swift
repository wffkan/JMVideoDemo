//
//  UIView+Ext.swift
//  MSIM-Swift
//
//  Created by benny wang on 2021/7/28.
//

import UIKit

public extension UIView {
    
    convenience init(bgColor: UIColor) {
        self.init()
        backgroundColor = bgColor
    }
    
    func asImage() -> UIImage {
        let render = UIGraphicsImageRenderer(bounds: bounds)
        return render.image { renderContext in
            layer.render(in: renderContext.cgContext)
        }
    }
    
    func addRoundCorners(corners: UIRectCorner, radii: CGSize) {
        let path = UIBezierPath.init(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: radii)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        layer.mask = shapeLayer
    }
    
    func addGradientLayer(startColor: UIColor,endColor: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        layer.addSublayer(gradientLayer)
        gradientLayer.startPoint = .zero
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.colors = [startColor.cgColor,endColor.cgColor]
    }
    
    var left: CGFloat {
        get {
            frame.origin.x
        }
        set {
            var n_frame = frame
            n_frame.origin.x = newValue
            frame = n_frame
        }
    }
    
    var right: CGFloat {
        get {
            frame.origin.x + frame.size.width
        }
        set {
            var n_frame = frame
            n_frame.origin.x = newValue - frame.size.width
            frame = n_frame
        }
    }
    
    var width: CGFloat {
        get {
            frame.size.width
        }
        set {
            var n_frame = frame
            n_frame.size.width = newValue
            frame = n_frame
        }
    }
    
    var height: CGFloat {
        get {
            frame.size.height
        }
        set {
            var n_frame = frame
            n_frame.size.height = newValue
            frame = n_frame
        }
    }
    
    var top: CGFloat {
        get {
            frame.origin.y
        }
        set {
            var n_frame = frame
            n_frame.origin.y = newValue
            frame = n_frame
        }
    }
    
    var bottom: CGFloat {
        get {
            frame.origin.y + frame.size.height
        }
        set {
            var n_frame = frame
            n_frame.origin.y = newValue - frame.size.height
            frame = n_frame
        }
    }
    
    var centerX: CGFloat {
        get {
            center.x
        }
        set {
            var n_center = center
            n_center.x = newValue
            center = n_center
        }
    }
    
    var centerY: CGFloat {
        get {
            center.y
        }
        set {
            var n_center = center
            n_center.y = newValue
            center = n_center
        }
    }
}
