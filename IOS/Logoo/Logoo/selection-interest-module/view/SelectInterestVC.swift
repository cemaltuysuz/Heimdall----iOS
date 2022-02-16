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
    
    @IBOutlet weak var interestSelectionCollectionView: UICollectionView!
    @IBOutlet weak var interestSelectedCollectionView: UICollectionView!
    
    private var pendingRequestWorkItem: DispatchWorkItem?
    
    var hobbyList:[InterestSelectionModel]?
    var alreadySelectedList:[String]?
    var presenter:ViewToPresenterInterestSelectProtocol?
    
    var alert:CustomAlert?
    
    var userId:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hobbyList = [InterestSelectionModel]()
        alreadySelectedList = [String]()
        
        SelectInterestRouter.createModule(ref: self)
        if let uuid = userId {
            presenter?.getInterests(uuid: uuid)
        }
        
         self.interestSelectionCollectionView.delegate = self
         self.interestSelectionCollectionView.dataSource = self
         
         self.interestSelectedCollectionView.delegate = self
         self.interestSelectedCollectionView.dataSource = self
         
         self.interestSearchBar.delegate = self
     
    }

    @IBAction func interestsSaveButton(_ sender: Any) {
        if self.alreadySelectedList!.count > 0 {
            self.interestsTableViewIndicator.startAnimating()
            presenter?.saveInterests(list: self.alreadySelectedList!)
        }else {
            print("selected list is empty.")
        }
         }
    @IBAction func closeInterestsScreenButton(_ sender: Any) {
        performSegue(withIdentifier: SelectInterestVCSegues
                        .interestSelectionToHomeVC
                        .rawValue, sender: nil)
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
}

extension SelectInterestVC : PresenterToViewInterestSelectProtocol {
    func userAlreadyHobbies(alreadyList: [String]) {
        self.alreadySelectedList = alreadyList
    }
    
    func allHobies(hobbyList: [InterestSelectionModel]) {
        DispatchQueue.main.async {
            self.hobbyList = hobbyList
            self.interestSelectionCollectionView.reloadData()
            self.interestsTableViewIndicator.stopAnimating()
        }
    }
    
    func indicatorVisibility(status: Bool) {
        DispatchQueue.main.async {
            if status {
                self.interestsTableViewIndicator.startAnimating()
            }else {
                self.interestsTableViewIndicator.stopAnimating()
            }
        }
    }
    
    func saveInterestsResponse(resp: Resource<Any>) {
        DispatchQueue.main.async {
            self.alert?.dismissAlert()
            if resp.status == .SUCCESS {
                print("interest save status : Success")
            }else {
                print("Error when save interest : \(resp.message!)")
            }
            self.interestsTableViewIndicator.stopAnimating()
        }
    }
}

extension SelectInterestVC : UICollectionViewDelegate, UICollectionViewDataSource, InterestSelectCellToViewProtocol {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.interestSelectedCollectionView {
            return self.alreadySelectedList!.count
        }
        return hobbyList!.count
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
