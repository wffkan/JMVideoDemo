//
//  FocusView.swift
//  Douyin
//
//  Created by Qiao Shi on 2018/8/7.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

import Foundation
import UIKit


class MTFocusView: UIImageView {
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
        initSubView()
    }
                   
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubView()
    }
    
    func initSubView() {
        self.layer.cornerRadius = frame.size.width/2
        self.layer.backgroundColor = UIColor(hex: "#0EA9B0").cgColor
        self.image = UIImage(named: "personal_add_focus")
        self.contentMode = .center
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(beginAnimation)))
    }
    
    @objc func beginAnimation() {
        UIDevice.impactFeedback()
        let animationGroup = CAAnimationGroup.init()
        animationGroup.delegate = self
        animationGroup.duration = 1.25
        animationGroup.isRemovedOnCompletion = false
        animationGroup.fillMode = CAMediaTimingFillMode.forwards
        animationGroup.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        let scaleAnim = CAKeyframeAnimation.init(keyPath: "transform.scale")
        scaleAnim.values = [1.0, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 0.0]
        let rotationAnim = CAKeyframeAnimation.init(keyPath: "transform.rotation")
        rotationAnim.values = [-1.5 * .pi, 0.0, 0.0, 0.0]
        
        let opacityAnim = CAKeyframeAnimation.init(keyPath: "opacity")
        opacityAnim.values = [0.8, 1.0, 1.0]
        
        animationGroup.animations = [scaleAnim, rotationAnim, opacityAnim]
        self.layer.add(animationGroup, forKey: nil)
    }
    
    func resetView() {
        self.layer.backgroundColor = UIColor(hex: "#0EA9B0").cgColor
        self.image = UIImage(named: "personal_add_focus")
        self.layer.removeAllAnimations()
        self.isHidden = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MTFocusView: CAAnimationDelegate {
    
    func animationDidStart(_ anim: CAAnimation) {
        self.isUserInteractionEnabled = false
        self.contentMode = .scaleToFill
        self.layer.backgroundColor = UIColor(hex: "#BFBFBF").cgColor
        self.image = UIImage(named: "personal_add_focus_sel")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.isUserInteractionEnabled = true
        self.contentMode = .center
        self.isHidden = true
    }
}
