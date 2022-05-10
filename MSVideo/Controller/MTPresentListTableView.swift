//
//  MTPresentListTableView.swift
//  MSVideo
//
//  Created by 王方芳 on 2022/5/10.
//

import UIKit


class MTPresentListTableView: UITableView {
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) {
            let pan = gestureRecognizer as! UIPanGestureRecognizer
            let contentOffset = self.contentOffset
            let velocity = pan.velocity(in: pan.view)
            if contentOffset.y == -self.contentInset.top {
                if velocity.y > 0 {
                    return false
                }
            }
        }
        
        return true
    }
    
}
