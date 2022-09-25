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
}

extension LoginRouterVC : PresenterToViewLoginRouterProtocol {
    func loginToHomeVC() {
        let vc = LGTabBarController.instantiate(from: .Main)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func loginToInterestSelectionVC() {
        let vc = SelectInterestVC.instantiate(from: .Settings)
        vc.modalPresentationStyle = .fullScreen
        vc.isFirst = true
        present(vc, animated: true)
    }
    
    func loginToErrorVC(message:String) {
        // TODO: err
    }
    
}
