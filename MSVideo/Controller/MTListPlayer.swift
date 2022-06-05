//
//  MTListPlayer.swift
//  MSVideo
//
//  Created by 王方芳 on 2022/6/4.
//

import UIKit
import AliyunPlayer


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

class MTListPlayer: NSObject {
    
    private var player: AliListPlayer?
    
    private(set) var playView: UIView?
    
    var duration: Int {
        return Int(player?.duration ?? 0)
    }
    
    private var needToAutoResume: Bool = false
    
    private(set) var isPlaying: Bool = false
    
    private(set) var playList: [MSVideoModel] = []
    
    private(set) var currentPlayingIndex: Int = 0
    
    private var currentPlaingCell: MTVideoListCell?
    
    override init() {
        super.init()
        player = createPlayer()
        playView = createPlayView()
        NotificationCenter.default.addObserver(self, selector: #selector(applicationEnterBackground), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    deinit {
        print("MTListPlayer dealloc")
        NotificationCenter.default.removeObserver(self)
        videoStop()
        cleanList()
        videoDestroy()
    }
    
    //添加播放源
    func addVideoResource(datas: [MSVideoModel]) {
        for model in datas {
            playList.append(model)
            let videoID = UUID().uuidString
            model.identifer = videoID
            player?.addUrlSource(model.url, uid: videoID)
        }
    }
    
    func startPlayVideo(index: Int,in cell: MTVideoListCell) {
        
        currentPlaingCell?.updateProgress(progress: 0)
        playView?.removeFromSuperview()
        playView?.isHidden = true
        currentPlaingCell = nil

        self.currentPlaingCell = cell
        currentPlayingIndex = index
        cell.contentView.insertSubview(playView!, aboveSubview: cell.bgImageView)
        playView?.frame = cell.bgImageView.bounds
        player?.playerView = playView
        moveToPlay(atIndex: index)
    }
}

extension MTListPlayer {
    
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
        player.setConfig(config)
        return player
    }
    
    private func createPlayView() -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        view.isHidden = true
        return view
    }
    
    private func playerStatusChaned(to: MTVideoPlayerStatus) {
        currentPlaingCell?.playStatusChanged(to: to)
        if to == .autoPlayStart {
            print("***playerStatusChaned : autoPlayStart")
        }else if to == .loadingStart {
            print("***playerStatusChaned : loadingStart")
        }else if to == .loadingEnd {
            print("***playerStatusChaned : loadingEnd")
        }else if to == .firstRenderedStart {
            print("***playerStatusChaned : firstRenderedStart")
            playView?.isHidden = false
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
    
    func cleanList() {
        player?.clear()
        playList.removeAll()
        currentPlayingIndex = 0
        isPlaying = false
        needToAutoResume = false
    }
    
    private func moveToPlay(atIndex: Int) {
        if atIndex < playList.count {
            player?.move(to: playList[atIndex].identifer)
        }
        isPlaying = true
    }
    
    func videoPause() {
        isPlaying = false
        player?.pause()
    }
    
    func videoResume() {
        isPlaying = true
        player?.start()
    }
    
    func videoStop() {
        isPlaying = false
        player?.stop()
    }
    
    func videoDestroy() {
        isPlaying = false
        playView?.removeFromSuperview()
        playView = nil
        player?.destroy()
        player = nil
    }
    
    func videoSeek(progress: Float) {
        player?.seek(toTime: Int64(Float(duration) * progress), seekMode: AVP_SEEKMODE_ACCURATE)
    }
    
    
    func videoInfo() -> String {
        if let info = player?.getCurrentTrack(AVPTRACK_TYPE_VIDEO) {
            return "duration: \(duration/1000)s\n Bitrate: \(String.init(format: "%.1f", Float(info.trackBitrate)/1024/1024))Mbps\n width: \(info.videoWidth) \n height: \(info.videoHeight) \n "
        }
        return ""
    }
    
    @objc private func applicationEnterBackground() {
        if isPlaying {
            needToAutoResume = true
        }else {
            needToAutoResume = false
        }
        videoPause()
        player?.isAutoPlay = false
        playerStatusChaned(to: .paused)
    }
    
    @objc private func applicationDidBecomeActive() {
        if needToAutoResume {
            videoResume()
            playerStatusChaned(to: .autoPlayStart)
        }
        player?.isAutoPlay = true
    }
}

//MARK: - 播放器内部回调
extension MTListPlayer: AVPDelegate {
    func onError(_ player: AliPlayer!, errorModel: AVPErrorModel!) {
        print("视频播放错误: \(String(describing: errorModel.message))")
        playerStatusChaned(to: .error)
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
        self.playerStatusChaned(to: type)
    }
    
    //视频当前播放位置回调
    func onCurrentPositionUpdate(_ player: AliPlayer!, position: Int64) {
        let progress = Float(position) / Float(self.duration)
        currentPlaingCell?.updateProgress(progress: progress)
    }
}
