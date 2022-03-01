//
//  LoginRouterVC.swift
//  Logoo
//
//  Created by cemal tüysüz on 11.02.2022.
//

import UIKit

class LoginRouterVC: UIViewController {

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
                targetVC.userId = uuid
            }
        }
    }
}

extension LoginRouterVC : PresenterToViewLoginRouterProtocol {
    func loginToHomeVC() {
        performSegue(withIdentifier: "loginRouterToHomeVC", sender: nil)
    }
    
    func loginToInterestSelectionVC(userId:String) {
        performSegue(withIdentifier: "loginRouterToInterestSelectionVC", sender: userId)
    }
    
    func loginToErrorVC(message:String) {
        // TODO()
    }
    
}
