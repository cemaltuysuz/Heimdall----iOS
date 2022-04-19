//
//  SecurityVC.swift
//  Logoo
//
//  Created by cemal tüysüz on 10.03.2022.
//

import UIKit
import Lottie

class SecurityVC: BaseVC {
    @IBOutlet weak var infoStackView: UIStackView!
    @IBOutlet weak var visualView: UIView!
    @IBOutlet weak var itemsTableView: UITableView!
    var animView:AnimationView?
    
    var securityItems:[LineMenuItem]?
    var presenter:ViewToPresenterSecurityProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupModel()
        setupBindings()
        setupUI()
        
    }
    
    func setupModel(){
        SecurityRouter.createModule(ref: self)
        presenter?.getSecurityItems()
    }
    
    func setupBindings(){
        itemsTableView.register(LineMenuItemCell.self)
        itemsTableView.delegate = self
        itemsTableView.dataSource = self
    }
    
    func setupUI(){
        if !UDService.shared.getSecurityVisualVisibility() {
            animView = AnimationView(name: "secureAnim")
            animView!.frame = visualView.bounds
            animView!.animationSpeed = 1
            animView!.loopMode = .playOnce
            animView!.play()
            visualView.addSubview(animView!)
            infoStackView.isHidden = false
        }
    }
    
    @IBAction func closeVisualViewButton(_ sender: Any) {
        infoStackView.isHidden = true
        animView?.removeFromSuperview()
        animView = nil
        UDService.shared.setSecurityVisualVisibility(value: true)
    }
}

extension SecurityVC : UITableViewDelegate, UITableViewDataSource, LineMenuItemCellProtocol {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Account Security".localized()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return securityItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = securityItems![indexPath.row]
        let cell = tableView.dequeue(indexPath, type: LineMenuItemCell.self)
        cell.delegate = self
        cell.initialize(item: model)
        return cell
    }

    func onClickMenu(instance: LineMenuItem) {
        guard let securityItem = SecurityMenuItemType(rawValue: instance.rawValue), instance.isEnabled else {return}
        
        switch securityItem {
        case .CHANGE_MAIL:
            let vc = ChangeMailVC.instantiate(from: .Security)
            navigationController?.pushViewController(vc, animated: true)
            break
        case .CHANGE_PASSWORD:
            let vc = ChangePasswordVC.instantiate(from: .Security)
            navigationController?.pushViewController(vc, animated: true)
            break
        case .LOGIN_TRANSACTIONS:
            let vc = LoginTransactionsVC.instantiate(from: .Security)
            navigationController?.pushViewController(vc, animated: true)
            break
        }
    }
    
    func onClickWarning(instance: LineMenuItem) {
        guard let _ = SecurityMenuItemType(rawValue: instance.rawValue), instance.isWarningButtonEnabled, let message = instance.warningMessage else {return}
        createAlertNotify(title: "Alert".localized(), message: message)
    }
}

extension SecurityVC : PresenterToViewSecurityProtocol {
    func securityItems(items: [LineMenuItem]) {
        self.securityItems = items
    }
}
