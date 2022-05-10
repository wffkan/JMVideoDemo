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
let QUESTION_TAP_ACTION:Int = 6000

protocol MSVideoListCellDelegate: NSObjectProtocol {
    
    func needToPlayOrPause(pause: Bool)
    
    func needToSeek(to progress: Float)
    
    func needToStopScroll(stop: Bool)
}

class MTVideoListCell: UICollectionViewCell {
    
    var videoModel: MSVideoModel!
    
    weak var delegate: MSVideoListCellDelegate?
    
    lazy private var container: MTVideoContainer = {
        let view = MTVideoContainer()
        view.delegate = self
        return view
    }()

    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.contentMode = .scaleAspectFit
        bgImageView.clipsToBounds = true
        return bgImageView
    }()
    
    private lazy var bottomGradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.black.withAlphaComponent(0.5).cgColor, UIColor.black.withAlphaComponent(0.0).cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
        return gradientLayer
    }()
    
    private lazy var topGradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.black.withAlphaComponent(0.4).cgColor, UIColor.black.withAlphaComponent(0.0).cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        return gradientLayer
    }()
    
    private lazy var pauseIcon: UIImageView = {
        let pauseIcon = UIImageView(image: UIImage(named: "video_pause"))
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
    
    private lazy var commentBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("发表下您的观点...", for: .normal)
        btn.setTitleColor(.white.withAlphaComponent(0.35), for: .normal)
        btn.setTitleColor(.white.withAlphaComponent(0.35), for: .highlighted)
        btn.titleLabel?.font = .systemFont(ofSize: 16)
        btn.contentHorizontalAlignment = .left
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        btn.addTarget(self, action: #selector(commentBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var ablumBar: MTVideoAblumBar = {
        let view = MTVideoAblumBar()
        view.addTarget(self, action: #selector(ablumbarClick), for: .touchUpInside)
        return view
    }()
    
    private lazy var warningView: MTVideoWarningView = MTVideoWarningView()
    
    private lazy var timeL: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white.withAlphaComponent(0.4)
        return label
    }()
    
    private lazy var descL: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var nameL: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private lazy var qaView: MTRelateQestionView = {
        let view = MTRelateQestionView()
        view.tag = QUESTION_TAP_ACTION
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleGesture))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    private lazy var tagsView: MTVideoTagView = {
        let view = MTVideoTagView()
        view.delegate = self
        return view
    }()
    
    private var lastTapTime: TimeInterval = 0
    
    private var lastTapPoint: CGPoint = .zero
    
    private var progressIndicator = MTProgressIndicator()

    private var isProgressDraging: Bool = false  //是否正处于进度条长按拖动中
    
    private var isVideoLoading: Bool = false   //视频不否正在加载中
    
    private var relateQaFold: Bool = false  //相关问答折叠状态
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        setupSubViews()
    }

    private func setupSubViews() {
        
        contentView.addSubview(bgImageView)
        contentView.addSubview(container)
        
        container.layer.addSublayer(topGradientLayer)
        container.layer.addSublayer(bottomGradientLayer)
        container.addSubview(pauseIcon)
        
        container.addSubview(ablumBar)
        container.addSubview(commentBtn)
        container.addSubview(rightToolsView)
        container.addSubview(progressIndicator)
        container.addSubview(thumbnailView)
        
        container.addSubview(warningView)
        container.addSubview(timeL)
        container.addSubview(descL)
        container.addSubview(nameL)
        container.addSubview(qaView)
        container.addSubview(tagsView)
        
        setupLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        pauseIcon.isHidden = true
        self.isVideoLoading = false
        
        progressIndicator.updateProgess(progress: 0)
        rightToolsView.prepareForReuse()
        
        if relateQaFold {
            relateQaFold = false
            qaView.unfold()
        }
    }
    
    //MARK: - 加载数据
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
        self.ablumBar.titleL.text = "视频合集： 试管婴儿"
        self.warningView.titleL.text = "[该内容存在争议，请谨慎辨别]"
        self.timeL.text = "昨天14:20"
        let descText = "哈哈哈哈哈，我只是描述哦我只是描述哦我只是描述哦我只是描述哦我只是描述,是描述哦我只是描述哦我只是描述..."
        self.descL.changeLineSpace(space: 6, text: descText)
        self.nameL.text = "@用户id"
        let qaDesc = "你到底吃了几碗的粉，这不欺负老实人这不欺负老实人老实人老实人老实人老实…人老实人老实人老实人老实"
        self.qaView.descL.changeLineSpace(space: 3, text: qaDesc)
    }
    
    func updateProgress(progress: Float) {
        if self.isProgressDraging {
            return
        }
        progressIndicator.updateProgess(progress: progress)
    }
    
    func playStatusChanged(to status: MSVideoPlayerStatus) {

        self.pauseIcon.isHidden = (status != .paused)
        if status == .loadingStart {
            self.isVideoLoading = true
        }else if status == .loadingEnd {
            self.isVideoLoading = false
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bgImageView.frame = self.bounds
        container.frame = self.bounds
        pauseIcon.frame = CGRect(x: self.bounds.midX - 68, y: self.bounds.midY - 68, width: 136, height: 136)
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        topGradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: UIScreen.status_navi_height + 22)
        bottomGradientLayer.frame = CGRect(x: 0, y: UIScreen.height - 300 - 50 - UIScreen.safeAreaBottomHeight, width: UIScreen.width, height: 300)
        CATransaction.commit()
    }
    
    private func setupLayout() {

        commentBtn.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-UIScreen.safeAreaBottomHeight)
            make.height.equalTo(50)
        }
        rightToolsView.snp.makeConstraints { make in
            make.width.equalTo(38)
            make.right.equalToSuperview().offset(-17)
            make.bottom.equalTo(commentBtn.snp.top).offset(-64)
        }
        progressIndicator.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(2)
            make.bottom.equalTo(commentBtn.snp.top)
        }
        ablumBar.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
            make.bottom.equalTo(commentBtn.snp.top)
        }
        thumbnailView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(progressIndicator.snp.top).offset(-67)
            make.width.equalToSuperview()
        }
        warningView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview().offset(-80)
            make.height.equalTo(17)
            make.bottom.equalTo(commentBtn.snp.top).offset(-64)
        }
        tagsView.snp.makeConstraints {[weak self] make in
            guard let `self` = self else{return}
            make.left.equalTo(20)
            make.bottom.equalTo(warningView.snp.top).offset(-10)
            make.width.equalTo(self.tagsView.totalSize.width)
            make.height.equalTo(self.tagsView.totalSize.height)
        }
        timeL.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.height.equalTo(17)
            make.bottom.equalTo(tagsView.snp.top).offset(-10)
        }
        descL.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.bottom.equalTo(timeL.snp.top).offset(-8)
            make.right.equalTo(-82)
        }
        nameL.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.bottom.equalTo(descL.snp.top).offset(-8)
            make.height.equalTo(25)
        }
        qaView.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.bottom.equalTo(nameL.snp.top).offset(-10)
            make.right.lessThanOrEqualToSuperview().offset(-82)
            make.height.lessThanOrEqualTo(84)
        }
    }
    
    @objc func handleGesture(ges: UITapGestureRecognizer) {
        
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
        case QUESTION_TAP_ACTION:
                if relateQaFold {
                    qaView.unfold()
                }else {
                    qaView.fold()
                }
                relateQaFold = !relateQaFold
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
    
    //MARK: - 评论
    @objc private func commentBtnClick() {
        print("commentBtnClick")
    }
    
    //MARK: - 视频合集
    @objc func ablumbarClick() {
        let vc = MTVideoAblumVC()
        self.currentVC()?.present(vc, animated: true, completion: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MTVideoListCell: MTVideoContainerDelegate,MTVideoTagViewDelegate {
    
    func videoTagDidTap(index: Int) {
        print("index: \(index)")
    }
    
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
                MTVideoListCell.preX = startPoint.x
                MTVideoListCell.startProgess = self.progressIndicator.progress
                //先暂停
                self.isProgressDraging = true
            //拖动进度条时，将列表上下滚动禁止
            delegate?.needToStopScroll(stop: true)
                //清屏
                cleanScreen(hidden: true)
                self.thumbnailView.isHidden = false
            case .changed:
                let point = ges.location(in: ges.view)
                let offsetX = point.x - MTVideoListCell.preX
                var n_progress = MTVideoListCell.startProgess + Float(offsetX / self.progressIndicator.width)
                n_progress = max(n_progress, 0)
                n_progress = min(n_progress, 1)
                self.progressIndicator.updateProgess(progress: n_progress, animated: false)
                let duration = Float(MSVideoPlayerManager.duration)
                self.thumbnailView.update(thumbnail: nil, currentT: Int(duration * n_progress), totalT: Int(duration))
                
            case .ended:
                self.progressIndicator.progressType = 0
                self.isProgressDraging = false
                
                let point = ges.location(in: ges.view)
                let offsetX = point.x - MTVideoListCell.preX
                var n_progress = MTVideoListCell.startProgess + Float(offsetX / self.progressIndicator.width)
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
extension MTVideoListCell {
    
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
            self.rightToolsView.alpha = hidden ? 0 : 1
            self.ablumBar.alpha = hidden ? 0 : 1
            self.warningView.alpha = hidden ? 0 : 1
            self.timeL.alpha = hidden ? 0 : 1
            self.descL.alpha = hidden ? 0 : 1
            self.nameL.alpha = hidden ? 0 : 1
            self.qaView.alpha = hidden ? 0 : 1
            if let vc = self.currentVC() as? MSVideoPlayController {
                vc.navView.alpha = hidden ? 0 : 1
            }
        }
    }
}

extension MTVideoListCell: MTVideoRightToolsViewDelegate {
    
    func toolsViewTapHangler(ges: UITapGestureRecognizer) {
        handleGesture(ges: ges)
    }
}
