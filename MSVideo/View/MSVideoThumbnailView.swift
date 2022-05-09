//
//  MSVideoThumbnailView.swift
//  MSVideo
//
//  Created by MoliySDev on 2022/4/29.
//

import UIKit
import SnapKit
import SwiftUI

class MSVideoThumbnailView: UIView {
    
    lazy var thumbImageView: UIImageView = {
        let imageView = UIImageView(bgColor: .black)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 1
        return imageView
    }()
    
    lazy var currentTimeL: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    lazy var totalTimeL: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textColor = .white.withAlphaComponent(0.6)
        return label
    }()
    
    lazy var indicator: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14,weight: .semibold)
        label.textColor = .white
        label.text = "/"
        return label
    }()
    
    //缩略图办有两种展示方式，竖图和横图
    private var landscape: Bool = false
    
    private let landscapeW: CGFloat = 160
    
    private let potraitW: CGFloat = 90
    
    private let ratio: CGFloat = 16 / 9
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(thumbImageView)
        addSubview(indicator)
        addSubview(currentTimeL)
        addSubview(totalTimeL)
        
        indicator.snp.makeConstraints { make in
            make.width.equalTo(7)
            make.height.equalTo(20)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
        currentTimeL.snp.makeConstraints { make in
            make.right.equalTo(self.indicator.snp.left).offset(-12)
            make.centerY.equalTo(indicator)
        }
        totalTimeL.snp.makeConstraints { make in
            make.left.equalTo(self.indicator.snp.right).offset(12)
            make.centerY.equalTo(indicator)
        }
        thumbImageView.snp.makeConstraints { make in
            make.width.equalTo(0)
            make.height.equalTo(0)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(totalTimeL.top).offset(-20)
            make.top.equalToSuperview()
        }
    }
    
    func update(thumbnail: UIImage?,currentT: Int,totalT: Int) {
        thumbImageView.image = thumbnail
        currentTimeL.text = String.init(format: "%d:%02d", currentT / 1000 / 60,currentT / 1000 % 60)
        totalTimeL.text = String.init(format: "%d:%02d", totalT / 1000 / 60,totalT / 1000 % 60)
        
        if thumbnail == nil {
            thumbImageView.snp.makeConstraints { make in
                make.width.equalTo(0)
                make.height.equalTo(0)
            }
            return
        }
        let landscape = thumbnail!.size.width > thumbnail!.size.height
        if self.landscape != landscape {
            thumbImageView.snp.updateConstraints { make in
                make.width.equalTo(landscape ? landscapeW : potraitW)
                make.height.equalTo(landscape ? landscapeW / ratio : potraitW * ratio)
            }
            self.landscape = landscape
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
