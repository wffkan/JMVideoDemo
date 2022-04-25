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
    
    @objc dynamic var currentIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        requestData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    deinit {
        
    }
    
    func requestData() {
        
        let viewModel = MSVideoViewModel()
        viewModel.refreshNewList { list in
            self.datas.append(contentsOf: list ?? [])
            self.collectionView.reloadData()
        } fail: { error in
            
        }
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


}
