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
                self.loginErrorMessageLabel.text = "The e-mail address is not in the correct format.".localized()
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
     The response from the network part when the user wants to log in.
     */
    func loginResponse(status: Resource<UserState>) {
        DispatchQueue.main.async {
            if status.status! == .SUCCESS{
                /**
                 I check if the user's e-mail address is approved.
                 */
                if status.data == .MAIL_ADRESS_CONFIRMED {
                    self.loginErrorMessageLabel.isHidden = true
                    self.performSegue(withIdentifier: LoginVCSegues
                                        .LoginToRouter
                                        .rawValue, sender: nil)
                }
                else if status.data == .MAIL_ADRESS_NOT_CONFIRMED {
                    // I'm notifying the user that their account has not been confirmed.
                    self.loginErrorMessageLabel.text = "Your account is not verified. Please confirm your mail adress.".localized()
                    self.loginErrorMessageLabel.isHidden = false
                    
                    // I will make the confirmation container visible for her to approve her account.
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
            self.sendVerificationButtonOutlet.setTitle("Time to resubmit:".localized() + "\(counter)", for: .normal)
                 counter -= 1
             }
             else
             {
                 self.sendVerificationButtonOutlet.setTitle("Send Confirmation Link".localized(), for: .normal)
                 self.sendVerificationButtonOutlet.isEnabled = true
                  countTimer.invalidate()
                
             }
    }
}

enum LoginVCSegues : String {
    case LoginToRouter = "loginToRouterVC"
}
