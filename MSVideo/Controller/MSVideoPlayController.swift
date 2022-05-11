//
//  MSVideoPlayController.swift
//  MSVideo
//
//  Created by 王方芳 on 2022/4/23.
//

import Foundation
import UIKit


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
    
    private let presentScaleAnimation: PresentScaleAnimation = PresentScaleAnimation()
    
    private let dismissScaleAnimation: DismissScaleAnimation = DismissScaleAnimation()
    
    private let dragInteractiveTransition: DragInteractiveTransition = DragInteractiveTransition()
    
    private let pushAnimation: PushAnimation = PushAnimation()
    
    private let popAnimation: PopAnimation = PopAnimation()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(collectionView)
        view.addSubview(navView)

        self.collectionView.setContentOffset(CGPoint(x: 0, y: Int(UIScreen.height) * self.needToPlayAtIndex), animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.startPlayVideo(index: self.needToPlayAtIndex)
        }
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
        MSVideoPlayerManager.videoStop()
        MSVideoPlayerManager.delegate = nil
        MSVideoPlayerManager.cleanList()
        MSVideoPlayerManager.videoDestroy()
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
        MSVideoPlayerManager.addVideoSource(arr: datas)
        collectionView.reloadData()
    }
    
    private func startPlayVideo(index: Int) {
        
        self.currentPlaingCell?.updateProgress(progress: 0)
        MSVideoPlayerManager.playView.isHidden = true
        MSVideoPlayerManager.playView.removeFromSuperview()
        self.currentPlaingCell = nil
        MSVideoPlayerManager.delegate = self

        self.currentPlaingCell = self.collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? MTVideoListCell
        // 重新播放
        if let cell = self.currentPlaingCell {
            self.currentPlayIndex = index
            cell.contentView.insertSubview(MSVideoPlayerManager.playView, aboveSubview: cell.bgImageView)
            MSVideoPlayerManager.moveToPlay(atIndex: index)
        }
    }
    
    @objc private func navViewLeftDidClick() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func navViewRightDidClick() {
        let sheetVC = UIAlertController(title: nil, message: MSVideoPlayerManager.videoInfo(), preferredStyle: .actionSheet)
        sheetVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(sheetVC, animated: true, completion: nil)
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
            MSVideoPlayerManager.playView.isHidden = true
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

extension MSVideoPlayController: MSVideoPlayerDelegate {
    
    func playerStatusChaned(player: MSVideoPlayer,to: MSVideoPlayerStatus) {
        self.currentPlaingCell?.playStatusChanged(to: to)
        if to == .autoPlayStart {
            print("***playerStatusChaned : autoPlayStart")
        }else if to == .loadingStart {
            print("***playerStatusChaned : loadingStart")
        }else if to == .loadingEnd {
            print("***playerStatusChaned : loadingEnd")
        }else if to == .firstRenderedStart {
            print("***playerStatusChaned : firstRenderedStart")
            MSVideoPlayerManager.playView.isHidden = false
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
    
    func playerProgressChanged(player: MSVideoPlayer,currentT: Float,totalT: Float,progress: Float) {
//        print("currentT: \(currentT),totalT: \(totalT),progress: \(progress)")
        self.currentPlaingCell?.updateProgress(progress: progress)
    }
}

extension MSVideoPlayController: MSVideoListCellDelegate {
    
    func needToSeek(to progress: Float) {
        MSVideoPlayerManager.videoSeek(progress: progress)
    }
    
    func needToPlayOrPause(pause: Bool) {
        if pause {
            MSVideoPlayerManager.videoPause()
        }else {
            MSVideoPlayerManager.videoResume()
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
        }else if operation == .pop {
            return self.popAnimation
        }
        return nil
    }
}
