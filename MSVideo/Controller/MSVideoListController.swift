//
//  MSVideoListController.swift
//  MSVideo
//
//  Created by MoliySDev on 2022/4/27.
//

import UIKit
import MJRefresh



class MSVideoListController: BFBaseViewController {
    
    private lazy var tableView: UITableView = {[weak self] in
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.width, height: UIScreen.height), style: .plain)
        tableView.estimatedRowHeight = 0
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsets(top: UIScreen.status_navi_height, left: 0, bottom: UIScreen.safeAreaBottomHeight + UIScreen.tabBarHeight, right: 0)
        tableView.register(MSDynamicListCell.self, forCellReuseIdentifier: "listCell")
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self?.requestData()
        })
        return tableView
    }()
    
    private var datas: [MSVideoModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.mj_header?.beginRefreshing()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    private func requestData() {
        
        let viewModel = MSVideoViewModel()
        viewModel.refreshNewList { list in
            self.datas.removeAll()
            self.datas += list ?? []
            self.tableView.reloadData()
            self.tableView.mj_header?.endRefreshing()
        } fail: { error in
            self.tableView.mj_header?.endRefreshing()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}

extension MSVideoListController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! MSDynamicListCell
        cell.model = self.datas[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let selectCell = tableView.cellForRow(at: indexPath) as? MSDynamicListCell else {return}
        let playVC = MSVideoPlayController()
        playVC.reloadVideos(datas: self.datas, playAtIndex: indexPath.row)
        playVC.show(fromVC: self, startView: selectCell.coverImageView)
        playVC.resourceViewProvider = {[weak self] index in
            let endCell = self?.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? MSDynamicListCell
            return endCell?.coverImageView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.datas[indexPath.row]
        return model.viewHeight + 30.0
    }
}

class MSDynamicListCell: UITableViewCell {
    
    lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var playIcon: UIImageView = {
       let icon = UIImageView()
        icon.image = UIImage(named: "icon_play_pause")
        return icon
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(coverImageView)
        coverImageView.addSubview(playIcon)
    }
    
    var model: MSVideoModel? {
        didSet {
            if let model = model {
                if model.coverUrl.hasPrefix("http") {
                    let coverUrl = model.coverUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                    coverImageView.kf.setImage(with: URL(string: coverUrl))
                }else {
                    let coverUrl = Bundle.main.path(forResource: model.coverUrl, ofType: nil) ?? ""
                    coverImageView.kf.setImage(with: URL(fileURLWithPath: coverUrl))
                }
                coverImageView.frame = CGRect(x: 15, y: 15, width: 200, height: model.viewHeight)
                playIcon.sizeToFit()
                playIcon.center = CGPoint(x: coverImageView.width * 0.5, y: coverImageView.height * 0.5)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

