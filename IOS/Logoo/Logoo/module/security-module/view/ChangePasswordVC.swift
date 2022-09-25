//
//  ChangePasswordVC.swift
//  Logoo
//
//  Created by cemal tüysüz on 5.04.2022.
//

import UIKit

class ChangePasswordVC: BaseVC {
    
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var screenDescriptionLabel: UILabel!
    @IBOutlet weak var currentPasswordTextField: CustomUITextField!
    @IBOutlet weak var newPasswordTextField: CustomUITextField!
    @IBOutlet weak var reNewPasswordTextField: CustomUITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var okButtonOutlet: UIButton!
    
    
    var presenter:ViewToPresenterChangePasswordProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        ChangePasswordRouter.createModule(ref: self)
        
        configureUI()
        configureBinds()
        
    }
    
    func configureUI(){
        screenTitleLabel.text = "Change Password".localized
        screenDescriptionLabel.text = "Change_Password_Screen_Description".localized
        currentPasswordTextField.placeholder = "Enter your current password".localized
        
        currentPasswordTextField.placeholder = "Enter your current password".localized
        newPasswordTextField.placeholder = "Enter your new password".localized
        reNewPasswordTextField.placeholder = "Re-Enter your new password".localized
        okButtonOutlet.setTitle("Okey".localized, for: .normal)
        
        view.addInputAccessoryForTextFields(textFields: [currentPasswordTextField,newPasswordTextField,reNewPasswordTextField])
        
    }

    func configureBinds(){
        currentPasswordTextField.customDelegate = self
        newPasswordTextField.customDelegate = self
        reNewPasswordTextField.customDelegate = self
    }
    
    @IBAction func okButton(_ sender: Any) {
        if let currentPass = currentPasswordTextField.text, !currentPass.isEmpty, let newPass = newPasswordTextField.text, !newPass.isEmpty, let reNewPass = reNewPasswordTextField.text, !reNewPass.isEmpty {
            if newPass == reNewPass {
                let validateResult = PasswordValidator(password: newPass).validate()
                if validateResult.isSuccess {
                    errorLabel.text = ""
                    errorLabel.isHidden = true
                    presenter?.resetPasswordRequest(currentPassword: currentPass, newPassword: newPass)
                }else {
                    errorLabel.text = validateResult.message
                    errorLabel.isHidden = false
                }
            }else {
                errorLabel.text = "Passwords entered must be equal.".localized
                errorLabel.isHidden = false
            }
        }else {
            errorLabel.text = "Please fill in the missing fields".localized
            errorLabel.isHidden = false
        }
    }
}

extension ChangePasswordVC : PresenterToViewChangePasswordProtocol {
    func onStateChange(state: ChangePasswordState) {
        switch state {
        case .CLEAR_CURTAIN:
            closeCurtain()
        case .CURTAIN:
            showCurtain()
        case .CHANGE_PASSWORD_SUCCESS:
            closeCurtain()
            createAlertNotify(title: "Success".localized, message: "Your password has been successfully updated.".localized, onCompletion: { [weak self] in
                guard let strongSelf = self else {return}
                strongSelf.navigationController?.popViewController(animated: true)
            })
        case .CHANGE_PASSWORD_FAIL(message: let msg):
            closeCurtain()
            createAlertNotify(title: "Error".localized, message: msg, onCompletion: {
                self.errorLabel.text = ""
                self.errorLabel.isHidden = true
                self.currentPasswordTextField.text = ""
            })
            break
        }
    }
}

extension ChangePasswordVC : CustomUITextFieldProtocol {
    func onRightButtonClick(_ textField: CustomUITextField, isActive: Bool) {
        textField.isSecureTextEntry = !isActive
        if isActive {
            textField.rightImage = UIImage(systemName: "eye.fill")
        }else {
            textField.rightImage = UIImage(systemName: "eye.slash.fill")
        }
    }
}

enum ChangePasswordState {
    case CLEAR_CURTAIN
    case CURTAIN
    case CHANGE_PASSWORD_SUCCESS
    case CHANGE_PASSWORD_FAIL(message:String)
}
