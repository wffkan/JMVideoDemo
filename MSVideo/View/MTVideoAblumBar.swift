//
//  MTVideoAblumBar.swift
//  MSVideo
//
//  Created by MoliySDev on 2022/5/10.
//

import UIKit
import SnapKit

class MTVideoAblumBar: UIButton {
    
    lazy var icon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "video_ablum_icon")
        return icon
    }()
    
    lazy var titleL: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .white.withAlphaComponent(0.9)
        return label
    }()
    
    lazy var indicator: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "video_ablum_indicator")
        return icon
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: "#262626").withAlphaComponent(0.4)
        addSubview(icon)
        addSubview(titleL)
        addSubview(indicator)
        
        icon.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview()
        }
        titleL.snp.makeConstraints { make in
            make.left.equalTo(icon.snp.right).offset(1)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-60)
        }
        indicator.snp.makeConstraints { make in
            make.right.equalTo(-20)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
