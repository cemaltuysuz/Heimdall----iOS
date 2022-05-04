//
//  DiscoverVC.swift
//  Logoo
//
//  Created by cemal tüysüz on 22.01.2022.
//

import UIKit
#if canImport(CHTCollectionViewWaterfallLayout)
import CHTCollectionViewWaterfallLayout
#endif

class DiscoverVC: BaseVC {

    var presenter:ViewToPresenterDiscorveryProtocol?
    var discoveredUsers:[User]?
    
    let cellWidthRatio:CGFloat = 2.3 // by ScWidth
    let cellHeightRatio:CGFloat = 1.6 // by cellWidth
    let collectionViewPadding:CGFloat = 20
    let minimumColumnSpacing:CGFloat = 5
    let minimumInteritemSpacing:CGFloat = 5
    
    private var searchBarPendingRequestWorkItem: DispatchWorkItem?
    
    let pageLimit = 15
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var discoveredUsersCollectionView: UICollectionView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBinds()
        configureUI()
        
        DiscoveryRouter.createModule(ref: self)
        presenter?.getDiscoveredUsers(pageLimit)
    }
    
    func configureUI(){
        searchBar.placeholder = "Search a user".localized()
        
        let layout = CHTCollectionViewWaterfallLayout()
        layout.minimumColumnSpacing = minimumColumnSpacing
        layout.minimumInteritemSpacing = minimumInteritemSpacing
        
        // Collection view attributes
        discoveredUsersCollectionView.alwaysBounceVertical = true
        
        layout.sectionInset = UIEdgeInsets(top: collectionViewPadding,
                                           left: collectionViewPadding,
                                           bottom: 0,
                                           right: collectionViewPadding)
        discoveredUsersCollectionView.collectionViewLayout = layout
    }
    
    func configureBinds(){
        searchBar.delegate = self
        
        discoveredUsersCollectionView.delegate = self
        discoveredUsersCollectionView.dataSource = self
        
        discoveredUsersCollectionView.register(DiscoveredUserCollectionViewCell.self)
        discoveredUsersCollectionView.register(PaginationLoadCollectionViewCell.self)
    }
}

extension DiscoverVC : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.resetPagination()
        
        // Cancel previous work when user input data.
        searchBarPendingRequestWorkItem?.cancel()
        
        let requestWorkItem = DispatchWorkItem { [weak self] in
            if !searchText.isEmpty {
                if searchText.count >= 3 {
                    self?.presenter?.searchUser(searchText)
                }
            }else {
                self?.discoveredUsers?.removeAll()
                self?.presenter?.getDiscoveredUsers(self?.pageLimit ?? 0)
            }
        }
        searchBarPendingRequestWorkItem = requestWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250),
                                      execute: requestWorkItem)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if let searchString = searchBar.text, !searchString.trimmingCharacters(in: .whitespaces).isEmpty {
            discoveredUsers?.removeAll()
            presenter?.resetPagination()
            presenter?.getDiscoveredUsers(pageLimit)
            searchBar.text = ""
        }
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
}

extension DiscoverVC : UICollectionViewDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return DiscoveredUsersSection.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = DiscoveredUsersSection(rawValue: section) else {return 0}
        
        switch section {
        case .DISCOVERED_USER_SECTION:
            return discoveredUsers?.count ?? 0
        case .PAGINATION_SECTION:
            let stat = discoveredUsers?.count ?? 0 >= pageLimit
            return stat ? 1 : 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = DiscoveredUsersSection(rawValue: indexPath.section) else {return UICollectionViewCell()}
        if section == .DISCOVERED_USER_SECTION {
            let item = discoveredUsers![indexPath.row]
            let cell = collectionView.dequeue(indexPath, type: DiscoveredUserCollectionViewCell.self)
            cell.delegate = self
            cell.initialize(item)
            return cell
        }
        return collectionView.dequeue(indexPath, type: PaginationLoadCollectionViewCell.self)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let section = DiscoveredUsersSection(rawValue: indexPath.section) else {return}
        guard ((discoveredUsers != nil) && (discoveredUsers?.isEmpty ?? false)) else {return}
        if section == .PAGINATION_SECTION {
            (cell as! PaginationLoadCollectionViewCell).startAnimating()
            presenter?.getDiscoveredUsers(pageLimit)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let scWidth = collectionView.frame.width
        
        if let type = DiscoveredUsersSection(rawValue: indexPath.section), type == .PAGINATION_SECTION {
            return CGSize(width: scWidth, height: 50)
        }
        
        let current = discoveredUsers![indexPath.row]
        let cellWidth = (scWidth - (2 * collectionViewPadding)) / cellWidthRatio
        let cellHeight = cellWidth * cellHeightRatio
        
        let cell = collectionView.dequeue(indexPath, type: DiscoveredUserCollectionViewCell.self)
        
        cell.initialize(current)
        
        var minusHeight:CGFloat = 0
        
        if let manifesto = current.userManifesto,!manifesto.isEmpty, manifesto.height(withConstrainedWidth: cell.manifestoTextView.frame.width, font: cell.manifestoTextView.font!) < cell.manifestoTextView.frame.height{
            minusHeight += (cell.manifestoTextView.frame.height - manifesto.height(withConstrainedWidth: cell.manifestoTextView.frame.width, font: cell.manifestoTextView.font!))
        }else {
            minusHeight += cell.manifestoTextView.frame.height
        }
        return CGSize(width: cellWidth, height: cellHeight - minusHeight)
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
            
        case .searchedUsers(let users):
            DispatchQueue.main.async {
                self.discoveredUsers?.removeAll()
                self.discoveredUsers = users
                self.discoveredUsersCollectionView.reloadData()
            }
            break
            
        case .pagedDataError:
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
    case searchedUsers(users:[User])
    case pagedDataError
}

enum DiscoveredUsersSection : Int, CaseIterable  {
    case DISCOVERED_USER_SECTION
    case PAGINATION_SECTION
}
