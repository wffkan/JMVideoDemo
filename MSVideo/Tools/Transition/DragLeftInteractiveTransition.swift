//
//  DragLeftInteractiveTransition.swift
//  MSVideo
//
//  Created by 王方芳 on 2022/4/28.
//

import UIKit

class DragLeftInteractiveTransition: UIPercentDrivenInteractiveTransition {
    
    /** 是否正在拖动返回 标识是否正在使用转场的交互中 */
    var isInteracting: Bool = false
    
    /** 设置需要返回的VC*/
    func wireToViewController(vc: UIViewController) {
        self.presentingVC = vc
        self.viewControllerCenter = vc.view.center
        self.prepareGestureRecognizerInView(view: vc.view)
    }
    
    weak private var presentingVC: UIViewController?
    
    private var viewControllerCenter: CGPoint = .zero
    
    private var transitionMaskLayer: CALayer?
    
    override var completionSpeed: CGFloat {
        get {
            return 1 - self.percentComplete
        }
        set {
        }
    }
    
    override func update(_ percentComplete: CGFloat) {
        print(percentComplete)
    }
    
    override func cancel() {
        print("转场取消")
    }
    
    override func finish() {
        print("转场完成")
    }
    
    private func prepareGestureRecognizerInView(view: UIView) {
        let ges = UIPanGestureRecognizer(target: self, action: #selector(handleGesture))
        view.addGestureRecognizer(ges)
    }
    
    @objc private func handleGesture(ges: UIPanGestureRecognizer) {
        
        let view = ges.view!
        let translation = ges.translation(in: view.superview)
        if !self.isInteracting && (translation.x < 0 || translation.y < 0 || translation.x < translation.y) {
            return
        }
        switch ges.state {
        case .began:
            //修复当从右侧向左滑动的时候的bug 避免开始的时候从又向左滑动 当未开始的时候
            let vel = ges.velocity(in: ges.view)
            if !self.isInteracting && vel.x < 0 {
                self.isInteracting = false
                return
            }
            self.transitionMaskLayer = CALayer()
            self.transitionMaskLayer?.frame = view.frame
            self.transitionMaskLayer?.isOpaque = false
            self.transitionMaskLayer?.opacity = 1
            self.transitionMaskLayer?.backgroundColor = UIColor.white.cgColor
            self.transitionMaskLayer?.setNeedsDisplay()
            self.transitionMaskLayer?.displayIfNeeded()
            self.transitionMaskLayer?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            self.transitionMaskLayer?.position = CGPoint(x: view.width * 0.5, y: view.height * 0.5)
            view.layer.mask = self.transitionMaskLayer
            view.layer.cornerRadius = 16
            view.layer.masksToBounds = true
            
            self.isInteracting = true
            
        case .changed:
            var progress = translation.x / UIScreen.width
            progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
            
            let ratio = 1.0 - progress * 0.5
            presentingVC?.view.center = CGPoint(x: viewControllerCenter.x + translation.x * ratio, y: viewControllerCenter.y + translation.y * ratio)
            presentingVC?.view.transform = CGAffineTransform(scaleX: ratio, y: ratio)
            self.update(progress)
        case .cancelled,.ended:
            var progress = translation.x / UIScreen.width
            progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
            if progress < 0.2 {
                UIView.animate(withDuration: progress, delay: 0, options: .curveEaseOut) {
                    self.presentingVC?.view.center = CGPoint(x: UIScreen.width * 0.5, y: UIScreen.height * 0.5)
                    self.presentingVC?.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                } completion: { _ in
                    self.isInteracting = false
                    self.cancel()
                }
            }else {
                self.isInteracting = false
                self.finish()
                self.presentingVC?.dismiss(animated: true, completion: nil)
            }
            self.transitionMaskLayer?.removeFromSuperlayer()
            self.transitionMaskLayer = nil
        default:
            break
        }
    }
    
}
