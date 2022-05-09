//
//  MTVideoRightTollsView.swift
//  MSVideo
//
//  Created by MoliySDev on 2022/5/9.
//

import UIKit

protocol MTVideoRightToolsViewDelegate: NSObjectProtocol {
    
    func toolsViewTapHangler(ges: UITapGestureRecognizer)
}

class MTVideoRightToolsView: UIView {
    
    var model: MSVideoModel? {
        didSet {
            guard let _ = model else {return}
        }
    }
    
    weak var delegate: MTVideoRightToolsViewDelegate?
    
    private var avatarIcon: UIImageView = UIImageView(image: UIImage(named: "img_find_default"))
    
    private var focus: FocusView = FocusView()

    private var shareIcon: UIImageView = UIImageView(image: UIImage(named: "video_share"))
    
    private var commentIcon: UIImageView = UIImageView(image: UIImage(named: "video_comment"))
    
    private var collectIcon: UIImageView = UIImageView(image: UIImage(named: "video_collect_nor"))
    
    private var favoriteIcon: UIImageView = UIImageView(image: UIImage(named: "video_praise_nor"))
    
    private var shareNum: UILabel = UILabel()
    
    private var commentNum: UILabel = UILabel()
    
    private var collectNum: UILabel = UILabel()
    
    private var favoriteNum: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        shareIcon.contentMode = .center
        shareIcon.isUserInteractionEnabled = true
        shareIcon.tag = SHARE_TAP_ACTION
        shareIcon.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleGesture)))
        addSubview(shareIcon)
        
        shareNum.text = "分享"
        shareNum.textColor = .white
        shareNum.font = .systemFont(ofSize: 11, weight: .medium)
        addSubview(shareNum)
        
        collectIcon.contentMode = .center
        collectIcon.isUserInteractionEnabled = true
        collectIcon.tag = COLLECT_TAP_ACTION
        collectIcon.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleGesture)))
        addSubview(collectIcon)
        
        collectNum.text = "收藏"
        collectNum.textColor = .white
        collectNum.font = .systemFont(ofSize: 11, weight: .medium)
        addSubview(collectNum)
        
        commentIcon.contentMode = .center
        commentIcon.isUserInteractionEnabled = true
        commentIcon.tag = COMMENT_TAP_ACTION
        commentIcon.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleGesture)))
        addSubview(commentIcon)
        
        commentNum.text = "评论"
        commentNum.textColor = .white
        commentNum.font = .systemFont(ofSize: 11, weight: .medium)
        addSubview(commentNum)
        
        favoriteIcon.contentMode = .center
        favoriteIcon.isUserInteractionEnabled = true
        favoriteIcon.tag = PRAISE_TAP_ACTION
        favoriteIcon.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleGesture)))
        addSubview(favoriteIcon)
        
        favoriteNum.text = "点赞"
        favoriteNum.textColor = .white
        favoriteNum.font = .systemFont(ofSize: 11, weight: .medium)
        addSubview(favoriteNum)
        
        avatarIcon.layer.cornerRadius = 26
        avatarIcon.layer.borderColor = UIColor.white.cgColor
        avatarIcon.layer.borderWidth = 2
        addSubview(avatarIcon)
        
        addSubview(focus)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        shareIcon.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-16)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(38)
        }
        shareNum.snp.makeConstraints { make in
            make.top.equalTo(self.shareIcon.snp.bottom)
            make.centerX.equalTo(self.shareIcon)
            make.height.equalTo(16)
        }
        collectIcon.snp.makeConstraints { make in
            make.bottom.equalTo(shareIcon.snp.top).offset(-38)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(38)
        }
        collectNum.snp.makeConstraints { make in
            make.top.equalTo(self.collectIcon.snp.bottom)
            make.centerX.equalTo(self.collectIcon)
            make.height.equalTo(16)
        }
        commentIcon.snp.makeConstraints { make in
            make.bottom.equalTo(self.collectIcon.snp.top).offset(-38)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(38)
        }
        commentNum.snp.makeConstraints { make in
            make.top.equalTo(self.commentIcon.snp.bottom)
            make.centerX.equalTo(self.commentIcon)
        }
        favoriteIcon.snp.makeConstraints { make in
            make.bottom.equalTo(self.commentIcon.snp.top).offset(-38)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(38)
        }
        favoriteNum.snp.makeConstraints { make in
            make.top.equalTo(self.favoriteIcon.snp.bottom)
            make.centerX.equalTo(self.favoriteIcon)
        }
        let avatarRadius: CGFloat = 26
        avatarIcon.snp.makeConstraints { make in
            make.bottom.equalTo(self.favoriteIcon.snp.top).offset(-24)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(avatarRadius * 2)
            make.top.equalToSuperview()
        }
        focus.snp.makeConstraints { make in
            make.centerX.equalTo(self.avatarIcon)
            make.centerY.equalTo(self.avatarIcon.snp.bottom)
            make.width.height.equalTo(25)
        }
    }
    
    func prepareForReuse() {
        focus.resetView()
        avatarIcon.image = UIImage(named: "img_find_default")
    }
    
    @objc func handleGesture(ges: UITapGestureRecognizer) {
        delegate?.toolsViewTapHangler(ges: ges)
    }
}
