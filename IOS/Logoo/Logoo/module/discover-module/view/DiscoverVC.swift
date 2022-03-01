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
        
        DiscoveryRouter.createModule(ref: self)
        presenter?.getDiscoveredUsers()
        
        discoveryTableView.delegate = self
        discoveryTableView.dataSource = self

        
    }
}

extension DiscoverVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discoveredUsers!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let current = discoveredUsers![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "discoveryTableViewCell", for: indexPath) as! DiscoveryTableViewCell
        
        cell.initialize(user: current)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension DiscoverVC : PresenterToViewDiscorveryProtocol {
    func discoveredUsersResponse(response: Resource<[User]>) {
        DispatchQueue.main.async {
            if response.status == .SUCCESS {
                self.discoveredUsers = response.data!
                self.discoveryTableView.reloadData()
            }else {
                print("error")
            }
        }
    }
        
    
    func discoveredUsersToView(users: [User]) {
        DispatchQueue.main.async {
            self.discoveredUsers = users
            self.discoveryTableView.reloadData()
        }
    }
}

