//
//  TestOneController.swift
//  MSVideo
//
//  Created by MoliySDev on 2022/6/17.
//

import UIKit


class TestOneController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btn = UIButton(type: .custom)
        btn.setTitle("视频", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16)
        btn.frame = CGRect(x: 100, y: 200, width: 80, height: 30)
        btn.addTarget(self, action: #selector(btnTap), for: .touchUpInside)
        view.addSubview(btn)
    }
    
    @objc func btnTap() {
        let vc = TestSecondController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
