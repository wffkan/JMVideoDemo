//
//  DismissScaleAnimation.swift
//  MSVideo
//
//  Created by 王方芳 on 2022/4/28.
//

import UIKit


class DismissScaleAnimation: NSObject,UIViewControllerAnimatedTransitioning {
    
    
    private let centerFrame = CGRect(x: UIScreen.width * 0.5, y: UIScreen.height * 0.5, width: 0, height: 0)
    
    var endFrame: CGRect = .zero
    
    var endView: UIView? {
        willSet {
            endView?.alpha = 1
            if let view = newValue {
                self.snapShotView = view.snapshotView(afterScreenUpdates: false)
            }
        }
    }
    
    private var snapShotView: UIView?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        
        var scaleRatio: CGFloat = 0
        var finalFrame: CGRect = self.endFrame
        
        if self.endView != nil && finalFrame.equalTo(.zero) == false {
            if snapShotView == nil {
                snapShotView = endView!.snapshotView(afterScreenUpdates: false)
            }
            scaleRatio = fromVC.view.frame.size.width / self.endView!.width
            snapShotView!.layer.zPosition = 20
        }else {
            snapShotView = fromVC.view.snapshotView(afterScreenUpdates: false)
            scaleRatio = fromVC.view.width / UIScreen.width
            finalFrame = centerFrame
        }
        let containerView = transitionContext.containerView
        containerView.addSubview(snapShotView!)
        
        let duration = self.transitionDuration(using: transitionContext)
        fromVC.view.alpha = 0.0
        snapShotView!.center = fromVC.view.center
        snapShotView!.transform = CGAffineTransform(scaleX: scaleRatio, y: scaleRatio)
        endView?.alpha = 0
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: .curveEaseInOut) {
            
            self.snapShotView!.transform = .identity
            self.snapShotView!.frame = finalFrame
            
        } completion: {_ in
            transitionContext.finishInteractiveTransition()
            transitionContext.completeTransition(true)
            self.snapShotView!.removeFromSuperview()
            self.endView?.alpha = 1
        }
    }
}
