//
//  DragLeftInteractiveTransition.swift
//  MSVideo
//
//  Created by 王方芳 on 2022/4/28.
//

import UIKit

class DragInteractiveTransition: UIPercentDrivenInteractiveTransition {
    
    var isDismissInteracting: Bool = false
    
    var isPushInteracting: Bool = false
    
    /** 设置需要返回的VC*/
    func wireToViewController(vc: UIViewController) {
        self.parentVC = vc
        self.viewControllerCenter = vc.view.center
        self.prepareGestureRecognizerInView(view: vc.view)
    }
    
    var dragDismissEnable: Bool = true
    
    var dragPushEnable: Bool = false
    
    var pushVCType: UIViewController.Type?
    
    private var pushToVC: UIViewController?
    
    weak private var parentVC: UIViewController?
    
    private var viewControllerCenter: CGPoint = .zero
    
    private var transitionMaskLayer: CALayer?
    
    override var completionSpeed: CGFloat {
        get {
            return 1 - self.percentComplete
        }
        set {
        }
    }
    
    private func prepareGestureRecognizerInView(view: UIView) {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handleGesture))
        view.addGestureRecognizer(pan)
    }
    
    @objc private func handleGesture(ges: UIPanGestureRecognizer) {
        
        let velocity = ges.velocity(in: ges.view)
        if ges.state == .began {
            if velocity.x > 0 {//右滑dismiss
                if self.dragDismissEnable {
                    self.dragDismiss(ges: ges)
                }
            }else {
                if self.dragPushEnable {
                    self.dragPush(ges: ges)
                }
            }
        }else {
            if self.isDismissInteracting {
                self.dragDismiss(ges: ges)
            }else if self.isPushInteracting{
                self.dragPush(ges: ges)
            }
        }
    }
    
    private func dragDismiss(ges: UIPanGestureRecognizer) {
        let view = ges.view!
        let translation = ges.translation(in: view)
        
        switch ges.state {
                
            case .began:
                if self.isDismissInteracting || translation.x < abs(translation.y) {return}

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
                
                self.isDismissInteracting = true
                
            case .changed:
                if !self.isDismissInteracting {return}
                var progress = translation.x / UIScreen.width
                progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
                
                let ratio = 1.0 - progress * 0.5
                parentVC?.view.center = CGPoint(x: viewControllerCenter.x + translation.x * ratio, y: viewControllerCenter.y + translation.y * ratio)
                parentVC?.view.transform = CGAffineTransform(scaleX: ratio, y: ratio)
                self.update(progress)
            case .cancelled,.ended:
                if !self.isDismissInteracting {return}
                var progress = translation.x / UIScreen.width
                progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
                if progress < 0.2 {
                    UIView.animate(withDuration: progress, delay: 0, options: .curveEaseOut) {
                        self.parentVC?.view.center = CGPoint(x: UIScreen.width * 0.5, y: UIScreen.height * 0.5)
                        self.parentVC?.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    } completion: { _ in
                        self.isDismissInteracting = false
                        self.cancel()
                    }
                }else {
                    self.isDismissInteracting = false
                    self.finish()
                    self.parentVC?.dismiss(animated: true, completion: nil)
                }
                self.transitionMaskLayer?.removeFromSuperlayer()
                self.transitionMaskLayer = nil
            default:
                self.isDismissInteracting = false
                break
        }
    }
    
    private func dragPush(ges: UIPanGestureRecognizer) {
        let view = ges.view!
        let translation = ges.translation(in: view)
        switch ges.state {
            case .began:
                if self.isPushInteracting || abs(translation.x) < abs(translation.y) {return}
                self.isPushInteracting = true
                self.pushToVC = self.pushVCType!.init()
                if let nav = self.parentVC as? UINavigationController {
                    nav.pushViewController(pushToVC!, animated: true)
                }else {
                    self.parentVC?.navigationController?.pushViewController(pushToVC!, animated: true)
                }
            case .changed:
                if !self.isPushInteracting {return}
                var progress = abs(translation.x) / UIScreen.width
                progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
                self.update(progress)
            case .cancelled,.ended:
                if !self.isPushInteracting {return}
                var progress = abs(translation.x) / UIScreen.width
                print("translation.x: \(translation.x)")
                print("progress: \(progress)")
                progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
                
                if progress < 0.2 {
                    self.cancel()
                    self.isPushInteracting = false
                    self.pushToVC = nil
                }else {
                    self.isPushInteracting = false
                    self.finish()
                    self.pushToVC = nil
                }
                
            default:
                self.cancel()
                self.pushToVC?.navigationController?.popViewController(animated: true)
                self.isPushInteracting = false
                self.pushToVC = nil
                
                break
        }
    }
}
