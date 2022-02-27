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
        //presenter?.routeUser()
        performSegue(withIdentifier: WelcomeVCSegues.welcomeToLoginPrefVC.rawValue, sender: nil)
    }
}

extension WelcomeVC : PresenterToViewWelcomeProtocol {
    func goToOnBoard() {
        performSegue(withIdentifier: WelcomeVCSegues
                        .welcomeToOnBoardVC
                        .rawValue, sender: nil)
    }
    
    func goToLoginPref() {
        performSegue(withIdentifier: WelcomeVCSegues
                        .welcomeToLoginPrefVC
                        .rawValue, sender: nil)
    }
    
    func goToHome() {
        performSegue(withIdentifier: WelcomeVCSegues
                        .welcomeToHomeVC
                        .rawValue, sender: nil)
    }
}


enum WelcomeVCSegues : String {
    case welcomeToLoginPrefVC = "welcomeToLoginPref"
    case welcomeToOnBoardVC = "welcomeToOnBoard"
    case welcomeToHomeVC = "welcomeToHome"
}
