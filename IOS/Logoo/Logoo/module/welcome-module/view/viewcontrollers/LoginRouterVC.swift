//
//  LoginRouterVC.swift
//  Logoo
//
//  Created by cemal tüysüz on 11.02.2022.
//

import UIKit

class LoginRouterVC: BaseVC {

    var presenter:ViewToPresenterLoginRouterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        LoginRoutRouter.createModule(ref: self)
        presenter?.route()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginRouterToInterestSelectionVC" {
            if let uuid = sender as? String {
                let targetVC = segue.destination as! SelectInterestVC
                targetVC.isFirst = true
            }
        }
    }
}

extension LoginRouterVC : PresenterToViewLoginRouterProtocol {
    func loginToHomeVC() {
        performSegue(withIdentifier: "loginRouterToHomeVC", sender: nil)
    }
    
    func loginToInterestSelectionVC() {
        performSegue(withIdentifier: "loginRouterToInterestSelectionVC", sender: nil)
    }
    
    func loginToErrorVC(message:String) {
        // TODO()
    }
    
}
