//
//  ResetPasswordVC.swift
//  Logoo
//
//  Created by cemal tüysüz on 16.02.2022.
//

import UIKit

class ResetPasswordVC: BaseVC {
    var presenter:ViewToPresenterResetPasswordProtocol?
    
    @IBOutlet weak var screenDescriptionLabel: UILabel!
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var resetMailErrorLabel: UILabel!
    @IBOutlet weak var resetMailTextField: CustomUITextField!
    @IBOutlet weak var sendResetLinkButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ResetPasswordRouter.createModule(ref: self)
        configureUI()
        
    }
    
    func configureUI(){
        screenTitleLabel.text = "Reset Password".localized()
        screenDescriptionLabel.text = "reset_password_description".localized()
        resetMailTextField.placeholder = "E-mail adress".localized()
        sendResetLinkButtonOutlet.setTitle("Send Reset Link".localized(), for: .normal)
    }
    
    
    @IBAction func sendResetLinkButton(_ sender: Any) {
        if let mail = resetMailTextField.text {
            let result = MailValidator(mail: mail).validate()
            if !result.isSuccess {
                resetMailErrorLabel.text = result.message!
                resetMailErrorLabel.isHidden = false
            }else {
                resetMailErrorLabel.isHidden = true
                showCurtain()
                presenter?.sendResetLink(mail: mail)
            }
        }
    }
}

extension ResetPasswordVC : PresenterToViewResetPasswordProtocol {
    func sendLinkResponse(resp: Status) {
        var alert:UIAlertController?
        closeCurtain()
        if resp == .SUCCESS {
            alert = UIAlertController(title: "Successfully".localized(),
                                      message: "The connection was sent successfully. Check your inbox.".localized(),
                                      preferredStyle: .alert)
            alert!.addAction(
                UIAlertAction(title: "Close".localized(),
                              style: .cancel, handler: {_ in
                                  self.navigationController?.popViewController(animated: true)
           }))
            self.present(alert!, animated: true)
            
        }else {
            print("false")
            alert = UIAlertController(title: "Failed".localized(),
                                      message: "Something went wrong. Please check your e-mail address.".localized(),
                                      preferredStyle: .alert)
            alert!.addAction(
                UIAlertAction(title: "Close".localized(),
                              style: .cancel)
            )
            self.present(alert!, animated: true)
        }
    }

}
