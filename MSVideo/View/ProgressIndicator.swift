//
//  ProgressIndicator.swift
//  MSVideo
//
//  Created by MoliySDev on 2022/4/27.
//

import UIKit


class ProgressIndicator: UIView {
    
    private lazy var bgLine: UIView = {
        let view = UIView(bgColor: UIColor.white.withAlphaComponent(0.3))
        return view
    }()
    
    private lazy var progressLine: UIView = {
        let view = UIView(bgColor: UIColor.white.withAlphaComponent(0.6))
        view.frame = CGRect(x: 0, y: 0, width: 0, height: 2)
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
                    self.progressLine.backgroundColor = UIColor.white.withAlphaComponent(0.6)
                    self.progressLine.height = 2
                    self.progressLine.layer.cornerRadius = 0
                }
            }else {
                self.snp.updateConstraints { make in
                    make.height.equalTo(8)
                }
                UIView.animate(withDuration: 0.25) {
                    self.superview?.layoutIfNeeded()
                    self.progressLine.backgroundColor = .white
                    self.progressLine.height = 8
                    self.progressLine.layer.cornerRadius = 4
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bgLine)
        bgLine.addSubview(progressLine)
    }
    
    func updateProgess(progress: Float,animated: Bool = true) {
//        if animated {
//            UIView.animate(withDuration: 0.8) {
//                self.progressLine.width = self.width * CGFloat(self.progress)
//            } completion: { _ in
//                self.progress = progress
//            }
//        }else {
            self.progressLine.width = self.width * CGFloat(self.progress)
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
