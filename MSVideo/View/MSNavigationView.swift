//
//  MSNavigationView.swift
//  MSVideo
//
//  Created by MoliySDev on 2022/4/27.
//

import UIKit
import SnapKit

class MSNavigationView: UIView {
    
    lazy var leftButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "nav_back"), for: .normal)
        return btn
    }()
    
    lazy var rightButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: ""), for: .normal)
        return btn
    }()
    
    lazy var titleL: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(leftButton)
        addSubview(rightButton)
        addSubview(titleL)
        leftButton.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.top.equalTo(UIScreen.statusbarHeight)
            make.width.height.equalTo(UIScreen.navBarHeight)
        }
        rightButton.snp.makeConstraints { make in
            make.right.equalTo(-10)
            make.top.equalTo(UIScreen.statusbarHeight)
            make.width.height.equalTo(UIScreen.navBarHeight)
        }
        titleL.snp.makeConstraints { make in
            make.top.equalTo(UIScreen.statusbarHeight)
            make.height.equalTo(UIScreen.navBarHeight)
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualTo(UIScreen.width - UIScreen.navBarHeight * 3)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
