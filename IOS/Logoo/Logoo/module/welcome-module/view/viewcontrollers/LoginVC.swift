//
//  LoginVC.swift
//  Logoo
//
//  Created by cemal tüysüz on 25.01.2022.
//

import UIKit

class LoginVC: BaseVC {

    @IBOutlet weak var loginUserMail: CustomUITextField!
    @IBOutlet weak var loginUserPassword: CustomUITextField!
    @IBOutlet weak var loginButtonOutlet: UIButton!
    @IBOutlet weak var forgetPasswordButtonOutlet: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginErrorMessageLabel: UILabel!
    
    @IBOutlet weak var mailConfirmationContainer: UIStackView!
    @IBOutlet weak var sendVerificationButtonOutlet: UIButton!
    var incomingMail:String?
    var countTimer:Timer!
    var counter:Int64!
    
    var presenter:ViewToPresenterLoginProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        counter = 100
        configureUI()
        
        if let mail = incomingMail {
            self.loginUserMail.text = mail
        }
        LoginRouter.createModule(ref: self)
        presenter?.calculateRepeatTime()
        configureBinds()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let currentTime = counter, currentTime > 0, !mailConfirmationContainer.isHidden {
            UDService.shared.setConfirmEmailSecond(second: currentTime)
        }
    }
    
    func configureUI(){
        view.addInputAccessoryForTextFields(textFields: [loginUserMail,loginUserPassword], dismissable: true, previousNextable: true)
        
        loginUserMail.placeholder = "E-mail Adress".localized()
        loginUserPassword.placeholder = "Password".localized()
        loginButtonOutlet.setTitle("Login".localized(), for: .normal)
        forgetPasswordButtonOutlet.setTitle("I forget my password".localized(), for: .normal)
        sendVerificationButtonOutlet.setTitle("Send Confirmation Link".localized(), for: .normal)
        registerButton.setTitle("Not registered ? Register".localized(), for: .normal)
    }
    
    func configureBinds(){
        loginUserPassword.customDelegate = self
    }
    
    @IBAction func loginButton(_ sender: Any) {
        if let mail = loginUserMail.text, let password = loginUserPassword.text {
            let result = MailValidator(mail: mail).validate()
            if result.isSuccess {
                presenter?.loginUser(mail: mail, password: password)
                loginErrorMessageLabel.isHidden = true
            }else {
                loginErrorMessageLabel.text = result.message!
                loginErrorMessageLabel.isHidden = false
            }
        }
    }
    
    @IBAction func sendMailVerification(_ sender: Any) {
         if let mail = loginUserMail.text  {
             let result = MailValidator(mail: mail).validate()
             if result.isSuccess{
                 presenter?.sendVerificationLink(mail: mail)
             }
         }
    }
    
    private func startTimer(){
        DispatchQueue.main.async {
                self.loginErrorMessageLabel.isHidden = true
                self.sendVerificationButtonOutlet.isEnabled = false
                self.countTimer = Timer.scheduledTimer(timeInterval: 1 ,
                                                             target: self,
                                                             selector: #selector(self.changeLabel),
                                                             userInfo: nil,
                                                             repeats: true)
        }
    }
    @IBAction func onForgotPasswordClick(_ sender: Any) {
        let vc = ResetPasswordVC.instantiate(from: .Welcome)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func mailVerificationMode(){
        // Notifying the user that their account has not been confirmed.
        loginErrorMessageLabel.text = "Your account is not verified. Please confirm your mail adress.".localized()
        loginErrorMessageLabel.isHidden = false
        
        mailConfirmationContainer.isHidden = false
    }
}

extension LoginVC : PresenterToViewLoginProtocol {
    func timeLimitCountinues(status: Bool,continuationTime:Int64?) {
        if status {
            mailVerificationMode()
            counter = continuationTime
            startTimer()
        }else {
            mailConfirmationContainer.isHidden = true
        }
    }
    
    /**
     The response from the network part when the user wants to log in.
     */
    func loginResponse(status: Resource<UserState>) {
        DispatchQueue.main.async {
            if status.status! == .SUCCESS{

                if status.data == .MAIL_ADRESS_CONFIRMED {
                    self.loginErrorMessageLabel.isHidden = true

                    let vc = LoginRouterVC.instantiate(from: .Welcome)
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                }
                else if status.data == .MAIL_ADRESS_NOT_CONFIRMED {
                    self.mailVerificationMode()
                }
            }
            else if status.status! == .ERROR {
                print("Login error : \(status.message!)")
            }
        }
    }
    
    func verificationLinkResponse(status: Resource<Any>) {
        if status.status == .SUCCESS {
            startTimer()
        }
    }
    
    @objc
    private func changeLabel(){
        if counter != 0
        {
            sendVerificationButtonOutlet.setTitle("Time to resubmit:".localized() + "\(counter!)", for: .normal)
            counter -= 1
        }
        else
        {
            sendVerificationButtonOutlet.setTitle("Send Confirmation Link".localized(), for: .normal)
            sendVerificationButtonOutlet.isEnabled = true
            countTimer.invalidate()
            counter = 100
        }
    }
}

extension LoginVC : CustomUITextFieldProtocol {
    func onRightButtonClick(_ textField: CustomUITextField, isActive: Bool) {
        
        textField.isSecureTextEntry = !isActive
        if isActive {
            textField.rightImage = UIImage(systemName: "eye.fill")
        }else {
            textField.rightImage = UIImage(systemName: "eye.slash.fill")
        }
    }
}
