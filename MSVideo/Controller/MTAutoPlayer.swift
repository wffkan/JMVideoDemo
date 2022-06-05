//
//  MTAutoPlayer.swift
//  MSVideo
//
//  Created by 王方芳 on 2022/6/3.
//

import Foundation
import AliyunPlayer

struct MTVideoItem {
    var id: String
    var url: String
    var identifier: String?
}

protocol MTAutoPlayerDelegate: NSObjectProtocol {
    
    func cellWillPlay(item: MTVideoItem,cell: UIView)
    
    func cellDidEndPlay(item: MTVideoItem,cell: UIView)
    
    func playerProgressChanged(progress: Float)
    
    func playerStatusChaned(status: MTVideoPlayerStatus)
}

extension MTAutoPlayerDelegate {
    func cellWillPlay(item: MTVideoItem,cell: UIView) {}
    func cellDidEndPlay(item: MTVideoItem,cell: UIView) {}
    func playerProgressChanged(progress: Float) {}
    func playerStatusChaned(status: MTVideoPlayerStatus) {}
}

class MTAutoPlayer: NSObject {
    
    weak var delegate: MTAutoPlayerDelegate?
    
    var isMute: Bool = false {
        didSet {
            self.player?.isMuted = isMute
        }
    }
    
    private(set) var player: AliListPlayer?
    
    private(set) var playView: UIView?
    
    private var needToAutoResume: Bool = false
    
    private(set) var isPlaying: Bool = false
    
    var duration: Int {
        return Int(player?.duration ?? 0)
    }
    
    private(set) var currentPlayingItem: MTVideoItem?
    
    private(set) var currentPlayingView: UIView?
    
    private(set) var currentPlayingCell: UIView?
    
    override init() {
        super.init()
        player = createPlayer()
        playView = createPlayView()
        NotificationCenter.default.addObserver(self, selector: #selector(applicationEnterBackground), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        videoDestroy()
    }
    
    func startPlay(item: MTVideoItem,view: UIView,cell: UIView) {
        if currentPlayingItem != nil && currentPlayingItem?.id != item.id {
            delegate?.cellDidEndPlay(item: currentPlayingItem!, cell: currentPlayingCell!)
            videoStop()
        }
        currentPlayingItem = item
        currentPlayingCell = cell
        currentPlayingView = view
        let identifier = NSUUID().uuidString
        currentPlayingItem?.identifier = identifier
        player?.addUrlSource(item.url, uid: identifier)
        view.insertSubview(playView!, at: 0)
        playView?.frame = view.bounds
        playView?.isHidden = true
        player?.playerView = playView
        player?.move(to: identifier)
        isPlaying = true
        delegate?.cellWillPlay(item: item, cell: cell)
    }
    
    func cellDidEndDisplay(item: MTVideoItem,cell: UIView) {
        if currentPlayingItem?.id == item.id {
            delegate?.cellDidEndPlay(item: currentPlayingItem!, cell: currentPlayingCell!)
            videoStop()
            currentPlayingItem = nil
            currentPlayingCell = nil
            currentPlayingView = nil
        }
    }
    
    
}

extension MTAutoPlayer {
    private func createPlayView() -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        view.isHidden = true
        return view
    }
    
    private func createPlayer() -> AliListPlayer? {
        let player = AliListPlayer.init()!
        player.preloadCount = 2
        player.isAutoPlay = true
        player.delegate = self
        player.isLoop = true
        player.scalingMode = AVP_SCALINGMODE_SCALEASPECTFIT
        player.enableHardwareDecoder = true
        let config = AVPConfig()
        config.startBufferDuration = 250  //起播缓冲区时长。单位ms
        config.enableLocalCache = false
        config.clearShowWhenStop = true
        player.setConfig(config)
        return player
    }
    
    func clean() {
        player?.clear()
        needToAutoResume = false
        isPlaying = false
        currentPlayingItem = nil
    }
    
    func videoPause() {
        player?.pause()
        isPlaying = false
    }
    
    func videoResume() {
        player?.start()
        isPlaying = true
    }
    
    func videoStop() {
        player?.stop()
        isPlaying = false
        playView?.isHidden = true
    }
    
    func videoDestroy() {
        videoStop()
        playView?.removeFromSuperview()
        playView = nil
        player?.destroy()
        player = nil
    }
    
    func videoSeek(progress: Float) {
        player?.seek(toTime: Int64(Float(duration) * progress), seekMode: AVP_SEEKMODE_ACCURATE)
    }
    
    @objc private func applicationEnterBackground() {
        if isPlaying {
            needToAutoResume = true
        }else {
            needToAutoResume = false
        }
        videoPause()
        player?.isAutoPlay = false
        delegate?.playerStatusChaned(status: .paused)
    }
    
    @objc private func applicationDidBecomeActive() {
        if needToAutoResume {
            videoResume()
            delegate?.playerStatusChaned(status: .autoPlayStart)
        }
        player?.isAutoPlay = true
    }
}

//MARK: - 播放器内部回调
extension MTAutoPlayer: AVPDelegate {
    
    func onError(_ player: AliPlayer!, errorModel: AVPErrorModel!) {
        print("视频播放错误: \(String(describing: errorModel.message))")
        delegate?.playerStatusChaned(status: .error)
    }

    func onPlayerEvent(_ player: AliPlayer!, eventType: AVPEventType) {
        var type: MTVideoPlayerStatus = .unload
        switch eventType {
            case AVPEventPrepareDone:  // 准备完成
                break
            case AVPEventAutoPlayStart:  // 自动播放开始事件
                type = .autoPlayStart
                break
            case AVPEventFirstRenderedStart:  // 首帧显示
                type = .firstRenderedStart
            playView?.isHidden = false
                break
            case AVPEventCompletion:  // 播放完成
                type = .ended
                break
            case AVPEventLoadingStart:  // 缓冲开始
                type = .loadingStart
                break
            case AVPEventLoadingEnd:  // 缓冲完成
                type = .loadingEnd
                break
            case AVPEventSeekEnd:  // 跳转完成
                type = .seekEnd
                break
            case AVPEventLoopingStart:  // 循环播放开始
                type = .loopingStart
                break
            default:
                break
        }
        delegate?.playerStatusChaned(status: type)
    }
    
    //视频当前播放位置回调
    func onCurrentPositionUpdate(_ player: AliPlayer!, position: Int64) {
        let progress = Float(position) / Float(self.duration)
        delegate?.playerProgressChanged(progress: progress)
    }
}
