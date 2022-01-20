//
//  WelcomeVC.swift
//  Logoo
//
//  Created by cemal tüysüz on 20.01.2022.
//

import UIKit

class WelcomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
                
    }
    
    override func viewDidAppear(_ animated: Bool) {
        performSegue(withIdentifier: "welcomeToOnBoard", sender: nil)
    }
}
