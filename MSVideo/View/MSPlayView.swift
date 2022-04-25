//
//  MSPlayView.swift
//  MSVideo
//
//  Created by 王方芳 on 2022/4/23.
//

import Foundation
import UIKit


class MSPlayView: UIView {
    
    lazy var bgImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "img_video_loading")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.bgImageView.frame = self.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
