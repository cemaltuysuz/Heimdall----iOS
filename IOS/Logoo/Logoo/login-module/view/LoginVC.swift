//
//  LoginVC.swift
//  Logoo
//
//  Created by cemal tüysüz on 25.01.2022.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var loginUserMail: UITextField!
    @IBOutlet weak var loginUserPassword: UITextField!
    @IBOutlet weak var loginErrorMessageLabel: UILabel!
    
    var incomingMail:String?
    
    var presenter:ViewToPresenterLoginProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let mail = incomingMail {
            self.loginUserMail.text = mail
        }
        
        LoginRouter.createModule(ref: self)
        
        

    }
    @IBAction func loginButton(_ sender: Any) {
        if let mail = loginUserMail.text, let password = loginUserPassword.text {
            presenter?.loginUser(mail: mail, password: password)
        }
    }
}

extension LoginVC : PresenterToViewLoginProtocol {
    /**
     Kullanıcı giriş yapmak istediği zaman firebase tarafından dönen yanıt buraya geliyor.
     Dönen yanıt Resource sınıfı ile sarmalanmış yapıda, generic olan data kısmı ise UserState (enum) sınıfı tipinde.
     */
    func loginResponse(status: Resource<UserState>) {
        
        if status.status! == .SUCCESS{
            /**
             Kullanıcı başarılı bir şekilde login oluyor olabilir lakin mail adresinin onaylanmış olmama durumu mevcut.
             Bunun kontrolünü yapıyorum.
             Kullanıcı Onaylı ise ;
             - Kullanıcıya ait hobiler kontrol edilir, eğer hobisi yok ise hobi seçme ekranına yönlendirilir.
             */
            if status.data == .MAIL_ADRESS_CONFIRMED {
                self.loginErrorMessageLabel.isHidden = true
                performSegue(withIdentifier: "LoginToHome", sender: nil)
            }
            else if status.data == .MAIL_ADRESS_NOT_CONFIRMED {
                self.loginErrorMessageLabel.text = "Your account is not verified. Please confirm your mail adress."
                self.loginErrorMessageLabel.isHidden = false
            }
        }
        else if status.status! == .ERROR {
            print("Login error : \(status.message!)")
        }
    }
}
