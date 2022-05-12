//
//  MSVideoPlayController.swift
//  MSVideo
//
//  Created by 王方芳 on 2022/4/23.
//

import Foundation
import UIKit
import AliyunPlayer
import AVFoundation


enum MTVideoPlayerStatus {
    case unload // 未加载
    case firstRenderedStart // 首帧显示
    case autoPlayStart // 自动播放开始事件
    case loadingStart // 缓冲开始
    case loadingEnd // 缓冲结束
    case paused // 暂停
    case ended // 播放完成
    case seekEnd  // 跳转完成
    case loopingStart  // 循环播放开始
    case error // 错误
}

class MSVideoPlayController: BFBaseViewController {
    
    var resourceViewProvider: ((_ index: Int) -> UIView?)?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.width, height: UIScreen.height)
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.width, height: UIScreen.height), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.backgroundColor = .black
        collectionView.register(MTVideoListCell.self, forCellWithReuseIdentifier: "videoCell")
        return collectionView
    }()
    
    lazy var navView: MSNavigationView = {
        let navView = MSNavigationView(frame: CGRect(x: 0, y: 0, width: UIScreen.width, height: UIScreen.status_navi_height))
        navView.leftButton.setImage(UIImage(named: "nav_back_white"), for: .normal)
        navView.rightButton.setImage(UIImage(named: "more_icon_white"), for: .normal)
        navView.leftButton.addTarget(self, action: #selector(navViewLeftDidClick), for: .touchUpInside)
        navView.rightButton.addTarget(self, action: #selector(navViewRightDidClick), for: .touchUpInside)
        return navView
    }()
    
    private var datas: [MSVideoModel] = []
    
    private var currentPlaingCell: MTVideoListCell?
    
    private var currentPlayIndex: Int?
    
    private var needToPlayAtIndex: Int = 0
    
    // 转场属性
    private let presentScaleAnimation: PresentScaleAnimation = PresentScaleAnimation()
    
    private let dismissScaleAnimation: DismissScaleAnimation = DismissScaleAnimation()
    
    private let dragInteractiveTransition: DragInteractiveTransition = DragInteractiveTransition()
    
    private let pushAnimation: PushAnimation = PushAnimation()

    // 播放器相关属性
    private var _player: AliListPlayer?
    private var player: AliListPlayer? {
        set {
           _player = newValue
        }
        get {
            if _player == nil {
                _player = createPlayer()
            }
            return _player
        }
    }
    
    private var _playView: UIView?
    private var playView: UIView? {
        set {
            _playView = newValue
        }
        get {
            if _playView == nil {
                _playView = createPlayView()
            }
            return _playView
        }
    }
    
    var duration: Int {
        return Int(self.player?.duration ?? 0)
    }
    
    private var playList: [MSVideoModel] = []
    
    private(set) var currentPlayingIndex: Int = 0
    
    private(set) var isPlaying: Bool = false // 是否正在播放
    
    private var needToAutoResume: Bool = false  //用于记录返回前台时是否要自动恢复播放
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fd_prefersNavigationBarHidden = true
        view.backgroundColor = .black
        view.addSubview(collectionView)
        view.addSubview(navView)

        self.collectionView.setContentOffset(CGPoint(x: 0, y: Int(UIScreen.height) * self.needToPlayAtIndex), animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.startPlayVideo(index: self.needToPlayAtIndex)
        }
        addNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.needToPlayOrPause(pause: false)
        self.dragInteractiveTransition.dragPushEnable = true
        self.dragInteractiveTransition.dragDismissEnable = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.needToPlayOrPause(pause: true)
        self.dragInteractiveTransition.dragPushEnable = false
        self.dragInteractiveTransition.dragDismissEnable = false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        self.videoStop()
        self.cleanList()
        self.videoDestroy()
    }
    
    func show(fromVC: UIViewController,startView: UIView) {
        let nav = BFNavigationController(rootViewController: self)
        nav.transitioningDelegate = self
        nav.modalPresentationStyle = .custom
        let startFrame = startView.superview!.convert(startView.frame, to: nil)
        self.presentScaleAnimation.startFrame = startFrame
        self.presentScaleAnimation.startView = startView
        self.dismissScaleAnimation.endView = startView
        self.dismissScaleAnimation.endFrame = startFrame
        
        fromVC.modalPresentationStyle = .custom
        self.dragInteractiveTransition.wireToViewController(vc: nav)
        self.dragInteractiveTransition.pushVCType = MTTestController.self as UIViewController.Type
        fromVC.present(nav, animated: true, completion: nil)
    }
    
    func reloadVideos(datas: [MSVideoModel],playAtIndex: Int) {
        self.datas.append(contentsOf: datas)
        self.needToPlayAtIndex = playAtIndex
        self.addVideoSource(arr: datas)
        collectionView.reloadData()
    }
    
    private func startPlayVideo(index: Int) {
        
        self.currentPlaingCell?.updateProgress(progress: 0)
        self.playView?.isHidden = true
        self.playView?.removeFromSuperview()
        self.playView = nil
        self.currentPlaingCell = nil

        self.currentPlaingCell = self.collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? MTVideoListCell
        // 重新播放
        if let cell = self.currentPlaingCell {
            self.currentPlayIndex = index
            self.player?.playerView = self.playView
            cell.contentView.insertSubview(self.playView!, aboveSubview: cell.bgImageView)
            self.moveToPlay(atIndex: index)
        }
    }
    
    @objc private func navViewLeftDidClick() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func navViewRightDidClick() {
        let sheetVC = UIAlertController(title: nil, message: self.videoInfo(), preferredStyle: .actionSheet)
        sheetVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(sheetVC, animated: true, completion: nil)
    }
    
    private func addNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationEnterBackground), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
}

extension MSVideoPlayController: UICollectionViewDataSource,UICollectionViewDelegate {
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "videoCell", for: indexPath) as! MTVideoListCell
        cell.reloadData(model: datas[indexPath.row])
        cell.delegate = self
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let currentIndex = Int(offsetY / UIScreen.height)
//        print("index: %zd",currentIndex)
        
        if self.currentPlayIndex != currentIndex {
            self.playView?.isHidden = true
            self.startPlayVideo(index: currentIndex)
            if let resouceView = self.resourceViewProvider?(currentIndex) {
                let endFrame = resouceView.superview!.convert(resouceView.frame, to: nil)
                self.dismissScaleAnimation.endView = resouceView
                self.dismissScaleAnimation.endView?.alpha = 0
                self.dismissScaleAnimation.endFrame = endFrame
            }else {
                self.dismissScaleAnimation.endFrame = .zero
                self.dismissScaleAnimation.endView = nil
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
}

//MARK: - 播放器内部回调
extension MSVideoPlayController: AVPDelegate {
    
    func onError(_ player: AliPlayer!, errorModel: AVPErrorModel!) {
        print("视频播放错误: \(String(describing: errorModel.message))")
        self.playerStatusChaned(to: .error)
    }

    func onPlayerEvent(_ player: AliPlayer!, eventType: AVPEventType) {
        var type: MTVideoPlayerStatus = .unload
        switch eventType {
            case AVPEventPrepareDone:  // 准备完成
                self.isPlaying = true
                break
            case AVPEventAutoPlayStart:  // 自动播放开始事件
                self.isPlaying = true
                type = .autoPlayStart
                break
            case AVPEventFirstRenderedStart:  // 首帧显示
                self.isPlaying = true
                type = .firstRenderedStart
                break
            case AVPEventCompletion:  // 播放完成
                self.isPlaying = false
                type = .ended
                break
            case AVPEventLoadingStart:  // 缓冲开始
                type = .loadingStart
                break
            case AVPEventLoadingEnd:  // 缓冲完成
                type = .loadingEnd
                break
            case AVPEventSeekEnd:  // 跳转完成
                self.isPlaying = true
                type = .seekEnd
                break
            case AVPEventLoopingStart:  // 循环播放开始
                self.isPlaying = true
                type = .loopingStart
                break
            default:
                break
        }
        self.playerStatusChaned(to: type)
    }
    
    //视频当前播放位置回调
    func onCurrentPositionUpdate(_ player: AliPlayer!, position: Int64) {
        let progress = Float(position) / Float(self.duration)
        self.currentPlaingCell?.updateProgress(progress: progress)
    }
    
    //视频缓存位置回调
    func onBufferedPositionUpdate(_ player: AliPlayer!, position: Int64) {
        
    }
    
    //获取track信息回调
    func onTrackReady(_ player: AliPlayer!, info: [AVPTrackInfo]!) {
//        let mediaInfo = player.getMediaInfo()
//        if mediaInfo?.thumbnails != nil && mediaInfo?.thumbnails.count > 0 {
//
//        }
    }
    
    func onPlayerEvent(_ player: AliPlayer!, eventWithString: AVPEventWithString, description: String!) {
        if eventWithString == EVENT_PLAYER_CACHE_SUCCESS {
            print("缓存成功事件")
        }else if eventWithString == EVENT_PLAYER_CACHE_ERROR {
            print("缓存失败事件")
        }
    }
    
    //获取缩略图成功回调
    func onGetThumbnailSuc(_ positionMs: Int64, fromPos: Int64, toPos: Int64, image: Any!) {
//        if let thumbnail = image as? UIImage {
//            delegate?.onGetThumbnailImage(positionMs: Int(positionMs), image: thumbnail)
//        }
    }
}

//MARK: - 播放逻辑处理
extension MSVideoPlayController {
    
    private func createPlayer() -> AliListPlayer? {
        let player = AliListPlayer.init()!
        player.preloadCount = 2
        player.isAutoPlay = true
        player.delegate = self
        player.isLoop = true
        player.scalingMode = AVP_SCALINGMODE_SCALEASPECTFIT
        player.enableHardwareDecoder = true
        player.stsPreloadDefinition = "FD"
        let config = AVPConfig()
        config.startBufferDuration = 250  //起播缓冲区时长。单位ms
        config.enableLocalCache = true
        player.setConfig(config)
        //本地缓存
        let cacheConfig = AVPCacheConfig()
        cacheConfig.enable = true
        cacheConfig.maxDuration = 100
        cacheConfig.path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last!
        cacheConfig.maxSizeMB = 200
        player.setCacheConfig(cacheConfig)
        return player
    }
    
    private func createPlayView() -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        view.frame = UIScreen.main.bounds
        view.isHidden = true
        return view
    }
    
    private func playerStatusChaned(to: MTVideoPlayerStatus) {
        self.currentPlaingCell?.playStatusChanged(to: to)
        if to == .autoPlayStart {
            print("***playerStatusChaned : autoPlayStart")
        }else if to == .loadingStart {
            print("***playerStatusChaned : loadingStart")
        }else if to == .loadingEnd {
            print("***playerStatusChaned : loadingEnd")
        }else if to == .firstRenderedStart {
            print("***playerStatusChaned : firstRenderedStart")
            self.playView?.isHidden = false
        }else if to == .ended {
            print("***playerStatusChaned : ended")
        }else if to == .seekEnd {
            print("***playerStatusChaned : seekEnd")
        }else if to == .loopingStart {
            print("***playerStatusChaned : loopingStart")
        }else if to == .paused {
            print("***playerStatusChaned : paused")
        }else if to == .error {
            print("***playerStatusChaned : error")
        }else if to == .unload {
            print("***playerStatusChaned : unload")
        }
    }
    
    func addVideoSource(arr: [MSVideoModel]) {
        //去重
        for model in arr {
            if self.playList.contains(where: { $0.video_id == model.video_id}) == false {
                self.playList.append(model)
                self.player?.addUrlSource(model.url, uid: model.video_id)
            }
        }
    }
    
    func cleanList() {
        self.player?.clear()
        self.playList.removeAll()
        self.currentPlayingIndex = 0
        self.isPlaying = false
        self.needToAutoResume = false
    }
    
    func removeSource(model: MSVideoModel) {
        self.player?.removeSource(model.video_id)
        if let index = self.playList.firstIndex(where: { $0.video_id == model.video_id}) {
            self.player?.removeSource(model.video_id)
            self.playList.remove(at: index)
        }
    }
    
    func moveToPlay(atIndex: Int) {
        if atIndex < self.playList.count {
            self.player?.move(to: self.playList[atIndex].video_id)
            self.currentPlayingIndex = atIndex
        }
    }

    func moveToNext() {
        if self.currentPlayingIndex + 1 < self.playList.count {
            self.player?.moveToNext()
            self.currentPlayingIndex += 1
        }
    }
    
    func moveToPre() {
        if self.currentPlayingIndex - 1 >= 0 {
            self.player?.moveToPre()
            self.currentPlayingIndex -= 1
        }
    }
    
    func videoPause() {
        self.isPlaying = false
        self.player?.pause()
    }
    
    func videoResume() {
        self.isPlaying = true
        self.player?.start()
    }
    
    func videoStop() {
        self.isPlaying = false
        self.player?.stop()
    }
    
    func videoDestroy() {
        self.playView?.removeFromSuperview()
        self.playView = nil
        self.player?.destroy()
        self.player = nil
    }
    
    func videoSeek(progress: Float) {
        self.player?.seek(toTime: Int64(Float(self.duration) * progress), seekMode: AVP_SEEKMODE_ACCURATE)
    }
    
    
    func videoInfo() -> String {
        if let info = self.player?.getCurrentTrack(AVPTRACK_TYPE_VIDEO) {
            return "duration: \(self.duration/1000)s\n Bitrate: \(String.init(format: "%.1f", Float(info.trackBitrate)/1024/1024))Mbps\n width: \(info.videoWidth) \n height: \(info.videoHeight) \n "
        }
        return ""
    }
    
    @objc private func applicationEnterBackground() {
        if self.isPlaying {
            self.needToAutoResume = true
        }else {
            self.needToAutoResume = false
        }
        self.videoPause()
        self.player?.isAutoPlay = false
        self.playerStatusChaned(to: .paused)
    }
    
    @objc private func applicationDidBecomeActive() {
        if self.needToAutoResume {
            self.videoResume()
            self.playerStatusChaned(to: .autoPlayStart)
        }
        self.player?.isAutoPlay = true
    }
}

//MARK: - videoCell 的回调事件
extension MSVideoPlayController: MSVideoListCellDelegate {
    
    func needToSeek(to progress: Float) {
        self.videoSeek(progress: progress)
    }
    
    func needToPlayOrPause(pause: Bool) {
        if pause {
            self.videoPause()
        }else {
            self.videoResume()
        }
    }
    
    func needToStopScroll(stop: Bool) {
        collectionView.isScrollEnabled = !stop
    }
}

//MARK: - present 转场动画
extension MSVideoPlayController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.presentScaleAnimation
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.dismissScaleAnimation
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.dragInteractiveTransition.isDismissInteracting ? self.dragInteractiveTransition : nil
    }
}

//MARK: -push 转场动画
extension MSVideoPlayController {
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {

        if animationController.isKind(of: PushAnimation.self) {
            return self.dragInteractiveTransition.isPushInteracting ? self.dragInteractiveTransition : nil
        }
        return nil
    }

    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            return self.pushAnimation
        }
        return nil
    }
}
