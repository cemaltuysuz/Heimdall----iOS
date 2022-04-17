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
    var options:[LineMenuItem]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ProfileSettingsRouter.createModule(ref: self)
        configureBindings()
        presenter?.getOptions()
    }
    
    func configureBindings(){
        optionsTableView.register(LineMenuItemCell.self)
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
    }
}

extension ProfileSettingsVC : PresenterToViewProfileSettingsProtocol {
    
    func optionsToView(options: [LineMenuItem]) {
        DispatchQueue.main.async {
            self.options = options
            self.optionsTableView.reloadData()
        }
    }
    func exitUserFeedback() {
        // TODO (GO LOGIN PREF SCREEN)
    }
}

extension ProfileSettingsVC : UITableViewDelegate, UITableViewDataSource, LineMenuItemCellProtocol {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let current = options![indexPath.row]
        
        let cell = tableView.dequeue(indexPath, type: LineMenuItemCell.self)
        cell.initialize(item: current)
        cell.delegate = self
        return cell
    }
    
    func onClickMenu(instance: LineMenuItem) {
        guard let securityItem = ProfileMenuItemType(rawValue: instance.rawValue), instance.isEnabled else {return}
        
        switch securityItem {
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
        }
    }
    
    func onClickWarning(instance: LineMenuItem) {
        guard let _ = ProfileMenuItemType(rawValue: instance.rawValue), instance.isWarningButtonEnabled, let message = instance.warningMessage else {return}
        createAlertNotify(title: "Alert".localized(), message: message)
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
