//
//  MTRelateQestionView.swift
//  MSVideo
//
//  Created by MoliySDev on 2022/5/10.
//

import UIKit
import SnapKit


class MTRelateQestionView: UIView {
    
    lazy var icon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "video_qa_icon")
        return icon
    }()
    
    lazy var titleL: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white.withAlphaComponent(0.9)
        label.text = "相关问答"
        return label
    }()
    
    lazy var descL: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(hex: "#262626").withAlphaComponent(0.3)
        layer.cornerRadius = 8
        layer.borderColor = UIColor.white.withAlphaComponent(0.4).cgColor
        layer.borderWidth = 0.5
        
        addSubview(icon)
        addSubview(titleL)
        addSubview(descL)
        
        icon.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.left.equalTo(10)
            make.top.equalTo(10)
        }
        titleL.snp.makeConstraints { make in
            make.left.equalTo(icon.snp.right).offset(2)
            make.width.equalTo(58)
            make.height.equalTo(20)
            make.top.equalTo(10)
        }
        descL.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-10)
            make.top.equalTo(icon.snp.bottom).offset(4)
        }
    }
    
    func fold() {
        descL.snp.remakeConstraints { make in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.width.equalTo(80)
            make.height.equalTo(0)
            make.bottom.equalTo(-10)
            make.top.equalTo(icon.snp.bottom)
        }
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
            self.superview?.layoutIfNeeded()
        }
    }
    
    func unfold() {
        descL.snp.remakeConstraints { make in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-10)
            make.top.equalTo(icon.snp.bottom).offset(4)
        }
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
            self.superview?.layoutIfNeeded()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
