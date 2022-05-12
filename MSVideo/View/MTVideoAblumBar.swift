//
//  MTVideoAblumBar.swift
//  MSVideo
//
//  Created by MoliySDev on 2022/5/10.
//

import UIKit
import SnapKit

class MTVideoAblumBar: UIView {
    
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

class MTVideoAblumSubBar: UIView {
    
    lazy var icon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "video_ablum_icon")
        return icon
    }()
    
    lazy var titleView: MTVideoAblumTitleView = {
        let view = MTVideoAblumTitleView()
        return view
    }()
    
    lazy var indicator: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "video_ablum_up")
        return icon
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white.withAlphaComponent(0.2)
        layer.cornerRadius = 10
        addSubview(icon)
        addSubview(titleView)
        addSubview(indicator)
        
        icon.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview()
        }
        titleView.snp.makeConstraints { make in
            make.left.equalTo(icon.snp.right).offset(1)
            make.centerY.equalToSuperview()
        }
        indicator.snp.makeConstraints { make in
            make.right.equalTo(-16)
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class MTVideoAblumTitleView: UIView {
    
    lazy var titleL: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    lazy var dotView: UIView = {
        let view = UIView(bgColor: .white.withAlphaComponent(0.5))
        view.layer.cornerRadius = 2
        return view
    }()
    
    lazy var numL: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .white.withAlphaComponent(0.9)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleL)
        addSubview(dotView)
        addSubview(numL)
        titleL.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        dotView.snp.makeConstraints { make in
            make.left.equalTo(titleL.snp.right).offset(8)
            make.width.height.equalTo(4)
            make.centerY.equalToSuperview()
        }
        numL.snp.makeConstraints { make in
            make.left.equalTo(dotView.snp.right).offset(8)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
