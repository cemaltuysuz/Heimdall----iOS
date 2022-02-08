//
//  LoginVC.swift
//  Logoo
//
//  Created by cemal tüysüz on 25.01.2022.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var loginUserMail: UITextField!
    var incomingMail:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let mail = incomingMail {
            self.loginUserMail.text = mail
        }

    }
    @IBAction func loginButton(_ sender: Any) {
        
    }
}
