//
//  WelcomeVC.swift
//  Logoo
//
//  Created by cemal tüysüz on 20.01.2022.
//

import UIKit
import FirebaseAuth

class WelcomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        performSegue(
            withIdentifier: WelcomeVCSegues
                        .welcomeToOnBoardVC
                        .rawValue,
            sender: nil)
        return
        if Auth.auth().currentUser != nil {
            performSegue(
                withIdentifier: WelcomeVCSegues
                            .welcomeToLoginRouterVC
                            .rawValue,
                sender: nil)
        }else {
            performSegue(
                withIdentifier: WelcomeVCSegues
                            .welcomeToOnBoardVC
                            .rawValue,
                sender: nil)
        }
    }
}

enum WelcomeVCSegues : String {
    case welcomeToLoginRouterVC = "welcomeToLoginRouter"
    case welcomeToOnBoardVC = "welcomeToOnBoard"
}
