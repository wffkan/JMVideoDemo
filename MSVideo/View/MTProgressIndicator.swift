//
//  ProgressIndicator.swift
//  MSVideo
//
//  Created by MoliySDev on 2022/4/27.
//

import UIKit


class MTProgressIndicator: UIView {
    
    private lazy var bgLine: UIView = {
        let view = UIView(bgColor: UIColor(hex: "#4F4F4F"))
        return view
    }()
    
    private lazy var progressLine: UIView = {
        let view = UIView(bgColor: UIColor.white.withAlphaComponent(0.8))
        view.frame = CGRect(x: 0, y: 0, width: 0, height: 2)
        return view
    }()
    
    private lazy var dotView: UIView = {
        let view = UIView(bgColor: .white)
        view.frame = CGRect(x: 0, y: -2, width: 6, height: 6)
        view.layer.cornerRadius = 3
        return view
    }()
    
    private(set) var progress: Float = 0
    
    //0.正常模式 1.放大模式
    var progressType: Int = 0 {
        didSet {
            if self.progressType == 0 {
                self.snp.updateConstraints { make in
                    make.height.equalTo(2)
                }
                UIView.animate(withDuration: 0.25) {
                    self.superview?.layoutIfNeeded()
                    self.progressLine.height = 2
                    self.progressLine.layer.cornerRadius = 0
                    self.dotView.width = 6
                    self.dotView.height = 6
                    self.dotView.center = CGPoint(x: self.progressLine.right, y: self.progressLine.centerY)
                }
            }else {
                self.snp.updateConstraints { make in
                    make.height.equalTo(10)
                }
                UIView.animate(withDuration: 0.25) {
                    self.superview?.layoutIfNeeded()
                    self.progressLine.height = 10
                    self.progressLine.layer.cornerRadius = 5
                    self.dotView.width = 12
                    self.dotView.height = 20
                    self.dotView.center = CGPoint(x: self.progressLine.right, y: self.progressLine.centerY)
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bgLine)
        bgLine.addSubview(progressLine)
        bgLine.addSubview(dotView)
    }
    
    func updateProgess(progress: Float,animated: Bool = true) {
//        if animated {
//            UIView.animate(withDuration: 0.8) {
//                self.progressLine.width = self.width * CGFloat(self.progress)
//            } completion: { _ in
//                self.progress = progress
//            }
//        }else {
            self.progressLine.width = self.width * CGFloat(progress)
            self.dotView.center = CGPoint(x: self.progressLine.right, y: self.progressLine.centerY)
            self.progress = progress
//        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.bgLine.frame = self.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
