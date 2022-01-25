//
//  DiscoverVC.swift
//  Logoo
//
//  Created by cemal tüysüz on 22.01.2022.
//

import UIKit

class DiscoverVC: UIViewController {

    var presenter:ViewToPresenterDiscorveryProtocol?
    var discoveredUsers:[User]?
    @IBOutlet weak var discoveryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initialize variable
        discoveredUsers = [User]()
        
        discoveryTableView.delegate = self
        discoveryTableView.dataSource = self
        
        DiscoveryRouter.createModule(ref: self)
        presenter?.getDiscoveredUsers()
        
        // Segmented Control Setup
        let navigationItem = self.tabBarController?.navigationItem.titleView
        let segmentedControl = navigationItem as! UISegmentedControl
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        
    }
    
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        self.tabBarController?.selectedIndex = sender.selectedSegmentIndex
    }
}

extension DiscoverVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discoveredUsers!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let current = discoveredUsers![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "discoveryTableViewCell", for: indexPath) as! DiscoveryTableViewCell
        
        cell.discoveryUsernameLabel.text = current.username!
        cell.initialize(hobbyList: hobbyToHobbies(hobby: current.userHobbies!))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension DiscoverVC : PresenterToViewDiscorveryProtocol {
    func discoveredUsersToView(users: [User]) {
        DispatchQueue.main.async {
            self.discoveredUsers = users
            self.discoveryTableView.reloadData()
        }
    }
    
    
}
