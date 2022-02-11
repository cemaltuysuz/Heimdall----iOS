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
        performSegue(withIdentifier: "welcomeToOnBoard", sender: nil)
        return
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "welcomeToHome", sender: nil)
        }else {
            performSegue(withIdentifier: "welcomeToOnBoard", sender: nil)
        }
    }
}
