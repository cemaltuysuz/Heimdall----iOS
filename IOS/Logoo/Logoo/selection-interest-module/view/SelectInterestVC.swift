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
    
    var hobbyList:[InterestSelectionModel]?
    var alreadySelectedList:[String]?
    var presenter:ViewToPresenterInterestSelectProtocol?
    
    var userId:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        hobbyList = [InterestSelectionModel]()
        alreadySelectedList = [String]()
        
        self.interestSelectionCollectionView.delegate = self
        self.interestSelectionCollectionView.dataSource = self
        
        SelectInterestRouter.createModule(ref: self)
        if let uuid = userId {
            presenter?.getInterests(uuid: uuid)
        }
        
    }

    @IBAction func interestsSaveButton(_ sender: Any) {
        print("**************")
        for index in self.alreadySelectedList! {
           
            print(index)
        }
    }
    
}

extension SelectInterestVC : PresenterToViewInterestSelectProtocol {
    func hobbies(hobbyList: [InterestSelectionModel], alreadyList: [String]) {
        DispatchQueue.main.async {
            self.interestsTableViewIndicator.stopAnimating()
            self.hobbyList = hobbyList
            self.alreadySelectedList = alreadyList
            self.interestSelectionCollectionView.reloadData()
        }

    }
}

extension SelectInterestVC : UICollectionViewDelegate, UICollectionViewDataSource, InterestSelectCellToViewProtocol {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hobbyList!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
                self.interestSelectionCollectionView.reloadData()
            }
        }
    }
    
}
