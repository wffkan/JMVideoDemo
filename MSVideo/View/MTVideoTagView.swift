//
//  MTVideoTagView.swift
//  MSVideo
//
//  Created by MoliySDev on 2022/5/10.
//

import UIKit

protocol MTVideoTagViewDelegate: NSObjectProtocol {
    
    func videoTagDidTap(index: Int)
}

class MTVideoTagView: UIView {
    
    weak var delegate: MTVideoTagViewDelegate?
    
    private(set) var totalSize: CGSize = .zero
    
    private var items: [MTVideoTagItem] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //最多显示四个标签
        for i in 0..<4 {
            let item = MTVideoTagItem()
            item.tag = 10000 + i
            addSubview(item)
            items.append(item)
            let tap = UITapGestureRecognizer(target: self, action: #selector(tagTap))
            item.addGestureRecognizer(tap)
        }
        test()
    }
    
    func test() {
        let tags: [String] = ["试管婴儿","试管婴儿111","试管婴儿222","试管婴儿333","试管婴儿444"]
        
        var preX: CGFloat = 0
        var preY: CGFloat = 0
        for (index,item) in items.enumerated() {
            if index < tags.count {
                item.isHidden = false
                item.titleL.text = tags[index]
                let textSize = tags[index].singleLineSizeWithAttributeText(font: item.titleL.font)
                let tagViewW: CGFloat = textSize.width + 26 + 6
                let tagViewH: CGFloat = 30
                if preX + tagViewW + 8 > UIScreen.width - 20 - 82 {
                    preX = 0
                    preY += tagViewH + 8
                }
                item.frame = CGRect(x: preX, y: preY, width: tagViewW, height: tagViewH)
                preX += tagViewW + 8
                if preY > 0 {
                    totalSize = CGSize(width: UIScreen.width - 20 - 82, height: item.bottom)
                }else {
                    totalSize = CGSize(width: item.right, height: item.bottom)
                }
            }else {
                item.isHidden = true
            }
        }
    }
    
    @objc func tagTap(ges: UITapGestureRecognizer) {
        
        if let tag = ges.view?.tag {
            delegate?.videoTagDidTap(index: tag - 10000)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MTVideoTagItem: UIView {
    
    lazy var icon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "video_tag_icon")
        return icon
    }()
    
    lazy var titleL: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(hex: "#262626").withAlphaComponent(0.3)
        layer.cornerRadius = 5
        addSubview(icon)
        addSubview(titleL)
        
        icon.snp.makeConstraints { make in
            make.left.equalTo(6)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16)
        }
        titleL.snp.makeConstraints { make in
            make.left.equalTo(icon.snp.right).offset(4)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
