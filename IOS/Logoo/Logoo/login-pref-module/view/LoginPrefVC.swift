//
//  LoginPrefVC.swift
//  Logoo
//
//  Created by cemal tüysüz on 20.01.2022.
//

import UIKit

class LoginPrefVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func toLoginButton(_ sender: Any) {
        performSegue(withIdentifier: LoginPrefVCSegues
                        .LoginPrefToLogin
                        .rawValue, sender: nil)
    }
}

enum LoginPrefVCSegues :String {
    case LoginPrefToLogin = "loginPrefToLogin"
}
