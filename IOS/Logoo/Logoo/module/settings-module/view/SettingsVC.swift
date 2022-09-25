//
//  ProfileSettingsVC.swift -> SettingsVC.swift (at 18 april 2022)
//  Logoo
//
//  Created by cemal tüysüz on 27.02.2022.
//

import UIKit

class SettingsVC: BaseVC {
    
    @IBOutlet weak var optionsTableView: UITableView!
    var presenter:ViewToPresenterSettingsProtocol?
    var options:[LineMenuItem]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        SettingsRouter.createModule(ref: self)
        configureBindings()
        presenter?.getOptions()
    }
    
    func configureBindings(){
        optionsTableView.register(LineMenuItemCell.self)
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
    }
}

extension SettingsVC : PresenterToViewSettingsProtocol {
    
    func optionsToView(options: [LineMenuItem]) {
        DispatchQueue.main.async {
            self.options = options
            self.optionsTableView.reloadData()
        }
    }
}

extension SettingsVC : UITableViewDelegate, UITableViewDataSource, LineMenuItemCellProtocol {
    
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
        guard let securityItem = SettingsMenuItemType(rawValue: instance.rawValue), instance.isEnabled else {return}
        
        switch securityItem {
        case .INVITE_FRIENDS:
            break
        case .SECURITY:
            let vc = SecurityVC.instantiate(from: .Security)
            navigationController?.pushViewController(vc, animated: true)
            break
        case .PREFERENCES:
            break
        case .INTERESTS:
            let vc = SelectInterestVC.instantiate(from: .Settings)
            present(vc, animated: true)
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
        guard let _ = SettingsMenuItemType(rawValue: instance.rawValue), instance.isWarningButtonEnabled, let message = instance.warningMessage else {return}
        createAlertNotify(title: "Alert".localized, message: message)
    }
}

// MARK: - Settings functions

extension SettingsVC {
    
    // on Exit
    func exitUser() {
        createBasicAlert(title: "Account sign out".localized, message: "Are you sure you want to log out?".localized, okTitle: "Yes".localized, onCompletion: {type in
            if type == .CONFIRM {
                self.presenter?.exitUser()
                
                let vc = UINavigationController(rootViewController: LoginPrefVC.instantiate(from: .Welcome))
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
        })
    }
}
