//
//  MTVideoAblumVC.swift
//  MSVideo
//
//  Created by MoliySDev on 2022/5/10.
//

import UIKit

class MTVideoAblumVC: BFBaseViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 118
        tableView.estimatedRowHeight = 0
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset = UIEdgeInsets(top: 44, left: 0, bottom: UIScreen.safeAreaBottomHeight, right: 0)
        tableView.register(MTVideoAblumListCell.self, forCellReuseIdentifier: "ablumListCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#262626").withAlphaComponent(0.9)
        view.addRoundCorners(corners: [.topLeft,.topRight], radii: CGSize(width: 16, height: 16))
        
        view.frame = CGRect(x: 0, y: UIScreen.status_navi_height + 115, width: UIScreen.width, height: UIScreen.height - UIScreen.status_navi_height - 115)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(44)
        }
    }
}


extension MTVideoAblumVC: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ablumListCell", for: indexPath) as! MTVideoAblumListCell
        
        return cell
    }
}
