//
//  ProfileSettingsVC.swift
//  Logoo
//
//  Created by cemal tüysüz on 27.02.2022.
//

import UIKit

class ProfileSettingsVC: BaseVC {
    
    @IBOutlet weak var optionsTableView: UITableView!
    var presenter:ViewToPresenterProfileSettingsProtocol?
    var options:[MenuItem<ProfileSettingType>]?

    override func viewDidLoad() {
        super.viewDidLoad()

        optionsTableView.register(UINib(nibName: "ProfileMenuItemCell", bundle: nil), forCellReuseIdentifier: "ProfileMenuItemCell")
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        
        ProfileSettingsRouter.createModule(ref: self)
        presenter?.getOptions()
    }
}

extension ProfileSettingsVC : PresenterToViewProfileSettingsProtocol {
    
    func optionsToView(options: [MenuItem<ProfileSettingType>]) {
        DispatchQueue.main.async {
            self.options = options
            self.optionsTableView.reloadData()
        }
    }
    func exitUserFeedback() {
        // TODO (GO LOGIN PREF SCREEN)
    }
}

extension ProfileSettingsVC : UITableViewDelegate, UITableViewDataSource, ProfileMenuItemCellProtocol {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let current = options![indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileMenuItemCell") as! ProfileMenuItemCell
        cell.initialize(option: current)
        cell.delegate = self
        return cell
    }
    
    func onClick(model: MenuItem<ProfileSettingType>) {
        switch model.type {
        case .INVITE_FRIENDS:
            break
        case .SECURITY:
            performSegue(withIdentifier: "ProfileSettingsToSecurityVC", sender: nil)
            break
        case .PREFERENCES:
            
            break
        case .INTERESTS:
            performSegue(withIdentifier: "SettingsToInterestVC", sender: nil)
            break
        case .NOTIFICATIONS:
            
            break
        case .PRIVACY:
            
            break
        case .ABOUT:
            
            break
        case .LOGOUT:
            exitUser()
            break
        case .none:
            break
        }
    }
}

// MARK: - Settings functions

extension ProfileSettingsVC {
    
    // on Exit
    func exitUser() {
        createBasicAlert(title: "Account sign out".localized(), message: "Are you sure you want to log out?".localized(), okTitle: "Yes".localized(), onCompletion: {type in
            switch type {
            case .CONFIRM:
                self.presenter?.exitUser()
                break
            case .DISMISS:
                break
            }
        })
        navigationController?.popToRootViewController(animated: true)
    }
}
