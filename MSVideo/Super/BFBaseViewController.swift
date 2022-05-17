//
//  BFBaseViewController.swift
//  MSIM-Swift
//
//  Created by benny wang on 2021/7/28.
//

import UIKit

public class BFBaseViewController: UIViewController {

    public override func viewDidLoad() {
        super.viewDidLoad()

        let backItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        view.backgroundColor = UIColor.d_color(light: .white, dark: .black)
    }
    
    deinit {
        print("\(self) dealloc")
    }
}
