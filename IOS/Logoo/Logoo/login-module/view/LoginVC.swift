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
    
    @IBOutlet weak var mailConfirmationContainer: UIStackView!
    @IBOutlet weak var sendVerificationButtonOutlet: UIButton!
    var incomingMail:String?
    var countTimer:Timer!
    var counter = 100
    
    
    
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
            if isValidMail(mail: mail) {
                presenter?.loginUser(mail: mail, password: password)
                self.loginErrorMessageLabel.isHidden = true
            }else {
                self.loginErrorMessageLabel.text = "The e-mail address is not in the correct format."
                self.loginErrorMessageLabel.isHidden = false
            }
        }
    }
    @IBAction func sendMailVerification(_ sender: Any) {
        if let mail = self.loginUserMail.text {
            presenter?.sendVerificationLink(mail: mail)
        }
    }
}

extension LoginVC : PresenterToViewLoginProtocol {
    /**
     Kullanıcı giriş yapmak istediği zaman firebase tarafından dönen yanıt buraya geliyor.
     Dönen yanıt Resource sınıfı ile sarmalanmış yapıda, generic olan data kısmı ise UserState (enum) sınıfı tipinde.
     */
    func loginResponse(status: Resource<UserState>) {
        DispatchQueue.main.async {
            if status.status! == .SUCCESS{
                /**
                 Kullanıcı başarılı bir şekilde login oluyor olabilir lakin mail adresinin onaylanmış olmama durumu mevcut.
                 Bunun kontrolünü yapıyorum.
                 Kullanıcı Onaylı ise ;
                 - Kullanıcıya ait hobiler kontrol edilir, eğer hobisi yok ise hobi seçme ekranına yönlendirilir.
                 */
                if status.data == .MAIL_ADRESS_CONFIRMED {
                    self.loginErrorMessageLabel.isHidden = true
                    self.performSegue(withIdentifier: "loginToRouterVC", sender: nil)
                }
                else if status.data == .MAIL_ADRESS_NOT_CONFIRMED {
                    // Kullanıcıya hesabının onaylanmadığını bildiriyorum.
                    self.loginErrorMessageLabel.text = "Your account is not verified. Please confirm your mail adress."
                    self.loginErrorMessageLabel.isHidden = false
                    
                    // Hesabını onaylaması için onay konteynırını görünür bir hale getireceğim.
                    self.mailConfirmationContainer.isHidden = false
                }
            }
            else if status.status! == .ERROR {
                print("Login error : \(status.message!)")
            }
        }
    }
    
    func verificationLinkResponse(status: Resource<Any>) {
        DispatchQueue.main.async {
            if status.status == .SUCCESS {
                self.loginErrorMessageLabel.isHidden = true
                self.sendVerificationButtonOutlet.isEnabled = false
                self.countTimer = Timer.scheduledTimer(timeInterval: 1 ,
                                                             target: self,
                                                             selector: #selector(self.changeLabel),
                                                             userInfo: nil,
                                                             repeats: true)
            }
        }
    }
    @objc
    private func changeLabel(){
        if counter != 0
             {
            self.sendVerificationButtonOutlet.setTitle("\(counter) sonra yeniden mail gonderebilirsiniz.", for: .normal)
                 counter -= 1
             }
             else
             {
                 self.sendVerificationButtonOutlet.setTitle("Onay Linki Gönder", for: .normal)
                 self.sendVerificationButtonOutlet.isEnabled = true
                  countTimer.invalidate()
                
             }
    }
}
