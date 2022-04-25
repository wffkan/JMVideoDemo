//
//  MSHomeController.swift
//  MSVideo
//
//  Created by 王方芳 on 2022/4/23.
//

import Foundation
import UIKit


class MSHomeController: BFBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btn = UIButton(frame: CGRect(x: 100, y: 200, width: 80, height: 40))
        btn.setTitle("video", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(pushToVideoList), for: .touchUpInside)
        view.addSubview(btn)
    }
    
    @objc func pushToVideoList() {
        
        let vc = MSVideoPlayController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
