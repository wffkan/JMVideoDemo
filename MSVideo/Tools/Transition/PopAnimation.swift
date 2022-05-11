//
//  PopAnimation.swift
//  MSVideo
//
//  Created by 王方芳 on 2022/5/11.
//

import UIKit


class PopAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromVC = transitionContext.viewController(forKey: .from)
        let duration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: .curveEaseOut) {
            fromVC?.view.frame = CGRect(x: 0, y: UIScreen.width, width: UIScreen.width, height: UIScreen.height)
        } completion: { _ in
            transitionContext.finishInteractiveTransition()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

