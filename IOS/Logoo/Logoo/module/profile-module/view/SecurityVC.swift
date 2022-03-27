//
//  SecurityVC.swift
//  Logoo
//
//  Created by cemal tüysüz on 10.03.2022.
//

import UIKit
import Lottie

class SecurityVC: UIViewController {
    @IBOutlet weak var infoStackView: UIStackView!
    @IBOutlet weak var visualView: UIView!
    @IBOutlet weak var itemsTableView: UITableView!
    var animView:AnimationView?
    
    var securityItems:[MenuItem<SecurityItemType>]?
    var presenter:ViewToPresenterSecurityProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupModel()
        setupUI()
        
    }
    
    func setupModel(){
        SecurityRouter.createModule(ref: self)
        presenter?.getSecurityItems()
    }
    
    func setupUI(){
        self.itemsTableView.register(UINib(nibName: "SecurityMenuItemCell", bundle: nil), forCellReuseIdentifier: "SecurityMenuItemCell")
        itemsTableView.delegate = self
        itemsTableView.dataSource = self
        
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

extension SecurityVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Hesap Güvenliği"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return securityItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = securityItems![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SecurityMenuItemCell") as! SecurityMenuItemCell
        cell.initialize(option: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = securityItems![indexPath.row]
        print("\(item.itemTitle) is \(item.isEnabled) and type: \(item.type)")
        if item.isEnabled {
            switch item.type {
            case .CHANGE_MAIL:
                print("mail chane")
                break
            case .CHANGE_PASSWORD:
                print("pass change")
                break
            case .LOGIN_TRANSACTIONS:
                print("transactions")
                performSegue(withIdentifier: "securityToLoginTransactionsVC", sender: nil)
                break
            case .none:
                break
            }
        }
    }

}

extension SecurityVC : PresenterToViewSecurityProtocol {
    func securityItems(items: [MenuItem<SecurityItemType>]) {
        self.securityItems = items
    }
}
