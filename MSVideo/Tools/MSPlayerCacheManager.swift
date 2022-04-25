//
//  MSPlayerCacheManager.swift
//  MSVideo
//
//  Created by MoliySDev on 2022/4/25.
//

import Foundation


class MSPlayerCacheManager: NSObject {
    
    static let shareInstace = MSPlayerCacheManager()
    
    private override init() {}
    
    var playerCacheCount: Int = 0
    
    private var playerCacheDic: [String: MSVideoPlayer] = [:]
    
    private var currentModel: MSVideoModel?
    
    func getVideoPlayer(model: MSVideoModel) -> MSVideoPlayer? {
        var player: MSVideoPlayer?
        if let value = playerCacheDic[model.streamingInfo.plainOutput.url] {
            player = value
        }else {
            if playerCacheDic.count >= playerCacheCount {
                for (key,value) in playerCacheDic {
                    if key != currentModel?.streamingInfo.plainOutput.url {
                        value.preparePlayVideo(model: model)
                        player = value
                        playerCacheDic.removeValue(forKey: key)
                        playerCacheDic[model.streamingInfo.plainOutput.url] = player
                        break
                    }
                }
            }else {
                player = MSVideoPlayer()
                player?.isAutoPlay = false
                player?.preparePlayVideo(model: model)
                playerCacheDic[model.streamingInfo.plainOutput.url] = player
            }
        }
        currentModel = model
        return player
    }
    
    func updatePlayerCache(models: [MSVideoModel]) {
        if models.count == 0 {return}
        
        if playerCacheDic.count <= 0 {
            for model in models {
                let player = MSVideoPlayer()
                player.preparePlayVideo(model: model)
                playerCacheDic[model.streamingInfo.plainOutput.url] = player
            }
            return
        }
        var urlArr: [String] = models.compactMap { model in
            return model.streamingInfo.plainOutput.url
        }
        var exprUrls: [String] = []
        
        for key in playerCacheDic.keys {
            if let index = urlArr.firstIndex(of: key) {
                urlArr.remove(at: index)
            }else {
                exprUrls.append(key)
            }
        }
        // 替换字典中过期的数据，没有可替换的则创建新的播放器对象
        for url in urlArr {
            var tempPlayer: MSVideoPlayer?
            if exprUrls.count > 0 {
                let firstUrl = exprUrls.first!
                tempPlayer = playerCacheDic[firstUrl]
                playerCacheDic.removeValue(forKey: firstUrl)
                exprUrls.removeAll(where: {$0 == firstUrl})
            }
            if tempPlayer == nil {
                tempPlayer = MSVideoPlayer()
                tempPlayer?.isAutoPlay = false
            }
            playerCacheDic[url] = tempPlayer!
            
            for model in models {
                if model.streamingInfo.plainOutput.url == url {
                    tempPlayer?.preparePlayVideo(model: model)
                    break
                }
            }
        }
        // 如果淘汰的数据不为空
        if exprUrls.count > 0 {
            for exrUrl in exprUrls {
                var exprPlayer = playerCacheDic[exrUrl]
                playerCacheDic.removeValue(forKey: exrUrl)
                exprPlayer?.removeVideo()
                exprPlayer = nil
            }
        }
        // 滑出的时候会把上一个播放的视频stop掉，所以在这里需要重新预加载，不然滑到上个视频会不播放
        if let url = currentModel?.streamingInfo.plainOutput.url,let curPlayer = playerCacheDic[url] {
            curPlayer.preparePlayVideo(model: currentModel!)
        }
    }
    
    func removeAllCache() {
        for (url) in playerCacheDic.keys {
            var player = playerCacheDic[url]
            player?.removeVideo()
            player = nil
            playerCacheDic.removeValue(forKey: url)
        }
        self.currentModel = nil
    }
}
