//
//  MSVideoPlayer.swift
//  MSVideo
//
//  Created by 王方芳 on 2022/4/23.
//

import Foundation
import UIKit
import TXLiteAVSDK_Professional


enum MSVideoPlayerStatus {
    case unload // 未加载
    case prepared // 准备播放
    case loading // 加载中
    case playing // 播放中
    case paused // 暂停
    case ended // 播放完成
    case error // 错误
}

protocol MSVideoPlayerDelegate: NSObjectProtocol {
    
    func playerStatusChaned(player: MSVideoPlayer,to: MSVideoPlayerStatus)
    
    func playerProgressChanged(player: MSVideoPlayer,currentT: Float,totalT: Float,progress: Float)
}

class MSVideoPlayer: NSObject {
    
    weak var delegate: MSVideoPlayerDelegate?
    
    var status: MSVideoPlayerStatus?
    
    var isPlaying: Bool {
        return player.isPlaying()
    }
    
    var loop: Bool = false {
        didSet {
            player.loop = loop
        }
    }
    
    var isAutoPlay: Bool = false {
        didSet {
            player.isAutoPlay = isAutoPlay
        }
    }
    
    /**
     * 当播放地址为master playlist，返回支持的码率（清晰度）
     *
     * @warning 在收到EVT_VIDEO_PLAY_BEGIN事件后才能正确返回结果
     * @return 无多码率返回空数组
     */
    var supportedBitrates: [TXBitrateItem] {
        return player.supportedBitrates()
    }
    
    /**
     * 设置当前正在播放的码率索引，无缝切换清晰度
     *  清晰度切换可能需要等待一小段时间。腾讯云支持多码率HLS分片对齐，保证最佳体验。
     *
     * @param index 码率索引，index == -1，表示开启HLS码流自适应；index > 0 （可从supportedBitrates获取），表示手动切换到对应清晰度码率
     */
    var bitrateIndex: Int = 0 {
        didSet {
            player.setBitrateIndex(bitrateIndex)
        }
    }
    
    //预加载
    func preparePlayVideo(model: MSVideoModel) {
        
        isPrepared = false
        removeVideo()
        player.isAutoPlay = false
        startPlay(url: model.streamingInfo.plainOutput.url)
        player.setBitrateIndex(model.basicInfo.bitrateIndex)
    }
    
    //根据指定url在指定视图上播放视频
    
    func playVideo(in playView: UIView,url videoUrl: String) {
        
        player.setupVideoWidget(playView, insert: 0)
        if player.isAutoPlay {
            player.startPlay(videoUrl)
        }else {
            resumePlay()
        }
    }
    
    //停止播放并移除播放视图
    
    func removeVideo() {
        player.stopPlay()
        player.removeVideoWidget()
        playerStatusChange(status: .unload)
    }
    
    //暂停播放
    
    func pausePlay() {
        player.pause()
        playerStatusChange(status: .paused)
    }
    
    //恢复播放
    
    func resumePlay() {
        if status == .paused || status == .prepared || status == .loading {
            player.resume()
            playerStatusChange(status: .playing)
        }else {
            isPrepared = true
        }
    }
    
    //开始播放
    
    func startPlay(url: String) {
        player.startPlay(url)
    }
    
    //播放跳转到某个时间
    
    func seekToTime(time: Float) {
        player.seek(time)
    }
    
    //应用进入前台处理
    
    func detailAppWillEnterForeground() {
        if isNeedResume && status == .paused {
            isNeedResume = false
            try? AVAudioSession.sharedInstance().setCategory(.playback)
            try? AVAudioSession.sharedInstance().setActive(true, options: [])
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {[weak self] in
                guard let `self` = self else{return}
                self.resumePlay()
            }
        }
    }
    
    //应用退到后台处理
    
    func detailAppDidEnterBackground() {
        if status == .loading || status == .playing || status == .prepared {
            pausePlay()
            isNeedResume = true
        }
    }
    
    
    private lazy var player: TXVodPlayer = {
        let player = TXVodPlayer()
        player.enableHWAcceleration = true
        player.vodDelegate = self
        let config = TXVodPlayConfig()
        config.maxBufferSize = 3
        config.smoothSwitchBitrate = false
        player.config = config
        player.setRenderMode(.RENDER_MODE_FILL_SCREEN)
        return player
    }()
    
    private var duration: Float = 0
    
    private var isNeedResume: Bool = false
    
    private var isPrepared: Bool = false
    
    override init() {
        super.init()
        
    }
    
    private func playerStatusChange(status: MSVideoPlayerStatus) {
        self.status = status
        self.delegate?.playerStatusChaned(player: self, to: status)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension MSVideoPlayer: TXVodPlayListener {
    func onPlayEvent(_ player: TXVodPlayer!, event EvtID: Int32, withParam param: [AnyHashable : Any]!) {
        switch EvtID {
                
            case PLAY_EVT_VOD_PLAY_PREPARED.rawValue:        //  视频加载完毕
                playerStatusChange(status: .prepared)
                if isPrepared {
                    player.resume()
                    isPrepared = false
                    playerStatusChange(status: .playing)
                }
            case PLAY_EVT_PLAY_LOADING.rawValue:        //  加载中
                if status == .paused {
                    playerStatusChange(status: .paused)
                }else {
                    playerStatusChange(status: .loading)
                }
            case PLAY_EVT_PLAY_PROGRESS.rawValue:        //  播放进度
                if let duration = param[EVT_PLAY_DURATION] as? Float {
                    self.duration = duration
                }
                if let currentT = param[EVT_PLAY_PROGRESS] as? Float {
                    let progress = self.duration == 0 ? 0 : currentT / self.duration
                    delegate?.playerProgressChanged(player: self, currentT: currentT, totalT: self.duration, progress: progress)
                }
            case PLAY_EVT_PLAY_END.rawValue:              //  播放结束
                delegate?.playerProgressChanged(player: self, currentT: self.duration, totalT: self.duration, progress: 1.0)
                playerStatusChange(status: .ended)
            case PLAY_ERR_NET_DISCONNECT.rawValue:        //  失败，多次重链无效
                playerStatusChange(status: .error)
            default:
                break
        }
    }
    
    func onNetStatus(_ player: TXVodPlayer!, withParam param: [AnyHashable : Any]!) {
        
    }
    
    
}
