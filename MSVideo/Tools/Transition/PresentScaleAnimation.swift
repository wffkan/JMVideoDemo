//
//  PresentScaleAnimation.swift
//  MSVideo
//
//  Created by 王方芳 on 2022/4/28.
//

import UIKit


class PresentScaleAnimation: NSObject,UIViewControllerAnimatedTransitioning {
    
    //动画起始坐标
    var startFrame: CGRect = .zero
    
    var startView: UIView?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        if startFrame.equalTo(.zero) {
            transitionContext.completeTransition(true)
            return
        }
        let initialFrame = startFrame
        let containerView = transitionContext.containerView
        containerView.addSubview(toVC!.view)
        let finalFrame = transitionContext.finalFrame(for: toVC!)
        let duration = self.transitionDuration(using: transitionContext)
        startView?.alpha = 1.0
        toVC?.view.center = CGPoint(x: initialFrame.origin.x + initialFrame.size.width * 0.5, y: initialFrame.origin.y + initialFrame.size.height * 0.5)
        toVC?.view.transform = CGAffineTransform(scaleX: initialFrame.size.width / finalFrame.size.width, y: initialFrame.size.height / finalFrame.size.height)
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .layoutSubviews) {
            toVC?.view.center = CGPoint(x: finalFrame.origin.x + finalFrame.size.width * 0.5, y: finalFrame.origin.y + finalFrame.size.height * 0.5)
            toVC?.view.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.startView?.alpha = 0.0
        } completion: { _ in
            transitionContext.completeTransition(true)
        }
    }
}
