//
//  MTVideoAblumListCell.swift
//  MSVideo
//
//  Created by MoliySDev on 2022/5/10.
//

import UIKit


class MTVideoAblumListCell: UITableViewCell {
    
    lazy var coverIV: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    lazy var titleL: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor.white.withAlphaComponent(0.5)
        return label
    }()
    
    lazy var subTitleL: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()
    
    lazy var timeL: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white.withAlphaComponent(0.5)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(coverIV)
        contentView.addSubview(titleL)
        contentView.addSubview(subTitleL)
        contentView.addSubview(timeL)
        
        coverIV.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(8)
            make.width.equalTo(68)
            make.height.equalTo(102)
        }
        titleL.snp.makeConstraints { make in
            make.left.equalTo(coverIV.snp.right).offset(10)
            make.top.equalTo(8)
            make.height.equalTo(25)
        }
        subTitleL.snp.makeConstraints { make in
            make.left.equalTo(titleL)
            make.right.equalTo(-20)
            make.top.equalTo(titleL.snp.bottom).offset(8)
        }
        timeL.snp.makeConstraints { make in
            make.left.equalTo(titleL)
            make.bottom.equalTo(-8)
            make.height.equalTo(17)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
