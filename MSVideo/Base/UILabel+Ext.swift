//
//  UILabel+Ext.swift
//  MSVideo
//
//  Created by MoliySDev on 2022/5/10.
//

import UIKit


extension UILabel {
    
    public func changeLineSpace(space: CGFloat,text: String,lineBreak: NSLineBreakMode = .byTruncatingTail) {
        let attri = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = space
        style.lineBreakMode = lineBreak
        attri.addAttributes([.paragraphStyle: style], range: NSRange(location: 0, length: text.count))
        self.attributedText = attri
        self.sizeToFit()
    }
}
