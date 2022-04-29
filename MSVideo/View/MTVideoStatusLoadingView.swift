//
//  MTVideoStatusLoadingView.swift
//  MSVideo
//
//  Created by MoliySDev on 2022/4/29.
//

import UIKit



class MTVideoStatusLoadingView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
    }
    
    func startLoadingPlayItemAnim(_ isStart:Bool = true) {
        if isStart {
            self.backgroundColor = ColorWhite
            self.isHidden = false
            self.layer.removeAllAnimations()
            
            let animationGroup = CAAnimationGroup.init()
            animationGroup.duration = 0.5
            animationGroup.beginTime = CACurrentMediaTime()
            animationGroup.repeatCount = .infinity
            animationGroup.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
            
            let scaleAnim = CABasicAnimation.init()
            scaleAnim.keyPath = "transform.scale.x"
            scaleAnim.fromValue = 1.0
            scaleAnim.toValue = 1.0 * UIScreen.width
            
            let alphaAnim = CABasicAnimation.init()
            alphaAnim.keyPath = "opacity"
            alphaAnim.fromValue = 1.0
            alphaAnim.toValue = 0.2
            
            animationGroup.animations = [scaleAnim, alphaAnim]
            self.layer.add(animationGroup, forKey: nil)
        } else {
            self.layer.removeAllAnimations()
            self.isHidden = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
