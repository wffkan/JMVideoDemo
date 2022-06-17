//
//  TestSecondController.swift
//  MSVideo
//
//  Created by MoliySDev on 2022/6/17.
//

import UIKit
import AliyunPlayer


class TestSecondController: UIViewController {
    

    var player: AliListPlayer?
    
    var playView: UIView?
    
    lazy var videos: [MSVideoModel] = MSVideoUtils.testVideos()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        createPlayer()
        startPlay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        player?.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player?.pause()
    }
    
    deinit {
        print("TestSecondController dealloc")
        let before = Date().timeIntervalSince1970
        player?.stop()
        player?.destroy()
        player = nil
        let after = Date().timeIntervalSince1970
        print("耗时: \(after - before)")
    }
    
    private func createPlayer() {
        player = AliListPlayer.init()!
        player?.preloadCount = 2
        player?.isAutoPlay = true
        player?.delegate = self
        player?.isLoop = true
        player?.scalingMode = AVP_SCALINGMODE_SCALEASPECTFIT
        player?.enableHardwareDecoder = true
        let config = AVPConfig()
        config.startBufferDuration = 250  //起播缓冲区时长。单位ms
        config.enableLocalCache = false
        player?.setConfig(config)
    }
    
    private func startPlay() {

        for model in videos {
            let identifier = UUID().uuidString
            model.identifer = identifier
            player?.addUrlSource(model.url, uid: identifier)
        }
        playView = UIView(bgColor: .black)
        playView?.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: UIScreen.height)
        view.addSubview(playView!)
        player?.playerView = playView!
        player?.move(to: videos.first!.identifer)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension TestSecondController: AVPDelegate {
    func onError(_ player: AliPlayer!, errorModel: AVPErrorModel!) {
        print("视频播放错误: \(String(describing: errorModel.message))")
    }

    func onPlayerEvent(_ player: AliPlayer!, eventType: AVPEventType) {
//        print("\(eventType)")
    }
    
    //视频当前播放位置回调
    func onCurrentPositionUpdate(_ player: AliPlayer!, position: Int64) {
//        print("\(position)")
    }
    
}
