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
    
    var playView: UIView?
    
    private var snapShotView: UIView?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        
        var finalFrame: CGRect = self.endFrame
        
        if self.endView == nil || finalFrame.equalTo(.zero){
            finalFrame = centerFrame
        }
        let containerView = transitionContext.containerView
        if playView != nil {
            playView?.isHidden = false
            playView?.frame.origin = fromVC.view.frame.origin
            containerView.addSubview(playView!)
        }else {
            snapShotView?.frame = fromVC.view.frame
            containerView.addSubview(snapShotView!)
        }
        let duration = self.transitionDuration(using: transitionContext)
        endView?.alpha = 0
        fromVC.view.alpha = 0
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: .curveEaseInOut) {
            
            self.playView?.frame = finalFrame
            self.snapShotView?.frame = finalFrame
        } completion: {_ in
            transitionContext.finishInteractiveTransition()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            self.playView?.removeFromSuperview()
            self.snapShotView?.removeFromSuperview()
            self.endView?.alpha = 1
        }
    }
}
