//
//  OnboardVC.swift
//  Logoo
//
//  Created by cemal tüysüz on 20.01.2022.
//

import Foundation
import UIKit

class OnBoardVC : UIViewController {
    
    @IBOutlet weak var onBoardCollectionView: UICollectionView!
    var presenter:ViewToPresenterOnBoardProtocol?
    var onBoardList:[OnBoard]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onBoardList = [OnBoard]()
        
        onBoardCollectionView.delegate = self
        onBoardCollectionView.dataSource = self
    }
}

extension OnBoardVC : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onBoardList!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "onBoardCollectionViewCell", for: indexPath) as! OnBoardCollectionCell
        cell.initializeCell(onBoard: onBoardList![indexPath.row])
        return cell
    }
}

extension OnBoardVC : PresenterToViewOnBoardProtocol {
    func onBoardListToView(onBoardList: [OnBoard]) {
        DispatchQueue.main.async {
            self.onBoardList = onBoardList
            self.onBoardCollectionView.reloadData()
        }
    }
}
