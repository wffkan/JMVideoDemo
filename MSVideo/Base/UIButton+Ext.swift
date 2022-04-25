//
//  UIButton.swift
//  MSIM-Swift
//
//  Created by benny wang on 2021/7/28.
//

import UIKit

extension UIButton {
    
    public func verticalImageAndTitle(spacing: CGFloat) {
    
        let imageSize = imageView?.frame.size ?? .zero
        var titleSize = titleLabel?.frame.size ?? .zero
        let textSize = titleLabel?.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)) ?? .zero
        let frameSize = CGSize(width: CGFloat(ceilf(Float(textSize.width))), height: CGFloat(ceilf(Float(textSize.height))))
        if titleSize.width + 0.5 < frameSize.width {
            titleSize.width = frameSize.width
        }
        let totalHeight = imageSize.height + titleSize.height + spacing
        imageEdgeInsets = UIEdgeInsets(top: -(totalHeight - imageSize.height), left: 0, bottom: 0, right: -titleSize.width)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize.width, bottom: -(totalHeight-titleSize.height), right: 0)
    }
}
