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
    @IBOutlet weak var interestsTableView: UITableView!
    @IBOutlet weak var interestsTableViewIndicator: UIActivityIndicatorView!
    
    var hobbyList:[String]?
    var presenter:ViewToPresenterInterestSelectProtocol?
    
    var userId:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        hobbyList = [String]()
        
        SelectInterestRouter.createModule(ref: self)
        if let uuid = userId {
            presenter?.getInterests(uuid: uuid)
        }
    }

    @IBAction func interestsSaveButton(_ sender: Any) {
        
    }
    
}

extension SelectInterestVC : PresenterToViewInterestSelectProtocol {
    func hobbies(hobbyList: [String], alreadyList: [String]) {
        interestsTableViewIndicator.stopAnimating()
        self.hobbyList = hobbyList
        
        for index in hobbyList {
            print(index)
        }
    }
}

extension SelectInterestVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hobbyList!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InterestSelectionCell") as! InterestSelectTableViewCell
        return cell
    }
    
    
}
