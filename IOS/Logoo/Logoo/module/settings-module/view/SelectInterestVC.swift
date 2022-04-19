//
//  SelectInterestVC.swift
//  Logoo
//
//  Created by cemal tüysüz on 9.02.2022.
//

import UIKit
import FirebaseFirestore

class SelectInterestVC: UIViewController {
    
    @IBOutlet weak var interestSearchBar: UISearchBar!
    @IBOutlet weak var interestsTableViewIndicator: UIActivityIndicatorView!
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var screenDescriptionLabel: UILabel!
    @IBOutlet weak var saveButtonOutlet: UIButton!
    
    @IBOutlet weak var interestSelectionCollectionView: UICollectionView!
    @IBOutlet weak var interestSelectedCollectionView: UICollectionView!
    
    private var pendingRequestWorkItem: DispatchWorkItem?
    
    var hobbyList:[InterestSelectionModel]?
    var alreadySelectedList:[String]?
    var presenter:ViewToPresenterInterestSelectProtocol?
    var isFirst:Bool? = false
    var alert:CustomAlert?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SelectInterestRouter.createModule(ref: self)
        presenter?.getInterests()
                
        configureUI()
        configureBinds()
    }
    
    func configureBinds(){
        interestSelectionCollectionView.delegate = self
        interestSelectionCollectionView.dataSource = self
        
        interestSelectedCollectionView.delegate = self
        interestSelectedCollectionView.dataSource = self
        
        interestSearchBar.delegate = self
    }
    
    func configureUI(){
        screenTitleLabel.text = "Your Interests".localized()
        screenDescriptionLabel.text = "With the right area of ​​interest, you can get better recommendations.".localized()
        interestSearchBar.placeholder = "Sport, art, daily activity...".localized()
        saveButtonOutlet.setTitle("Save".localized(), for: .normal)
        interestSearchBar.tintColor = .black
    }
    
    @IBAction func interestsSaveButton(_ sender: Any) {
        if self.alreadySelectedList?.count ?? 0 > 0 {
            interestsTableViewIndicator.startAnimating()
            presenter?.saveInterests(list: alreadySelectedList!)
        }
    }
    @IBAction func closeInterestsScreenButton(_ sender: Any) {
        if isFirst ?? false {
            let vc = CustomTabBarController.instantiate(from: .Main)
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }else {
            dismiss(animated: true)
        }
    }
}

extension SelectInterestVC : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Cancel previous work when user input data.
        pendingRequestWorkItem?.cancel()
        
        let requestWorkItem = DispatchWorkItem { [weak self] in
            self?.presenter?.searchInterest(searchText: searchText)
        }
        // I created a work with 250 millisecond delay.
        pendingRequestWorkItem = requestWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250),
                                      execute: requestWorkItem)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
}

extension SelectInterestVC : PresenterToViewInterestSelectProtocol {
    func userAlreadyHobbies(alreadyList: [String]) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.alreadySelectedList = alreadyList
            strongSelf.interestSelectedCollectionView.reloadData()
            strongSelf.interestSelectionCollectionView.reloadData()
        }
    }
    
    func allHobies(hobbyList: [InterestSelectionModel]) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.hobbyList = hobbyList
            strongSelf.interestSelectionCollectionView.reloadData()
            strongSelf.interestsTableViewIndicator.stopAnimating()
        }
    }
    
    func indicatorVisibility(status: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {return}
            if status {
                strongSelf.interestsTableViewIndicator.startAnimating()
            }else {
                strongSelf.interestsTableViewIndicator.stopAnimating()
            }
        }
    }
    
    func saveInterestsResponse(resp: Resource<Any>) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {return}
            
            strongSelf.alert?.dismissAlert()
            if resp.status == .SUCCESS {
                if strongSelf.isFirst ?? false {
                    let vc = CustomTabBarController.instantiate(from: .Main)
                    vc.modalPresentationStyle = .fullScreen
                    strongSelf.present(vc, animated: true)
                }else {
                    strongSelf.dismiss(animated: true)
                }
            }else {
                print("Error when save interest : \(resp.message!)")
            }
            strongSelf.interestsTableViewIndicator.stopAnimating()
        }
    }
}

extension SelectInterestVC : UICollectionViewDelegate, UICollectionViewDataSource, InterestSelectCellToViewProtocol {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.interestSelectedCollectionView {
            return alreadySelectedList?.count ?? 0
        }
        return hobbyList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.interestSelectedCollectionView {
            let current = alreadySelectedList![indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "interestSelectedCell", for: indexPath) as! InterestSelectedCell
            cell.deSelect = self
            cell.initialize(row: current)
            return cell
        }
        
        
        var current = hobbyList![indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "interestSelectionCell", for: indexPath) as! InterestSelectionCell
        
        current.isSelected = alreadySelectedList!.contains(current.interestTitle!)
        
        cell.initialize(item: current)
        cell.indexPath = indexPath
        cell.cellToVC = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    // From CollectionView Cell
    func onClick(item: InterestSelectionModel) {
        DispatchQueue.main.async {
            if item.isSelected! == true {
                self.alreadySelectedList?.append(item.interestTitle!)
            }else {
                var count = 0
                for i in self.alreadySelectedList! {
                    if i == item.interestTitle! {
                        self.alreadySelectedList!.remove(at: count)
                        break
                    }
                    count = count + 1
                }
            }
            self.interestSelectionCollectionView.reloadData()
            self.interestSelectedCollectionView.reloadData()
        }
    }
}


enum SelectInterestVCSegues : String {
    case interestSelectionToHomeVC = "interestSelectionToHomeVC"
}
