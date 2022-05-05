//
//  MSFpsLabel.swift
//  MSVideo
//
//  Created by MoliySDev on 2022/5/5.
//

import UIKit

class FPSLabel: UILabel {

    fileprivate var displayLink: CADisplayLink?
    fileprivate var lastTime: TimeInterval = 0
    fileprivate var count: Int = 0
    
    deinit {
        displayLink?.invalidate()
    }
    
    override func didMoveToSuperview() {
        frame = CGRect(x: UIScreen.width - 30 - 20, y: 150, width: 30, height: 30)
        layer.cornerRadius = 15
        clipsToBounds = true
        backgroundColor = UIColor.black
        textColor = UIColor.green
        textAlignment = .center
        font = UIFont.systemFont(ofSize: 18)
        run()
    }
    
    func run() {
        displayLink = CADisplayLink(target: self, selector: #selector(tick))
        displayLink?.add(to: .current, forMode: .common)
    }
    
    @objc func tick(_ displayLink: CADisplayLink) {
        if lastTime == 0 {
            lastTime = displayLink.timestamp
            return
        }
        
        count += 1
        let timeDelta = displayLink.timestamp - lastTime
        if timeDelta < 0.25 {
            return
        }
        
        lastTime = displayLink.timestamp
        let fps: Double = Double(count) / timeDelta
        count = 0
        text = String(format: "%.0f", fps)
        textColor = fps > 50 ? UIColor.green : UIColor.red
    }

}
