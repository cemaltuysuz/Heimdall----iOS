//
//  InterestsViewer.swift
//  Logoo
//
//  Created by cemal tüysüz on 8.04.2022.
//

import Foundation
import UIKit


protocol InterestsViewerProtocol : AnyObject {
    func onContentUpdated(_ collectionView:UICollectionView)
}


class InterestsViewer : NibLoadableView {
    
    @IBOutlet weak var interestsCollectionView: UICollectionView!
    var interests:[Interest]?
    weak var delegate:InterestsViewerProtocol?
    
    override func awakeFromNib() {
        configure()
    }
    
    func configure(){
        setupUI()
        setupBinds()
    }
    func setupUI(){
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 3
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        interestsCollectionView.collectionViewLayout = layout
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
        cell.congfigureCell(interest: current.getInterest())
        return cell
    }
}

extension InterestsViewer {
    
    func updateAndReloadData(interests:[Interest]){
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {return}
            if interests.count > 0 {
                strongSelf.interests = interests
                strongSelf.interestsCollectionView.reloadData()
                strongSelf.delegate?.onContentUpdated(strongSelf.interestsCollectionView)
            }
        }
    }
}

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)

        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }

            layoutAttribute.frame.origin.x = leftMargin

            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }

        return attributes
    }
}

