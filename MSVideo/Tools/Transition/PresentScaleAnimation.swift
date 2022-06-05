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
        guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {return}
        if startFrame.equalTo(.zero) {
            transitionContext.completeTransition(true)
            return
        }
        let initialFrame = startFrame
        let containerView = transitionContext.containerView
        
        let bgMaskView = UIView(bgColor: .black)
        bgMaskView.alpha = 0
        bgMaskView.frame = containerView.bounds
        containerView.addSubview(bgMaskView)
        
        containerView.addSubview(toVC.view)
        
        let finalFrame = transitionContext.finalFrame(for: toVC)
        let duration = self.transitionDuration(using: transitionContext)

        toVC.view.frame = initialFrame

        UIView.animate(withDuration: duration) {
            toVC.view.frame = finalFrame
            bgMaskView.alpha = 1.0
        } completion: { _ in
            self.startView?.alpha = 0.0
            bgMaskView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
