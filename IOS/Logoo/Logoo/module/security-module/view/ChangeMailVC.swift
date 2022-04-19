//
//  ChangeMailVC.swift
//  Logoo
//
//  Created by cemal tüysüz on 5.04.2022.
//

import UIKit

class ChangeMailVC: BaseVC {
    
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var screenDescriptionLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var newMailAdressTextField: CustomUITextField!
    @IBOutlet weak var currentPasswordTextField: CustomUITextField!
    @IBOutlet weak var okButtonOutlet: UIButton!
    var presenter : ViewToPresenterChangeMailProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        ChangeMailRouter.createModule(ref: self)

        configureUI()
        configureBinds()
    }
    
    func configureUI(){
        screenTitleLabel.text = "Change Mail".localized()
        screenDescriptionLabel.text = "Change_Mail_Screen_Description".localized()
        okButtonOutlet.setTitle("Okey".localized(), for: .normal)
        newMailAdressTextField.placeholder = "Enter your new mail adress".localized()
        currentPasswordTextField.placeholder = "Enter your current password".localized()
        view.addInputAccessoryForTextFields(textFields: [newMailAdressTextField, currentPasswordTextField], dismissable: true, previousNextable: true)
        
    }
    
    func configureBinds() {
        currentPasswordTextField.customDelegate = self
    }
    @IBAction func okButtonAction(_ sender: Any) {
        if let currentPass = currentPasswordTextField.text, !currentPass.isEmpty, let newMail = newMailAdressTextField.text, !newMail.isEmpty {
            let validateResult = MailValidator(mail: newMail).validate()
            if validateResult.isSuccess {
                presenter?.reAuthRequest(currentPassword: currentPass)
                errorLabel.isHidden = true
                errorLabel.text = ""
            }else {
                errorLabel.text = validateResult.message
                errorLabel.isHidden = false
            }
        }else {
            errorLabel.text = "Please fill in the missing fields".localized()
            errorLabel.isHidden = false
        }
    }
}

extension ChangeMailVC : PresenterToViewChangeMailProtocol {
    func onStateChange(state: ChangeMailState) {
        closeCurtain()
        switch state {
        case .CURTAIN:
            showCurtain()
            break
        case .RE_AUTH_FAIL(let message):
            createAlertNotify(title: "Error".localized(), message: message)
            break
        case .CHANGE_MAIL_FAIL(let message):
            createAlertNotify(title: "Error".localized(), message: message)
            break
        case .SUCCESS_RE_AUTH(let oldMail):
            let message = "Do you approve the update of your e-mail address?".localized() + "\n" + "Old :".localized() + "\(oldMail)" + "\n" + "New :".localized() + newMailAdressTextField.text!
            createBasicAlertSheet(title: "Alert".localized(), message: message, okTitle: "Approve".localized(), onCompletion: { type in
                switch type {
                case .CONFIRM:
                    self.showCurtain()
                    self.presenter?.doChangeMail(mail: self.newMailAdressTextField.text!)
                    break
                case .DISMISS:
                    break
                }
            })
            break
        case .SUCCESS_MAIL_CHANGE:
            createAlertNotify(title: "Success".localized(), message: "do_change_mail_success_message".localized() + "\n\(newMailAdressTextField.text!)".localized(), onCompletion: {
                self.navigationController?.popViewController(animated: true)
            })
            break
        }
    }
}

extension ChangeMailVC : CustomUITextFieldProtocol {
    
    func onRightButtonClick(_ textField: CustomUITextField, isActive: Bool) {
        textField.isSecureTextEntry = !isActive
        if isActive {
            textField.rightImage = UIImage(systemName: "eye.fill")
        }else {
            textField.rightImage = UIImage(systemName: "eye.slash.fill")
        }
    }
}

enum ChangeMailState {
    case CURTAIN
    case RE_AUTH_FAIL(message:String)
    case CHANGE_MAIL_FAIL(message:String)
    case SUCCESS_RE_AUTH(oldMail:String)
    case SUCCESS_MAIL_CHANGE
}


