//
//  MSVideoPlayController.swift
//  MSVideo
//
//  Created by 王方芳 on 2022/4/23.
//

import Foundation
import UIKit
import AVFoundation


enum MTVideoFromType {
    case list
    case userCenter
    case recommentList
    case ablum
}

protocol MTVideoPlayControllerDelegate: NSObjectProtocol {
    
    func playControllerDidDisappear()
    
    func resourceViewProvider(at index: Int) -> UIView?
}

extension MTVideoPlayControllerDelegate {
    func playControllerDidDisappear() {}
    func resourceViewProvider(at index: Int) -> UIView? {return nil}
}

class MTVideoPlayController: BFBaseViewController {
    
    weak var delegate: MTVideoPlayControllerDelegate?
    
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

    private var currentPlayingIndex: Int = 0
    
    //默认从第一个视频开始播放
    var needToPlayAtIndex: Int = 0
    
    var autoPlayer: MTAutoPlayer?
    
    var firstModel: MSVideoModel?
    
    lazy var player: MTListPlayer = {
        let player = MTListPlayer()
        return player
    }()
    
    // 转场属性
    private let presentScaleAnimation: PresentScaleAnimation = PresentScaleAnimation()
    
    private let dismissScaleAnimation: DismissScaleAnimation = DismissScaleAnimation()
    
    private let dragInteractiveTransition: DragInteractiveTransition = DragInteractiveTransition()
    
    private let pushAnimation: PushAnimation = PushAnimation()

    private var interactiveTransition: UIPercentDrivenInteractiveTransition?
    
    private var fromType: MTVideoFromType = .list
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fd_prefersNavigationBarHidden = true
        view.backgroundColor = .black
        view.addSubview(collectionView)
        view.addSubview(navView)

        if autoPlayer != nil {
            player.addVideoResource(datas: MSVideoUtils.testVideos())
            collectionView.reloadData()
            collectionView.layoutIfNeeded()
            if let cell = self.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? MTVideoListCell {
                autoPlayer?.playView?.frame = cell.bgImageView.bounds
                cell.bgImageView.insertSubview(autoPlayer!.playView!, at: 0)
            }
        }else {
            player.addVideoResource(datas: MSVideoUtils.testVideos())
            collectionView.reloadData()
            collectionView.layoutIfNeeded()
            currentPlayingIndex = needToPlayAtIndex
            collectionView.setContentOffset(CGPoint(x: 0, y: Int(UIScreen.height) * self.needToPlayAtIndex), animated: false)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if let cell = self.collectionView.cellForItem(at: IndexPath(item: self.needToPlayAtIndex, section: 0)) as? MTVideoListCell {
                    self.player.startPlayVideo(index: self.needToPlayAtIndex, in: cell)
                }
            }
        }
    }
    
    convenience init(fromType: MTVideoFromType) {
        self.init(nibName: nil, bundle: nil)
        self.fromType = fromType
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        player.videoResume()
        self.dragInteractiveTransition.dragPushEnable = true
        self.dragInteractiveTransition.dragDismissEnable = true
        self.navigationController?.delegate = self
        //在视频合集播放页，进入时将合集视频列表弹起
        if fromType == .ablum {
            let ablumListVC = MTVideoAblumVC()
            ablumListVC.modalPresentationStyle = .custom
            self.present(ablumListVC, animated: true, completion: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        player.videoPause()
        dragInteractiveTransition.dragPushEnable = false
        dragInteractiveTransition.dragDismissEnable = false
        navigationController?.delegate = nil
    }
    
    deinit {
        delegate?.playControllerDidDisappear()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func show(fromVC: UIViewController,startView: UIView,player: MTAutoPlayer? = nil) {
        
        if player != nil {
            autoPlayer = player
            autoPlayer?.delegate = self
            dismissScaleAnimation.playView = autoPlayer?.playView
        }else {
            dismissScaleAnimation.playView = player?.playView
        }
        
        let nav = BFNavigationController(rootViewController: self)
        nav.transitioningDelegate = self
        nav.modalPresentationStyle = .custom
        nav.modalPresentationCapturesStatusBarAppearance = true
        let startFrame = startView.superview!.convert(startView.frame, to: nil)
        presentScaleAnimation.startFrame = startFrame
        presentScaleAnimation.startView = startView
        dismissScaleAnimation.endView = startView
        dismissScaleAnimation.endFrame = startFrame
        
        dragInteractiveTransition.wireToViewController(vc: nav)
        dragInteractiveTransition.pushVCType = MTTestController.self as UIViewController.Type
        fromVC.present(nav, animated: true, completion: nil)
    }
    
    @objc private func navViewLeftDidClick() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func navViewRightDidClick() {
        let sheetVC = UIAlertController(title: nil, message: player.videoInfo(), preferredStyle: .actionSheet)
        sheetVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(sheetVC, animated: true, completion: nil)
    }
}

extension MTVideoPlayController: UICollectionViewDataSource,UICollectionViewDelegate {
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return firstModel != nil ? player.playList.count + 1 : player.playList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "videoCell", for: indexPath) as! MTVideoListCell
        if firstModel != nil {
            if indexPath.row == 0 {
                cell.reloadData(model: firstModel!,fromType: fromType,delegate: self)
            }else {
                cell.reloadData(model: player.playList[indexPath.row - 1],fromType: fromType,delegate: self)
            }
        }else {
            cell.reloadData(model: player.playList[indexPath.row],fromType: fromType,delegate: self)
        }
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let currentIndex = Int(offsetY / UIScreen.height)

        if currentPlayingIndex != currentIndex {
            if let cell = collectionView.cellForItem(at: IndexPath(item: currentIndex, section: 0)) as? MTVideoListCell {
                currentPlayingIndex = currentIndex
                if autoPlayer != nil {
                    if currentIndex == 0 {
                        player.videoStop()
                        player.playView?.isHidden = true
                        autoPlayer?.playView?.isHidden = true
                        autoPlayer?.player?.move(to: autoPlayer?.currentPlayingItem?.identifier)
                        autoPlayer?.playView?.frame = cell.bgImageView.bounds
                        cell.bgImageView.insertSubview(autoPlayer!.playView!, at: 0)
                    }else {
                        autoPlayer?.videoStop()
                        player.startPlayVideo(index: currentIndex - 1, in: cell)
                    }
                }else {
                    player.startPlayVideo(index: currentIndex, in: cell)
                }
            }
            if let resouceView = delegate?.resourceViewProvider(at: currentIndex) {
                let endFrame = resouceView.superview!.convert(resouceView.frame, to: nil)
                self.dismissScaleAnimation.endView = resouceView
                self.dismissScaleAnimation.endView?.alpha = 0
                self.dismissScaleAnimation.endFrame = endFrame
            }
        }
    }
}

//MARK: - 列表自动播放器回调
extension MTVideoPlayController: MTAutoPlayerDelegate {
    
    func playerProgressChanged(progress: Float) {
        if let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? MTVideoListCell {
            cell.updateProgress(progress: progress)
        }
    }
    
    func playerStatusChaned(status: MTVideoPlayerStatus) {
        if let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? MTVideoListCell {
            cell.playStatusChanged(to: status)
        }
    }
}

//MARK: - videoCell 的回调事件
extension MTVideoPlayController: MTVideoListCellDelegate {
    
    func needToSeek(to progress: Float) {
        if currentPlayingIndex == 0 && autoPlayer != nil {
            autoPlayer?.videoSeek(progress: progress)
        }else {
            player.videoSeek(progress: progress)
        }
    }
    
    func needToPlayOrPause(pause: Bool) {
        if currentPlayingIndex == 0 && autoPlayer != nil {
            pause ? autoPlayer?.videoPause() : autoPlayer?.videoResume()
        }else {
            pause ? player.videoPause() : player.videoResume()
        }
    }
    
    func needToStopScroll(stop: Bool) {
        collectionView.isScrollEnabled = !stop
    }
    
    //点击视频合集
    func videoAblumTap(model: MSVideoModel) {
        let playVC = MTVideoPlayController(fromType: .ablum)
        playVC.player.addVideoResource(datas: MSVideoUtils.testVideos())
        playVC.needToPlayAtIndex = 0
        self.navigationController?.pushViewController(playVC, animated: true)
    }
    
    //点击视频合集列表
    func videoAblumList() {
        let ablumListVC = MTVideoAblumVC()
        ablumListVC.modalPresentationStyle = .custom
        self.present(ablumListVC, animated: true, completion: nil)
    }
}

//MARK: - present 转场动画
extension MTVideoPlayController: UIViewControllerTransitioningDelegate {
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
extension MTVideoPlayController: UINavigationControllerDelegate {
    
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

