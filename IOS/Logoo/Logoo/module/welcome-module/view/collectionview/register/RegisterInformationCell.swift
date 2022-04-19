//
//  RegisterInformationCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 24.02.2022.
//

import UIKit
import FirebaseFirestoreSwift
import FirebaseFirestore

protocol RegisterInformationCellProtocol : AnyObject {
    func informationToView(username:String,userMail:String,userPassword:String)
    func informationRealtimeValidation(response:ValidationResponse)
}

class RegisterInformationCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var registerUsernameTextField: CustomUITextField!
    @IBOutlet weak var registerMailTextField: CustomUITextField!
    @IBOutlet weak var registerPasswordTextField: CustomUITextField!
    
    private var isEmailUsed:Bool?
    private var isUsernameUsed:Bool?
    
    private var pendingRequestWorkItem: DispatchWorkItem?
    
    weak var delegate:RegisterInformationCellProtocol?
    
    override func awakeFromNib() {
        configureUI()
        initialize()
    }
    
    func configureUI(){
        titleLabel.text = "Fill The Informations".localized()
        registerUsernameTextField.placeholder = "username".localized()
        registerMailTextField.placeholder = "E-mail adress".localized()
        registerPasswordTextField.placeholder = "Password".localized()
    }
    
    func initialize() {
        addInputAccessoryForTextFields(textFields: [registerUsernameTextField,registerMailTextField,registerPasswordTextField], dismissable: true, previousNextable: true)
        registerUsernameTextField.addTarget(self, action: #selector(self.usernameTextDidChange(_:)), for: .editingChanged)
        registerPasswordTextField.addTarget(self, action: #selector(self.userMailTextDidChange(_:)), for: .editingChanged)
        registerPasswordTextField.customDelegate = self
        isEmailUsed = true
        isUsernameUsed = true
    }
}

extension RegisterInformationCell : Registerable {
    func validate() -> ValidationResponse {
        if let username = registerUsernameTextField.text, let mail = registerMailTextField.text, let password = registerPasswordTextField.text, !username.isEmpty, !mail.isEmpty, !password.isEmpty {
            
            let result = BaseValidator.validate(validators: [UsernameValidator(username: username),MailValidator(mail: mail),PasswordValidator(password: password)])
            if result.isSuccess {
                if !isUsernameUsed!{
                    if !isEmailUsed! {
                        delegate?.informationToView(username: username, userMail: mail, userPassword: password)
                        return ValidationResponse(status: true, message: "Successfull.")
                    }else {
                        return ValidationResponse(status: false, message: "This email address is being used by another account.".localized())
                    }
                }else {
                    return ValidationResponse(status: false, message: "This username is being used by another account.".localized())
                }
            }else {
                return ValidationResponse(status: false, message: result.message!)
            }
        }else {
            return ValidationResponse(status: false, message: "Please fill in all fields.".localized())
        }
    }
}

extension RegisterInformationCell {
    @objc
    func usernameTextDidChange(_ textField: UITextField){
        DispatchQueue.main.async {
            self.pendingRequestWorkItem?.cancel()
            
            if let text = textField.text , !text.isEmpty {
                let requestWorkItem = DispatchWorkItem { [weak self] in
                    let ref = Firestore.firestore().collection(FireStoreCollection.USER_COLLECTION)
                    FireStoreService.shared.getDocumentsByField(ref: ref, getByField: "username", getByValue: text, onCompletion: {
                        (users:[User?]?, error:Error?) in
                        guard  error == nil else {
                            print("Error:\(error?.localizedDescription ?? "not found")")
                            return
                        }
                        if let users = users, users.count > 0 {
                            self?.delegate?.informationRealtimeValidation(response: ValidationResponse(status: false, message: "This username is being used by another account.".localized()))
                            self?.isUsernameUsed = true
                        }else {
                            self?.delegate?.informationRealtimeValidation(response: ValidationResponse(status: true, message: nil))
                            self?.isUsernameUsed = false
                        }
                    })
                }
                // I created a work with 250 millisecond delay.
                self.pendingRequestWorkItem = requestWorkItem
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250),
                                                      execute: requestWorkItem)
            }
        }
    }
    
    @objc
    func userMailTextDidChange(_ textField: UITextField){
        DispatchQueue.main.async {
            self.pendingRequestWorkItem?.cancel()
            
            if let text = textField.text , !text.isEmpty {
                let requestWorkItem = DispatchWorkItem { [weak self] in
                    let ref = Firestore.firestore().collection(FireStoreCollection.USER_COLLECTION)
                    FireStoreService.shared.getDocumentsByField(ref: ref, getByField: "userMail", getByValue: text, onCompletion: {
                        (users:[User?]?, error:Error?) in
                        guard  error == nil else {
                            print("Error:\(error?.localizedDescription ?? "not found")")
                            return
                        }
                        if let users = users, users.count > 0 {
                            self?.delegate?.informationRealtimeValidation(response: ValidationResponse(status: false, message: "This email address is being used by another account.".localized()))
                            self?.isEmailUsed = true
                        }else {
                            self?.delegate?.informationRealtimeValidation(response: ValidationResponse(status: true, message: nil))
                            self?.isEmailUsed = false
                        }
                    })
                }
                // I created a work with 250 millisecond delay.
                self.pendingRequestWorkItem = requestWorkItem
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250),
                                                      execute: requestWorkItem)
            }
        }
    }
}

extension RegisterInformationCell : CustomUITextFieldProtocol {
    func onRightButtonClick(_ textField: CustomUITextField, isActive: Bool) {
        registerPasswordTextField.isSecureTextEntry = !isActive
        if isActive {
            registerPasswordTextField.rightImage = UIImage(systemName: "eye.fill")
        }else {
            registerPasswordTextField.rightImage = UIImage(systemName: "eye.slash.fill")
        }
    }
}

extension RegisterInformationCell : RegisterBindable {
    func bind(_ viewController: RegisterVC) {
        delegate = viewController
    }
}
