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
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let toVC = transitionContext.viewController(forKey: .to)
  
        let container = transitionContext.containerView
        container.addSubview(toVC!.view)
        toVC?.view.frame = CGRect(x: UIScreen.width, y: 0, width: UIScreen.width, height: UIScreen.height)
        let duration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: .curveEaseOut) {
            toVC?.view.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: UIScreen.height)
        } completion: { _ in
            transitionContext.finishInteractiveTransition()
            transitionContext.completeTransition(true)
        }

    }
    
}
