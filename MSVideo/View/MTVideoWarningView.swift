//
//  MTVideoWarningView.swift
//  MSVideo
//
//  Created by MoliySDev on 2022/5/10.
//

import UIKit
import SnapKit

class MTVideoWarningView: UIView {
    
    lazy var icon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "video_warn_icon")
        return icon
    }()
    
    lazy var titleL: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white.withAlphaComponent(0.4)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(icon)
        addSubview(titleL)
        
        icon.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.width.height.equalTo(12)
            make.centerY.equalToSuperview()
        }
        titleL.snp.makeConstraints { make in
            make.left.equalTo(icon.snp.right).offset(8)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
