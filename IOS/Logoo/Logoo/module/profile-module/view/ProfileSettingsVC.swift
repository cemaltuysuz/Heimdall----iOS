//
//  ProfileSettingsVC.swift
//  Logoo
//
//  Created by cemal tüysüz on 27.02.2022.
//

import UIKit

class ProfileSettingsVC: UIViewController {
    
    
    @IBOutlet weak var optionsTableView: UITableView!
    var presenter:ViewToPresenterProfileSettingsProtocol?
    @IBOutlet weak var profileUsernameLabel: UILabel!
    @IBOutlet weak var profileUserMailLabel: UILabel!
    @IBOutlet weak var profileUserPhoto: UIImageView!
    var options:[ProfileOuterOption]?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.optionsTableView.delegate = self
        self.optionsTableView.dataSource = self
        
        ProfileSettingsRouter.createModule(ref: self)
        presenter?.getOptions()
        presenter?.getUser()
        
    }
    @IBAction func editProfileButton(_ sender: Any) {
        
    }
}


extension ProfileSettingsVC : PresenterToViewProfileSettingsProtocol {
    func userToView(user: User) {
        DispatchQueue.main.async {
            if let username = user.username, let mail = user.userMail {
                self.profileUsernameLabel.text = username
                self.profileUserMailLabel.text = mail
            }
            if let link = user.userPhotoUrl {
                self.profileUserPhoto.setImage(urlString: link)
            }
        }
    }
    
    func optionsToView(options: [ProfileOuterOption]) {
        DispatchQueue.main.async {
            self.options = options
            self.optionsTableView.reloadData()
        }
    }
    
    
}

extension ProfileSettingsVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let current = options![indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileOuterCell") as! ProfileOuterOptionCell
        cell.initialize(option: current)
        return cell
    }
    
    
}
