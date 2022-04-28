//
//  MSVideoPlayer.swift
//  MSVideo
//
//  Created by 王方芳 on 2022/4/23.
//

import Foundation
import UIKit
import AliyunPlayer


enum MSVideoPlayerStatus {
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

let MSVideoPlayerManager = MSVideoPlayer.shareInstance
protocol MSVideoPlayerDelegate: NSObjectProtocol {
    
    func playerStatusChaned(player: MSVideoPlayer,to: MSVideoPlayerStatus)
    
    func playerProgressChanged(player: MSVideoPlayer,currentT: Float,totalT: Float,progress: Float)
}

class MSVideoPlayer: NSObject {
    
    weak var delegate: MSVideoPlayerDelegate?
    
    static let shareInstance: MSVideoPlayer = MSVideoPlayer()
    
    private override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(applicationEnterBackground), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    lazy private var player: AliListPlayer = {
        let player = self.createPlayer()
        return player
    }()
    
    lazy var playView: MSPlayView = {
        let view = MSPlayView()
        view.backgroundColor = .clear
        view.frame = UIScreen.main.bounds
        view.isHidden = true
        return view
    }()
    
    var duration: Int {
        return Int(self.player.duration)
    }
    
    private var playList: [MSVideoModel] = []
    
    private(set) var currentPlayingIndex: Int = 0
    
    private(set) var isPlaying: Bool = false // 是否正在播放
    
    private var needToAutoResume: Bool = false  //用于记录返回前台时是否要自动恢复播放
    
    private func createPlayer() -> AliListPlayer {
        let player = AliListPlayer.init()!
        player.preloadCount = 2
        player.isAutoPlay = true
        player.delegate = self
        player.isLoop = true
        player.scalingMode = AVP_SCALINGMODE_SCALEASPECTFIT
        player.enableHardwareDecoder = true
        player.stsPreloadDefinition = "FD"
        player.playerView = self.playView
        let config = AVPConfig()
        config.startBufferDuration = 250  //起播缓冲区时长。单位ms
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
    
    func changePlayView(to view: UIView) {
        self.player.playerView = view
    }
    
    func addVideoSource(arr: [MSVideoModel]) {
        //去重
        for model in arr {
            if self.playList.contains(where: { $0.video_id == model.video_id}) == false {
                self.playList.append(model)
                self.player.addUrlSource(model.url, uid: model.video_id)
            }
        }
    }
    
    func cleanList() {
        self.player.clear()
        self.playList.removeAll()
        self.currentPlayingIndex = 0
        self.isPlaying = false
        self.needToAutoResume = false
    }
    
    func removeSource(model: MSVideoModel) {
        self.player.removeSource(model.video_id)
        if let index = self.playList.firstIndex(where: { $0.video_id == model.video_id}) {
            self.player.removeSource(model.video_id)
            self.playList.remove(at: index)
        }
    }
    
    func moveToPlay(atIndex: Int) {
        if atIndex < self.playList.count {
            self.player.move(to: self.playList[atIndex].video_id)
            self.currentPlayingIndex = atIndex
        }
    }

    func moveToNext() {
        if self.currentPlayingIndex + 1 < self.playList.count {
            self.player.moveToNext()
            self.currentPlayingIndex += 1
        }
    }
    
    func moveToPre() {
        if self.currentPlayingIndex - 1 >= 0 {
            self.player.moveToPre()
            self.currentPlayingIndex -= 1
        }
    }
    
    func videoPause() {
        self.isPlaying = false
        self.player.pause()
    }
    
    func videoResume() {
        self.isPlaying = true
        self.player.start()
    }
    
    func videoStop() {
        self.isPlaying = false
        self.player.stop()
    }
    
    func videoDestroy() {
        self.playView.removeFromSuperview()
        self.player.destroy()
        self.player = self.createPlayer()
    }
    
    func videoSeek(progress: Float) {
        self.player.seek(toTime: Int64(Float(self.player.duration) * progress), seekMode: AVP_SEEKMODE_ACCURATE)
    }
    
    func videoInfo() -> String {
        if let info = self.player.getCurrentTrack(AVPTRACK_TYPE_VIDEO) {
            return "duration: \(player.duration/1000)s\n Bitrate: \(String.init(format: "%.1f", Float(info.trackBitrate)/1024/1024))Mbps\n width: \(info.videoWidth) \n height: \(info.videoHeight) \n "
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
        self.player.isAutoPlay = false
        self.delegate?.playerStatusChaned(player: self, to: .paused)
    }
    
    @objc private func applicationDidBecomeActive() {
        if self.needToAutoResume {
            self.videoResume()
            self.delegate?.playerStatusChaned(player: self, to: .autoPlayStart)
        }
        self.player.isAutoPlay = true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension MSVideoPlayer: AVPDelegate {
    
    func onError(_ player: AliPlayer!, errorModel: AVPErrorModel!) {
        print("视频播放错误: \(String(describing: errorModel.message))")
        self.delegate?.playerStatusChaned(player: self, to: .error)
    }

    func onPlayerEvent(_ player: AliPlayer!, eventType: AVPEventType) {
        switch eventType {
            case AVPEventPrepareDone:  // 准备完成
                self.isPlaying = true
                break
            case AVPEventAutoPlayStart:  // 自动播放开始事件
                self.isPlaying = true
                self.delegate?.playerStatusChaned(player: self, to: .autoPlayStart)
                break
            case AVPEventFirstRenderedStart:  // 首帧显示
                self.isPlaying = true
                self.delegate?.playerStatusChaned(player: self, to: .firstRenderedStart)
                break
            case AVPEventCompletion:  // 播放完成
                self.isPlaying = false
                self.delegate?.playerStatusChaned(player: self, to: .ended)
                break
            case AVPEventLoadingStart:  // 缓冲开始
                self.delegate?.playerStatusChaned(player: self, to: .loadingStart)
                break
            case AVPEventLoadingEnd:  // 缓冲完成
                self.delegate?.playerStatusChaned(player: self, to: .loadingEnd)
                break
            case AVPEventSeekEnd:  // 跳转完成
                self.isPlaying = true
                self.delegate?.playerStatusChaned(player: self, to: .seekEnd)
                break
            case AVPEventLoopingStart:  // 循环播放开始
                self.isPlaying = true
                self.delegate?.playerStatusChaned(player: self, to: .loopingStart)
                break
            default:
                break
        }
    }
    
    //视频当前播放位置回调
    func onCurrentPositionUpdate(_ player: AliPlayer!, position: Int64) {
        self.delegate?.playerProgressChanged(player: self, currentT: Float(position), totalT: Float(self.duration), progress: Float(position) / Float(self.duration))
    }
    
    //视频缓存位置回调
    func onBufferedPositionUpdate(_ player: AliPlayer!, position: Int64) {
        
    }
    
    //获取track信息回调
    func onTrackReady(_ player: AliPlayer!, info: [AVPTrackInfo]!) {
        
    }
    
    func onPlayerEvent(_ player: AliPlayer!, eventWithString: AVPEventWithString, description: String!) {
        if eventWithString == EVENT_PLAYER_CACHE_SUCCESS {
            print("缓存成功事件")
        }else if eventWithString == EVENT_PLAYER_CACHE_ERROR {
            print("缓存失败事件")
        }
    }
}
