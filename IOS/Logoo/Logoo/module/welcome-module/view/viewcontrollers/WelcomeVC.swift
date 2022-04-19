//
//  WelcomeVC.swift
//  Logoo
//
//  Created by cemal tüysüz on 20.01.2022.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class WelcomeVC: UIViewController {
    
    var presenter : ViewToPresenterWelcomeProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        WelcomeRouter.createModule(ref: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presenter?.routeUser()
    }
}

extension WelcomeVC : PresenterToViewWelcomeProtocol {
    func onStateChange(_ state: WelcomeState) {
        var vc:UIViewController!
        
        switch state {
        case .goToOnBoard:
            vc = OnBoardVC.instantiate(from: .Welcome)
            break
        case .goToLoginPref:
            vc = UINavigationController(rootViewController: LoginPrefVC.instantiate(from: .Welcome))
            break
        case .goToHome:
            vc = CustomTabBarController.instantiate(from: .Main)
            break
        }
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

enum WelcomeState {
    case goToOnBoard
    case goToLoginPref
    case goToHome
}
