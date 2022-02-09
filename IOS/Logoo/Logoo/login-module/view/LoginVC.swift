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

extension LoginVC : PresenterToViewLoginProtocol {
    /**
     Kullanıcı giriş yapmak istediği zaman firebase tarafından dönen yanıt buraya geliyor.
     Dönen yanıt Resource sınıfı ile sarmalanmış yapıda, generic olan data kısmı ise UserState (enum) sınıfı tipinde.
     */
    func loginResponse(status: Resource<UserState>) {
        
        if status.status! == .SUCCESS {
            /**
             Kullanıcı başarılı bir şekilde login oluyor olabilir lakin mail adresinin onaylanmış olmama durumu mevcut.
             Bunun kontrolünü yapıyorum.
             */
            if status.data == .MAIL_ADRESS_CONFIRMED {
                print("Mail adresi onaylanan kullanıcı anasayfaya yönlendiriliyor.")
            }
            else if status.data == .MAIL_ADRESS_NOT_CONFIRMED {
                
            }
        }
        else if status.status! == .ERROR {
            
        }
    }
}
