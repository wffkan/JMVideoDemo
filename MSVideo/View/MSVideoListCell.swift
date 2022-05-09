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



let PRAISE_TAP_ACTION:Int = 2000
let COMMENT_TAP_ACTION:Int = 3000
let SHARE_TAP_ACTION:Int = 4000
let COLLECT_TAP_ACTION:Int = 5000

protocol MSVideoListCellDelegate: NSObjectProtocol {
    
    func needToPlayOrPause(pause: Bool)
    
    func needToSeek(to progress: Float)
    
    func needToStopScroll(stop: Bool)
}

class MSVideoListCell: UICollectionViewCell {
    
    var videoModel: MSVideoModel!
    
    weak var delegate: MSVideoListCellDelegate?
    
    lazy private var container: MSVideoContainer = {
        let view = MSVideoContainer()
        view.delegate = self
        return view
    }()

    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.contentMode = .scaleAspectFit
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
    
    private lazy var thumbnailView: MSVideoThumbnailView = {
        let view = MSVideoThumbnailView()
        view.isHidden = true
        return view
    }()
    private lazy var rightToolsView: MTVideoRightToolsView = {
        let view = MTVideoRightToolsView()
        view.delegate = self
        return view
    }()
    
    private var lastTapTime: TimeInterval = 0
    
    private var lastTapPoint: CGPoint = .zero
    
    private var progressIndicator = ProgressIndicator()

    private var isProgressDraging: Bool = false  //是否正处于进度条长按拖动中
    
    private var isVideoLoading: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        setupSubViews()
    }

    private func setupSubViews() {
        
        contentView.addSubview(bgImageView)
        contentView.addSubview(container)
        
        container.layer.addSublayer(gradientLayer)
        container.addSubview(pauseIcon)
        
        container.addSubview(rightToolsView)
        container.addSubview(progressIndicator)
        container.addSubview(thumbnailView)
        
        setupLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        pauseIcon.isHidden = true
        self.isVideoLoading = false
        
        progressIndicator.updateProgess(progress: 0)
        rightToolsView.prepareForReuse()
    }
    
    func reloadData(model: MSVideoModel) {
        self.videoModel = model
        rightToolsView.model = model
        if model.coverUrl.hasPrefix("http") {
            let coverUrl = model.coverUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            self.bgImageView.kf.setImage(with: URL(string: coverUrl))
        }else {
            let coverUrl = Bundle.main.path(forResource: model.coverUrl, ofType: nil) ?? ""
            self.bgImageView.kf.setImage(with: URL(fileURLWithPath: coverUrl))
        }
    }
    
    func updateProgress(progress: Float) {
        if self.isProgressDraging {
            return
        }
        progressIndicator.updateProgess(progress: progress)
    }
    
    func playStatusChanged(to status: MSVideoPlayerStatus) {

        self.pauseIcon.isHidden = (status != .paused)
        if status == .loadingStart && !self.isProgressDraging {

            self.progressIndicator.isHidden = true
            self.isVideoLoading = true
        }else if status == .loadingEnd {
            self.progressIndicator.isHidden = false
            self.isVideoLoading = false
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bgImageView.frame = self.bounds
        container.frame = self.bounds
        pauseIcon.frame = CGRect(x: self.bounds.midX - 50, y: self.bounds.midY - 50, width: 100, height: 100)
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        gradientLayer.frame = CGRect.init(x: 0, y: self.bounds.height - 500, width: self.bounds.width, height: 500)
        CATransaction.commit()
    }
    
    private func setupLayout() {

        rightToolsView.snp.makeConstraints { make in
            make.width.equalTo(38)
            make.right.equalToSuperview().offset(-17)
            make.bottom.equalTo(progressIndicator.snp.top).offset(-60)
        }
        progressIndicator.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(2)
            make.bottom.equalToSuperview().offset(-UIScreen.safeAreaBottomHeight - 46)
        }
        
        thumbnailView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(progressIndicator.snp.top).offset(-67)
            make.width.equalToSuperview()
        }
    }
    
    func handleGesture(ges: UITapGestureRecognizer) {
        
        switch ges.view?.tag {
        case COMMENT_TAP_ACTION:
//            CommentsPopView.init(awemeId: "").show()
            break
        case SHARE_TAP_ACTION:
            SharePopView().show()
            break
        case COLLECT_TAP_ACTION:
            break
        case PRAISE_TAP_ACTION:
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
//                showLikeViewAnim(newPoint: point, oldPoint: lastTapPoint)
            }
            //更新上一次点击位置
            lastTapPoint = point
            //更新上一次点击时间
            lastTapTime = time
            break
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MSVideoListCell: MSVideoContainerDelegate {
    
    func containerTapGestureHandler(ges: UITapGestureRecognizer) {
        handleGesture(ges: ges)
    }
    
    func containerLongGestureHandler(ges: UILongPressGestureRecognizer) {
        
    }
    
    static var preX: CGFloat = 0
    static var startProgess: Float = 0
    func containerPanGestureHandler(ges: UIPanGestureRecognizer) {
        
        if self.isVideoLoading {return}
        switch ges.state {
            case .began:
                let startPoint = ges.location(in: ges.view)
                self.progressIndicator.progressType = 1
                MSVideoListCell.preX = startPoint.x
                MSVideoListCell.startProgess = self.progressIndicator.progress
                //先暂停
                self.isProgressDraging = true
            //拖动进度条时，将列表上下滚动禁止
            delegate?.needToStopScroll(stop: true)
                //清屏
                cleanScreen(hidden: true)
                self.thumbnailView.isHidden = false
            case .changed:
                let point = ges.location(in: ges.view)
                let offsetX = point.x - MSVideoListCell.preX
                var n_progress = MSVideoListCell.startProgess + Float(offsetX / self.progressIndicator.width)
                n_progress = max(n_progress, 0)
                n_progress = min(n_progress, 1)
                self.progressIndicator.updateProgess(progress: n_progress, animated: false)
                let duration = Float(MSVideoPlayerManager.duration)
                self.thumbnailView.update(thumbnail: nil, currentT: Int(duration * n_progress), totalT: Int(duration))
                
            case .ended:
                self.progressIndicator.progressType = 0
                self.isProgressDraging = false
                
                let point = ges.location(in: ges.view)
                let offsetX = point.x - MSVideoListCell.preX
                var n_progress = MSVideoListCell.startProgess + Float(offsetX / self.progressIndicator.width)
                n_progress = max(n_progress, 0)
                n_progress = min(n_progress, 1)
                delegate?.needToSeek(to: n_progress)
                //列表禁止滚动解除
                delegate?.needToStopScroll(stop: false)
                cleanScreen(hidden: false)
                self.thumbnailView.isHidden = true
            default:
                self.progressIndicator.progressType = 0
                self.isProgressDraging = false
                //列表禁止滚动解除
                delegate?.needToStopScroll(stop: false)
                cleanScreen(hidden: false)
                self.thumbnailView.isHidden = true
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
    
    //拖动进度条时，将屏幕清屏
    func cleanScreen(hidden: Bool) {
        UIView.animate(withDuration: 0.25) {
            self.rightToolsView.isHidden = hidden
            if let vc = self.currentVC() as? MSVideoPlayController {
                vc.navView.alpha = hidden ? 0 : 1
            }
        }
    }
}

extension MSVideoListCell: MTVideoRightToolsViewDelegate {
    
    func toolsViewTapHangler(ges: UITapGestureRecognizer) {
        handleGesture(ges: ges)
    }
}
