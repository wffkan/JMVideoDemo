//
//  MSVideoPlayController.swift
//  MSVideo
//
//  Created by 王方芳 on 2022/4/23.
//

import Foundation
import UIKit


class MSVideoPlayController: BFBaseViewController {
    
    var uid: String?
    
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
        collectionView.backgroundColor = .clear
        collectionView.register(MSVideoListCell.self, forCellWithReuseIdentifier: "videoCell")
        return collectionView
    }()
    
    private var datas: [MSVideoModel] = []
    
    private var currentPlayer: MSVideoPlayer?
    
    private var currentPlaingCell: MSVideoListCell?
    
    private var currentPlayIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(collectionView)
        requestData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    deinit {
        
    }
    
    func requestData() {
        
        let viewModel = MSVideoViewModel()
        viewModel.refreshNewList { list in
            self.datas.append(contentsOf: list ?? [])
            self.collectionView.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.startPlayVideo(index: 0)
            }
            
        } fail: { error in
            
        }
    }
    
    private func startPlayVideo(index: Int) {
        
        if self.currentPlayIndex == index {return}
        //移除原来的播放
        self.currentPlayer?.removeVideo()
        self.currentPlaingCell?.updateProgress(progress: 0)
        
        self.currentPlaingCell = nil
        self.currentPlayer?.delegate = nil
        
        self.currentPlayIndex = index
        self.preloadOtherPlayers(fromIndex: self.currentPlayIndex!)
        self.getVideoPlayer(model: self.datas[index])
        
        self.currentPlaingCell = self.collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? MSVideoListCell
        // 重新播放
        if let cell = self.currentPlaingCell {
            self.currentPlayer?.playVideo(in: cell.playerView, url: cell.videoModel.streamingInfo.plainOutput.url)
        }
    }
    
    private func preloadOtherPlayers(fromIndex: Int,maxCount: Int = 3) {
        var preloads: [MSVideoModel] = []
        for i in 0..<maxCount {
            if fromIndex + 1 + i < self.datas.count {
                preloads.append(self.datas[fromIndex + 1 + i])
            }
        }
        MSPlayerCacheManager.shareInstace.updatePlayerCache(models: preloads)
    }
    
    private func getVideoPlayer(model: MSVideoModel) {
        self.currentPlayer = MSPlayerCacheManager.shareInstace.getVideoPlayer(model: model)
        self.currentPlayer?.delegate = self
    }
}

extension MSVideoPlayController: UICollectionViewDataSource,UICollectionViewDelegate {
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "videoCell", for: indexPath) as! MSVideoListCell
        cell.reloadData(model: datas[indexPath.row])
        return cell
    }

//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offsetY = scrollView.contentOffset.y
//        let currentIndex = offsetY / UIScreen.height
//        print("index: %zd",currentIndex)
//    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.startPlayVideo(index: indexPath.item)
    }
}

extension MSVideoPlayController: MSVideoPlayerDelegate {
    
    func playerStatusChaned(player: MSVideoPlayer,to: MSVideoPlayerStatus) {
        self.currentPlaingCell?.playStatusChanged(to: to)
    }
    
    func playerProgressChanged(player: MSVideoPlayer,currentT: Float,totalT: Float,progress: Float) {
        
    }
}
