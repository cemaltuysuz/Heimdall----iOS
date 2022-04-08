//
//  InterestsViewer.swift
//  Logoo
//
//  Created by cemal tüysüz on 8.04.2022.
//

import Foundation
import UIKit

class InterestsViewer : NibLoadableView {
    
    @IBOutlet weak var interestsCollectionView: UICollectionView!
    var interests:[String]?
    override func awakeFromNib() {
        configure()
    }
    
    func configure(){
        setupBinds()
    }
    
    func setupBinds(){
        interestsCollectionView.delegate = self
        interestsCollectionView.dataSource = self
        interestsCollectionView.register(InterestViewerCell.self)
    }
}


extension InterestsViewer : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return interests?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(indexPath, type: InterestViewerCell.self)
        let current = interests![indexPath.row]
        cell.congfigureCell(interest: current)
        return cell
    }
}

extension InterestsViewer {
    
    func updateAndReloadData(interests:[String]){
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {return}
            if interests.count > 0 {
                strongSelf.interests = interests
                strongSelf.interestsCollectionView.reloadData()
            }
        }
    }
}
