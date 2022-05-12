//
//  MTVideoAblumVC.swift
//  MSVideo
//
//  Created by MoliySDev on 2022/5/10.
//

import UIKit

class MTVideoAblumVC: BFBaseViewController,UIGestureRecognizerDelegate {
    
    lazy var containerView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        view.frame = CGRect(x: 0, y: UIScreen.status_navi_height + 115, width: UIScreen.width, height: UIScreen.height - UIScreen.status_navi_height - 115)
        return view
    }()
    
    lazy var headerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.width, height: 44))
        let closeBtn = UIButton(type: .custom)
        closeBtn.setImage(UIImage(named: "video_ablum_close"), for: .normal)
        closeBtn.frame = CGRect(x: UIScreen.width - 17 - 30, y: 7, width: 30, height: 30)
        closeBtn.addTarget(self, action: #selector(hide), for: .touchUpInside)
        view.addSubview(closeBtn)
        
        let line = UIView(bgColor: .black.withAlphaComponent(0.05))
        line.frame = CGRect(x: 0, y: 44 - 1, width: UIScreen.width, height: 1)
        view.addSubview(line)
        return view
    }()
    
    lazy var navTitleView: MTVideoAblumTitleView = {
        let view = MTVideoAblumTitleView()
        view.titleL.text = "试管婴儿合集"
        view.numL.text = "第1集"
        return view
    }()
    
    lazy var topMaskView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.0)
        let tap = UITapGestureRecognizer(target: self, action: #selector(topMaskViewTap))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    private var panGestureEnable: Bool = false
    
    lazy var tableView: MTPresentListTableView = {
        let tableView = MTPresentListTableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 118
        tableView.estimatedRowHeight = 0
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: UIScreen.safeAreaBottomHeight, right: 0)
        tableView.register(MTVideoAblumListCell.self, forCellReuseIdentifier: "ablumListCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(containerView)
        topMaskView.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: UIScreen.status_navi_height + 115)
        view.addSubview(topMaskView)
        containerView.addRoundCorners(corners: [.topLeft,.topRight], radii: CGSize(width: 16, height: 16))
        containerView.contentView.addSubview(headerView)
        tableView.frame = CGRect(x: 0, y: 44, width: UIScreen.width, height: containerView.height - 44)
        containerView.contentView.addSubview(tableView)

        headerView.addSubview(navTitleView)
        navTitleView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualTo(UIScreen.width - 150)
        }
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler))
        pan.delegate = self
        containerView.contentView.addGestureRecognizer(pan)
        
        view.isHidden = true
        let transform = CGAffineTransform(translationX: 0, y: containerView.height)
        containerView.transform = transform
        
        self.show()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @objc func panGestureHandler(pan: UIPanGestureRecognizer) {
        
        if tableView.isDragging {
            return
        }
        switch pan.state {
        case .began:
            pan.setTranslation(.zero, in: pan.view)
            break
        case .changed:
            let translation = pan.translation(in: pan.view)
            var contentOffset = tableView.contentOffset
            if contentOffset.y > 0 {
                contentOffset.y -= translation.y
                pan.setTranslation(.zero, in: pan.view)
                tableView.setContentOffset(contentOffset, animated: false)
                return
            }
            if contentOffset.y == 0 && !self.panGestureEnable {
                self.panGestureEnable = true
                pan.setTranslation(.zero, in: pan.view)
                return
            }
            self.updatePresentedViewForTranslation(translation: translation.y)
            break
        case .ended,.failed:
            self.panGestureEnable = false
            let curTransform = self.containerView.transform
            // 160 这个临界值可以修改为自己合适的值
            if curTransform.ty >= 160 {
                self.hide()
            }else {
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.curveEaseOut,.allowUserInteraction]) {
                    self.containerView.transform = .identity
                } completion: { _ in
                    
                }
            }
            break
        default:
            break
        }
    }
    
    private func updatePresentedViewForTranslation(translation: CGFloat) {
        
        if translation < 0 {
            self.containerView.transform = .identity
            self.tableView.setContentOffset(CGPoint(x: 0, y: -translation), animated: false)
            return
        }
        self.containerView.transform = CGAffineTransform(translationX: 0, y: translation)
    }
    
    func show() {
        self.view.isHidden = false
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.curveEaseOut,.allowUserInteraction]) {
            self.containerView.transform = .identity
        } completion: { _ in
        }

    }
    
    @objc func hide() {
        let transform = CGAffineTransform(translationX: 0, y: self.containerView.height)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.curveEaseOut,.allowUserInteraction]) {
            self.containerView.transform = transform
        } completion: { finished in
            if finished {
                self.view.isHidden = true
                self.dismiss(animated: true)
            }
        }
    }
    
    @objc func topMaskViewTap() {
        self.hide()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


extension MTVideoAblumVC: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ablumListCell", for: indexPath) as! MTVideoAblumListCell
        cell.titleL.text = "第1集"
        let content = "标题标题标题标题标题标题标题标题标题标题标题标题标题"
        cell.subTitleL.changeLineSpace(space: 6, text: content)
        cell.timeL.text = "05:46"
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y <= -scrollView.contentInset.top && scrollView.panGestureRecognizer.state == .changed {
            scrollView.panGestureRecognizer.state = .ended
            scrollView.setContentOffset(.zero, animated: false)
            return
        }
    }
}
