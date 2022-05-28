//
//  UserRequests.swift
//  Logoo
//
//  Created by cemal tüysüz on 16.05.2022.
//

import Foundation
import UIKit

protocol UserRequestsViewProtocol : AnyObject {
    func onRequestClicked(_ request:Request)
}

class UserRequestsView : NibLoadableView {
    
    @IBOutlet weak var requestsCollectionView: UICollectionView!
    private var requests : [Request]?
    
    weak var delegate:UserRequestsViewProtocol?
    
    var cellSize:CGSize!
    var cellRatio:CGFloat = 0.7
    var minItemSpace:CGFloat = 10
    
    override func awakeFromNib() {
        calculateCellSize()
        initUI()
        initDelegateAndRegisters()
    }
}

extension UserRequestsView {
    
    func updateRequests(_ requests:[Request]) {
        self.requests = requests
        self.requestsCollectionView.reloadData()
    }
    
    func calculateCellSize() {
        let size = frame.height * cellRatio
        cellSize = CGSize(width: size, height: size)
    }
    
    func initUI() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = minItemSpace
        layout.scrollDirection = .horizontal
        requestsCollectionView.collectionViewLayout = layout
    }
    
    func initDelegateAndRegisters() {
        requestsCollectionView.delegate = self
        requestsCollectionView.dataSource = self
        requestsCollectionView.register(SmallRequestCollectionviewCollectionViewCell.self)
    }
}


extension UserRequestsView : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return requests?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = requests![indexPath.row]
        let cell = collectionView.dequeue(indexPath, type: SmallRequestCollectionviewCollectionViewCell.self)
        cell.setup(item)
        
        cell.onClicked = { request in
            self.delegate?.onRequestClicked(request)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    
}
