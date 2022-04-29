//
//  DiscoverVC.swift
//  Logoo
//
//  Created by cemal tüysüz on 22.01.2022.
//

import UIKit

class DiscoverVC: BaseVC {

    var presenter:ViewToPresenterDiscorveryProtocol?
    var discoveredUsers:[User]?
    
    let cellWidthRatio:CGFloat = 0.23 // by frame width
    let cellHeightRatio:CGFloat = 1.4 // by cell frame width
    let discoveredUsersCollectionViewPadding:CGFloat = 20
    
    var cellWidth : CGFloat!
    var cellHeiht: CGFloat!
    
   // @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var discoveredUsersCollectionView: UICollectionView!
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureBinds()
        
        DiscoveryRouter.createModule(ref: self)
        presenter?.getDiscoveredUsers()
        
    }
    
    func configureUI(){
        let deviceWidth = view.frame.width
        cellWidth = deviceWidth * cellWidthRatio
        cellHeiht = cellWidth * cellHeightRatio
        let totalCellArea = cellWidth * 3
        let totalDiscoveredUsersCollectionViewPadding = CGFloat(discoveredUsersCollectionViewPadding * 2)
        let interItemSpace = (deviceWidth - (totalCellArea + totalDiscoveredUsersCollectionViewPadding)) / 2
        
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0,
                                           left: discoveredUsersCollectionViewPadding,
                                           bottom: 0,
                                           right: discoveredUsersCollectionViewPadding)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = interItemSpace
        layout.minimumLineSpacing = 5
        discoveredUsersCollectionView.collectionViewLayout = layout
    }
    
    func configureBinds(){
        discoveredUsersCollectionView.delegate = self
        discoveredUsersCollectionView.dataSource = self
        discoveredUsersCollectionView.register(DiscoveredUserCollectionViewCell.self)
    }
}

extension DiscoverVC : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return discoveredUsers?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = discoveredUsers![indexPath.row]
        let cell = collectionView.dequeue(indexPath, type: DiscoveredUserCollectionViewCell.self)
        cell.delegate = self
        cell.initialize(item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeiht)
    }
}

extension DiscoverVC : PresenterToViewDiscorveryProtocol {
    func onStateChange(state: DiscoveryState) {
        switch state {
        case .discoveredUsers(let users):
            DispatchQueue.main.async {
                self.discoveredUsers = users
                self.discoveredUsersCollectionView.reloadData()
            }
            break
        }
    }
}

extension DiscoverVC : DiscoveredUserCollectionViewCellProtocol {
    func onUserClick(_ user: User) {
        let vc = ProfileVC.instantiate(from: .Profile)
        vc.userUUID = user.userId
        navigationController?.pushViewController(vc, animated: true)
    }
}

enum DiscoveryState{
    case discoveredUsers(users:[User])
}

