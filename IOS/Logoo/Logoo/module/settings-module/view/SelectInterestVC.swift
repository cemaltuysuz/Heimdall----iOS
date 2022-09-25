//
//  SelectInterestVC.swift
//  Logoo
//
//  Created by cemal tüysüz on 9.02.2022.
//

import UIKit
import FirebaseFirestore

class SelectInterestVC: BaseVC {
    
    @IBOutlet weak var interestSearchBar: UISearchBar!
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var screenDescriptionLabel: UILabel!
    @IBOutlet weak var saveButtonOutlet: UIButton!
    
    @IBOutlet weak var interestSelectionTableView: UITableView!
    @IBOutlet weak var interestSelectedCollectionView: UICollectionView!
    
    private var searchBarPendingRequestWorkItem: DispatchWorkItem?
    private var loadViewPendingRequestWorkItem: DispatchWorkItem?
    
    var allInterests = [Interest]()
    var userInterests:[Interest]?
    
    var pageLimit = 12
    
    var presenter:ViewToPresenterInterestSelectProtocol?
    var isFirst:Bool? = false
    var alert:CustomAlert?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SelectInterestRouter.createModule(ref: self)
        presenter?.getInterests(pageLimit)
        presenter?.getUserInterests()
                
        configureUI()
        configureBinds()
    }
    
    func configureBinds() {
        interestSelectionTableView.register(PaginationLoadCell.self)
        interestSelectionTableView.delegate = self
        interestSelectionTableView.dataSource = self
        
        interestSelectedCollectionView.delegate = self
        interestSelectedCollectionView.dataSource = self
        
        interestSearchBar.delegate = self
    }
    
    func configureUI() {
        screenTitleLabel.text = "Your Interests".localized
        screenDescriptionLabel.text = "With the right area of ​​interest, you can get better recommendations.".localized
        interestSearchBar.placeholder = "Sport, art, daily activity...".localized
        saveButtonOutlet.setTitle("Save".localized, for: .normal)
        interestSearchBar.tintColor = .black
        
        interestSelectionTableView.register(InterestSelectionCell.self)
        interestSelectionTableView.rowHeight = UITableView.automaticDimension
    }
    
    @IBAction func interestsSaveButton(_ sender: Any) {
        if let userInterests = userInterests {
            presenter?.saveInterests(list: userInterests)
        }
    }
    @IBAction func closeInterestsScreenButton(_ sender: Any) {
        if isFirst ?? false {
            let vc = LGTabBarController.instantiate(from: .Main)
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }else {
            dismiss(animated: true)
        }
    }
}

extension SelectInterestVC : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.resetPagination()
        
        // Cancel previous work when user input data.
        searchBarPendingRequestWorkItem?.cancel()
        
        let requestWorkItem = DispatchWorkItem { [weak self] in
            if !searchText.isEmpty {
                if searchText.count >= 4 {
                    self?.presenter?.searchInterest(searchText: searchText)
                }
            }else {
                self?.allInterests.removeAll()
                self?.presenter?.getInterests(self?.pageLimit ?? 0)
            }
        }
        // I created a work with 250 millisecond delay.
        searchBarPendingRequestWorkItem = requestWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250),
                                      execute: requestWorkItem)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if let searchString = searchBar.text, !searchString.trimmingCharacters(in: .whitespaces).isEmpty {
            allInterests.removeAll()
            presenter?.getInterests(pageLimit)
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

extension SelectInterestVC : PresenterToViewInterestSelectProtocol {
    
    func onStateChange(state: InterestsState) {
        closeCurtain()
        switch state {
        case .interests(let pagedInterests):
            DispatchQueue.main.async {
                self.allInterests += pagedInterests
                self.interestSelectionTableView.reloadData()
            }
            break
        case .userInterests(let userInterests):
            DispatchQueue.main.async {
                self.userInterests = userInterests
                self.interestSelectedCollectionView.reloadData()
                self.interestSelectionTableView.reloadData()
            }
            break
        case .showCurtain:
            showCurtain()
            break
        case .saveInterestsResponse(let response):
            if response.status ?? false {
                if self.isFirst ?? false {
                    let vc = LGTabBarController.instantiate(from: .Main)
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                }else {
                    self.dismiss(animated: true)
                }
            }else {
                createAlertNotify(title: "Error".localized,
                                  message: "An error occurred while saving interests. Please try again later.".localized)
            }
            break
        case .getInterestError:
            loadViewPendingRequestWorkItem?.cancel()
            let workItem = DispatchWorkItem{[weak self] in
                if let interests = self?.allInterests, !interests.isEmpty {
                    let last = IndexPath(row: interests.count - 1, section: InterestSelectionTableViewSection.Interests.rawValue)
                    self?.interestSelectionTableView.scrollToRow(at: last, at: .bottom, animated: true)
                }
            }
            self.loadViewPendingRequestWorkItem = workItem
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1500), execute: workItem)
            break
        case .searchedInterests(let interests):
            allInterests.removeAll()
            allInterests += interests
            interestSelectionTableView.reloadData()
            break
        }
    }
}

extension SelectInterestVC : UICollectionViewDelegate, UICollectionViewDataSource, InterestActionCellProtocol {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userInterests?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = userInterests![indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "interestSelectedCell", for: indexPath) as! InterestSelectedCell
        cell.delegate = self
        cell.initialize(item: item)
        return cell
        
    }
    
    func onClickItem(item: Interest, isInsertAction: Bool) {
        DispatchQueue.main.async {
            if isInsertAction == true {
                self.userInterests?.append(item)
            }else {
                var count = 0
                for i in self.userInterests! {
                    if i.interestKey == item.interestKey {
                        self.userInterests!.remove(at: count)
                        //self.presenter?.deleteInterest(item.interestKey)
                        break
                    }
                    count = count + 1
                }
            }
            self.interestSelectedCollectionView.reloadData()
            self.interestSelectionTableView.reloadData()
        }
    }
}

extension SelectInterestVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return InterestSelectionTableViewSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = InterestSelectionTableViewSection(rawValue: section) else {return 0}
        
        switch sectionType {
        case .Interests:
            return allInterests.count
        case .LoadView:
            let stat = allInterests.count >= pageLimit
            return stat ? 1 : 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionType = InterestSelectionTableViewSection(rawValue: indexPath.section) else {return UITableViewCell()}
        
        if sectionType == .Interests {
            let item = allInterests[indexPath.row]
            let cell = tableView.dequeue(indexPath, type: InterestSelectionCell.self)
            cell.indexPath = indexPath
            cell.delegate = self
            
            for index in userInterests ?? [] {
                if item.interestKey == index.interestKey {
                    cell.initialize(item: item, isSelected: true)
                    return cell
                }
            }
            cell.initialize(item: item, isSelected: false)
            return cell
        }
        let cell = tableView.dequeue(indexPath, type: PaginationLoadCell.self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let sectionType = InterestSelectionTableViewSection(rawValue: indexPath.section) else {return}
        guard !allInterests.isEmpty else { return }
        
        if sectionType == .LoadView {
            (cell as! PaginationLoadCell).startAnimating()
            presenter?.getInterests(pageLimit)
        }
    }
}

enum InterestsState  {
    case interests(pagedInterests:[Interest])
    case userInterests(userInterests:[Interest]?)
    case showCurtain
    case saveInterestsResponse(response:SimpleResponse)
    case getInterestError
    case searchedInterests(interests:[Interest])
}

enum InterestSelectionTableViewSection : Int,CaseIterable {
    case Interests
    case LoadView
}

