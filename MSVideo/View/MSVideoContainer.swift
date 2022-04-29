//
//  MSVideoContainer.swift
//  MSVideo
//
//  Created by MoliySDev on 2022/4/27.
//

import UIKit

protocol MSVideoContainerDelegate: NSObjectProtocol {
    
    func containerTapGestureHandler(ges: UITapGestureRecognizer)
    
    func containerLongGestureHandler(ges: UILongPressGestureRecognizer)
    
    func containerPanGestureHandler(ges: UIPanGestureRecognizer)
}

class MSVideoContainer: UIView,UIGestureRecognizerDelegate {
    
    weak var delegate: MSVideoContainerDelegate?
    
    private var singleTapGesture: UITapGestureRecognizer!
    
    private var longPressGesture: UILongPressGestureRecognizer!
    
    private var panGesture: UIPanGestureRecognizer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        singleTapGesture.delegate = self
        addGestureRecognizer(singleTapGesture)
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 0.3
        longPressGesture.delegate = self
        addGestureRecognizer(longPressGesture)
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        panGesture.delegate = self
        addGestureRecognizer(panGesture)
    }
    
    @objc func handleTapGesture(ges: UITapGestureRecognizer) {
        delegate?.containerTapGestureHandler(ges: ges)
    }
    
    @objc func handleLongPress(ges: UILongPressGestureRecognizer) {
        delegate?.containerLongGestureHandler(ges: ges)
    }
    
    @objc func handlePanGesture(ges: UIPanGestureRecognizer) {
        delegate?.containerPanGestureHandler(ges: ges)
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {

        let startPoint = gestureRecognizer.location(in: gestureRecognizer.view)
        if gestureRecognizer === self.panGesture {
            //如果拖动的区域在进度条周边范围内，放大进度条利于用户拖动
            if startPoint.y > self.bottom - UIScreen.safeAreaBottomHeight - 30 + 25 || startPoint.y < self.bottom - UIScreen.safeAreaBottomHeight - 30 - 2 - 25 {
                return false
            }
        }
        return true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
