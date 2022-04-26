//
//  MSVideoListView.swift
//  MSVideo
//
//  Created by 王方芳 on 2022/4/23.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

let LIKE_BEFORE_TAP_ACTION:Int = 1000
let LIKE_AFTER_TAP_ACTION:Int = 2000
let COMMENT_TAP_ACTION:Int = 3000
let SHARE_TAP_ACTION:Int = 4000

typealias OnPlayerReady = () -> Void

protocol MSVideoListCellDelegate: NSObjectProtocol {
    
    func needToPlayOrPause(pause: Bool)
}

class MSVideoListCell: UICollectionViewCell {
    
    lazy var playerView: MSPlayView = {
        let view = MSPlayView()
        view.backgroundColor = .clear
        return view
    }()
    
    var videoModel: MSVideoModel!
    
    weak var delegate: MSVideoListCellDelegate?
    
    private var container: UIView = UIView()

    lazy private var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.contentMode = .scaleAspectFill
        bgImageView.clipsToBounds = true
        return bgImageView
    }()
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ColorClear.cgColor, ColorBlackAlpha20.cgColor, ColorBlackAlpha40.cgColor]
        gradientLayer.locations = [0.3, 0.6, 1.0]
        gradientLayer.startPoint = CGPoint.init(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint.init(x: 0.0, y: 1.0)
        return gradientLayer
    }()
    
    private lazy var pauseIcon: UIImageView = {
        let pauseIcon = UIImageView(image: UIImage(named: "icon_play_pause"))
        pauseIcon.contentMode = .center
        pauseIcon.layer.zPosition = 3
        pauseIcon.isHidden = true
        return pauseIcon
    }()
    
    private var musicIcon: UIImageView = UIImageView(image: UIImage(named: "icon_home_musicnote3"))
    
    private lazy var playerStatusBar: UIView = {
        let playerStatusBar = UIView(bgColor: .white)
        playerStatusBar.isHidden = true
        return playerStatusBar
    }()
    
    private var singleTapGesture: UITapGestureRecognizer?
    
    private var lastTapTime: TimeInterval = 0
    
    private var lastTapPoint: CGPoint = .zero
    
    private var musicName: CircleTextView = CircleTextView()
    
    private var desc: UILabel = UILabel()
    
    private var nickName: UILabel = UILabel()
    
    private var avatarIcon: UIImageView = UIImageView(image: UIImage(named: "img_find_default"))
    
    private var focus: FocusView = FocusView()
    
    private var musicAlum: MusicAlbumView = MusicAlbumView()
    
    private var shareIcon: UIImageView = UIImageView(image: UIImage(named: "icon_home_share"))
    
    private var commentIcon: UIImageView = UIImageView(image: UIImage(named: "icon_home_comment"))
    
    private var favorite: FavoriteView = FavoriteView()
    
    private var shareNum: UILabel = UILabel()
    
    private var commentNum: UILabel = UILabel()
    
    private var favoriteNum: UILabel = UILabel()
    
    private var onPlayerReady:OnPlayerReady?
    private var isPlayerReady:Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupSubViews()
    }

    private func setupSubViews() {
        
        contentView.addSubview(bgImageView)
        contentView.addSubview(playerView)
        contentView.addSubview(container)
        
        singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleGesture))
        container.addGestureRecognizer(singleTapGesture!)
        
        container.layer.addSublayer(gradientLayer)
        container.addSubview(pauseIcon)
        
        container.addSubview(playerStatusBar)
        
        musicIcon.contentMode = .center
        container.addSubview(musicIcon)
        
        musicName.textColor = ColorWhite
        musicName.font = MediumFont
        container.addSubview(musicName)
        
        desc.numberOfLines = 0
        desc.textColor = ColorWhiteAlpha80
        desc.font = MediumFont
        container.addSubview(desc)
        
        nickName.textColor = ColorWhite
        nickName.font = BigBoldFont
        container.addSubview(nickName)
        
        container.addSubview(musicAlum)
        
        shareIcon.contentMode = .center
        shareIcon.isUserInteractionEnabled = true
        shareIcon.tag = SHARE_TAP_ACTION
        shareIcon.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleGesture)))
        container.addSubview(shareIcon)
        
        shareNum.text = "0"
        shareNum.textColor = ColorWhite
        shareNum.font = SmallFont
        container.addSubview(shareNum)
        
        commentIcon.contentMode = .center
        commentIcon.isUserInteractionEnabled = true
        commentIcon.tag = COMMENT_TAP_ACTION
        commentIcon.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleGesture)))
        container.addSubview(commentIcon)
        
        commentNum.text = "0"
        commentNum.textColor = ColorWhite
        commentNum.font = SmallFont
        container.addSubview(commentNum)
        
        container.addSubview(favorite)
        
        favoriteNum.text = "0"
        favoriteNum.textColor = ColorWhite
        favoriteNum.font = SmallFont
        container.addSubview(favoriteNum)
        
        avatarIcon.layer.cornerRadius = 25
        avatarIcon.layer.borderColor = ColorWhiteAlpha80.cgColor
        avatarIcon.layer.borderWidth = 1
        container.addSubview(avatarIcon)
        
        container.addSubview(focus)
        
        setupLayout()
        
        musicAlum.startAnimation(rate: 0)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isPlayerReady = false
        pauseIcon.isHidden = true
        
        avatarIcon.image = UIImage(named: "img_find_default")
        
//        musicAlum.resetView()
        favorite.resetView()
        focus.resetView()
    }
    
    func reloadData(model: MSVideoModel) {
        self.videoModel = model
        nickName.text = "@人生如戏"
        desc.text = "开心就好宠粉狂魔～\n过儿小狮妹\n衣服 @过儿小狮妹"
        musicName.text = "谁还不是个宝宝（我小嘴像樱桃 撅起嘴角身你笑）"
        favoriteNum.text = String.formatCount(count: 58)
        commentNum.text = String.formatCount(count: 12)
        shareNum.text = String.formatCount(count: 66)
        self.bgImageView.kf.setImage(with: URL(string: model.basicInfo.coverUrl))
    }
    
    func updateProgress(progress: Float) {
        
    }
    
    func playStatusChanged(to status: MSVideoPlayerStatus) {

        self.pauseIcon.isHidden = (status == .playing || status == .loading || status == .prepared)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bgImageView.frame = self.bounds
        container.frame = self.bounds
        playerView.frame = self.bounds
        pauseIcon.frame = CGRect(x: self.bounds.midX - 50, y: self.bounds.midY - 50, width: 100, height: 100)
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        gradientLayer.frame = CGRect.init(x: 0, y: self.bounds.height - 500, width: self.bounds.width, height: 500)
        CATransaction.commit()
        
        playerStatusBar.frame = CGRect(x: self.bounds.midX - 0.5, y: self.bounds.maxY - 49.5 - UIScreen.safeAreaBottomHeight, width: 1, height: 1)
    }
    
    private func setupLayout() {
        musicIcon.snp.makeConstraints { make in
            make.left.equalTo(self)
            make.bottom.equalTo(self).inset(60 + UIScreen.safeAreaBottomHeight)
            make.width.equalTo(30)
            make.height.equalTo(25)
        }

        musicName.snp.makeConstraints { make in
            make.left.equalTo(self.musicIcon.snp.right)
            make.centerY.equalTo(self.musicIcon)
            make.width.equalTo(UIScreen.width / 2)
            make.height.equalTo(20)
        }
        desc.snp.makeConstraints { make in
            make.left.equalTo(self).offset(10)
            make.bottom.equalTo(self.musicIcon.snp.top).inset(-5)
            make.width.lessThanOrEqualTo(UIScreen.width / 5 * 3)
        }
        nickName.snp.makeConstraints { make in
            make.left.equalTo(self).offset(10)
            make.bottom.equalTo(self.desc.snp.top).inset(-5)
            make.width.lessThanOrEqualTo(UIScreen.width / 4 * 3 + 30)
        }
        musicAlum.snp.makeConstraints { make in
            make.bottom.equalTo(self.musicName)
            make.right.equalTo(self).inset(10)
            make.width.height.equalTo(50)
        }
        shareIcon.snp.makeConstraints { make in
            make.bottom.equalTo(self.musicAlum.snp.top).inset(-50)
            make.right.equalTo(self).inset(10)
            make.width.equalTo(50)
            make.height.equalTo(45)
        }
        shareNum.snp.makeConstraints { make in
            make.top.equalTo(self.shareIcon.snp.bottom);
            make.centerX.equalTo(self.shareIcon);
        }
        commentIcon.snp.makeConstraints { make in
            make.bottom.equalTo(self.shareIcon.snp.top).inset(-25);
            make.right.equalTo(self).inset(10);
            make.width.equalTo(50);
            make.height.equalTo(45);
        }
        commentNum.snp.makeConstraints { make in
            make.top.equalTo(self.commentIcon.snp.bottom);
            make.centerX.equalTo(self.commentIcon);
        }
        favorite.snp.makeConstraints { make in
            make.bottom.equalTo(self.commentIcon.snp.top).inset(-25);
            make.right.equalTo(self).inset(10);
            make.width.equalTo(50);
            make.height.equalTo(45);
        }
        favoriteNum.snp.makeConstraints { make in
            make.top.equalTo(self.favorite.snp.bottom);
            make.centerX.equalTo(self.favorite);
        }
        let avatarRadius:CGFloat = 25;
        avatarIcon.snp.makeConstraints { make in
            make.bottom.equalTo(self.favorite.snp.top).inset(-35);
            make.right.equalTo(self).inset(10);
            make.width.height.equalTo(avatarRadius*2);
        }
        focus.snp.makeConstraints { make in
            make.centerX.equalTo(self.avatarIcon);
            make.centerY.equalTo(self.avatarIcon.snp.bottom);
            make.width.height.equalTo(24);
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MSVideoListCell {
    
    @objc func handleGesture(ges: UITapGestureRecognizer) {
        
        switch ges.view?.tag {
        case COMMENT_TAP_ACTION:
//            CommentsPopView.init(awemeId: "").show()
            break
        case SHARE_TAP_ACTION:
            SharePopView.init().show()
            break
        default:
            //获取点击坐标，用于设置爱心显示位置
            let point = ges.location(in: container)
            //获取当前时间
            let time = CACurrentMediaTime()
            //判断当前点击时间与上次点击时间的时间间隔
            if (time - lastTapTime) > 0.25 {
                //推迟0.25秒执行单击方法
                self.perform(#selector(singleTapAction), with: nil, afterDelay: 0.25)
            } else {
                //取消执行单击方法
                NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(singleTapAction), object: nil)
                //执行连击显示爱心的方法
                showLikeViewAnim(newPoint: point, oldPoint: lastTapPoint)
            }
            //更新上一次点击位置
            lastTapPoint = point
            //更新上一次点击时间
            lastTapTime = time
            break
        }
    }
    
    @objc func singleTapAction() {

        self.delegate?.needToPlayOrPause(pause: self.pauseIcon.isHidden)
        showPauseViewAnim()
    }
    
}


//animation
extension MSVideoListCell {
    
    func showPauseViewAnim() {
        if self.pauseIcon.isHidden == false {
            UIView.animate(withDuration: 0.25, animations: {
                self.pauseIcon.alpha = 0.0
            }) { finished in
                self.pauseIcon.isHidden = true
                self.pauseIcon.alpha = 1
            }
        } else {
            pauseIcon.isHidden = false
            pauseIcon.transform = CGAffineTransform.init(scaleX: 1.8, y: 1.8)
            pauseIcon.alpha = 1.0
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
                self.pauseIcon.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
            }) { finished in
            }
        }
    }
    
    func showLikeViewAnim(newPoint:CGPoint, oldPoint:CGPoint) {
        let likeImageView = UIImageView.init(image: UIImage.init(named: "icon_home_like_after"))
        var k = (oldPoint.y - newPoint.y) / (oldPoint.x - newPoint.x)
        k = abs(k) < 0.5 ? k : (k > 0 ? 0.5 : -0.5)
        let angle = .pi/4 * -k
        likeImageView.frame = CGRect.init(origin: newPoint, size: CGSize.init(width: 80, height: 80))
        likeImageView.transform = CGAffineTransform.init(scaleX: 0.8, y: 1.8).concatenating(CGAffineTransform.init(rotationAngle: angle))
        self.container.addSubview(likeImageView)
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            likeImageView.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0).concatenating(CGAffineTransform.init(rotationAngle: angle))
        }) { finished in
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                likeImageView.transform = CGAffineTransform.init(scaleX: 3.0, y: 3.0).concatenating(CGAffineTransform.init(rotationAngle: angle))
                likeImageView.alpha = 0.0
            }, completion: { finished in
                likeImageView.removeFromSuperview()
            })
        }
    }
    
    func startLoadingPlayItemAnim(_ isStart:Bool = true) {
        if isStart {
            playerStatusBar.backgroundColor = ColorWhite
            playerStatusBar.isHidden = false
            playerStatusBar.layer.removeAllAnimations()
            
            let animationGroup = CAAnimationGroup.init()
            animationGroup.duration = 0.5
            animationGroup.beginTime = CACurrentMediaTime()
            animationGroup.repeatCount = .infinity
            animationGroup.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
            
            let scaleAnim = CABasicAnimation.init()
            scaleAnim.keyPath = "transform.scale.x"
            scaleAnim.fromValue = 1.0
            scaleAnim.toValue = 1.0 * UIScreen.width
            
            let alphaAnim = CABasicAnimation.init()
            alphaAnim.keyPath = "opacity"
            alphaAnim.fromValue = 1.0
            alphaAnim.toValue = 0.2
            
            animationGroup.animations = [scaleAnim, alphaAnim]
            playerStatusBar.layer.add(animationGroup, forKey: nil)
        } else {
            playerStatusBar.layer.removeAllAnimations()
            playerStatusBar.isHidden = true
        }
        
    }
}
