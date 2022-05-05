//
//  DismissScaleAnimation.swift
//  MSVideo
//
//  Created by 王方芳 on 2022/4/28.
//

import UIKit


class DismissScaleAnimation: NSObject,UIViewControllerAnimatedTransitioning {
    
    
    private let centerFrame = CGRect(x: (UIScreen.width - 5) * 0.5, y: (UIScreen.height - 5) * 0.5, width: 5, height: 5)
    
    var endFrame: CGRect = .zero
    
    var endView: UIView?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        
        var snapshotView: UIView!
        var scaleRatio: CGFloat = 0
        var finalFrame: CGRect = self.endFrame
        
        if self.endView != nil && finalFrame.equalTo(.zero) == false {
            snapshotView = endView!.snapshotView(afterScreenUpdates: false)
            scaleRatio = fromVC.view.frame.size.width / self.endView!.width
            snapshotView.layer.zPosition = 20
        }else {
            snapshotView = fromVC.view.snapshotView(afterScreenUpdates: false)
            scaleRatio = fromVC.view.width / UIScreen.width
            finalFrame = centerFrame
        }
        let containerView = transitionContext.containerView
        containerView.addSubview(snapshotView)
        
        let duration = self.transitionDuration(using: transitionContext)
        fromVC.view.alpha = 0.0
        snapshotView.center = fromVC.view.center
        snapshotView.transform = CGAffineTransform(scaleX: scaleRatio, y: scaleRatio)
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: .curveEaseInOut) {
            
            snapshotView.transform = .identity
            snapshotView.frame = finalFrame
        } completion: {_ in
            transitionContext.finishInteractiveTransition()
            transitionContext.completeTransition(true)
            snapshotView.removeFromSuperview()
        }
    }
}
