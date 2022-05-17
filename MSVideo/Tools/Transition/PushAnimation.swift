//
//  PushAnimation.swift
//  MSVideo
//
//  Created by MoliySDev on 2022/5/11.
//

import Foundation
import UIKit


class PushAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let toView = transitionContext.view(forKey: .to)
        transitionContext.containerView.addSubview(toView!)
        toView?.frame = CGRect(x: UIScreen.width, y: 0, width: UIScreen.width, height: UIScreen.height)
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0, options: .curveEaseOut) {
            toView?.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: UIScreen.height)
        } completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
}
