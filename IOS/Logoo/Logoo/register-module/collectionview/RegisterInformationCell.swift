//
//  RegisterInformationCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 24.02.2022.
//

import UIKit
import FirebaseFirestoreSwift
import FirebaseFirestore

class RegisterInformationCell: UICollectionViewCell, RegisterProtocol {

    @IBOutlet weak var registerUsernameLabel: UITextField!
    @IBOutlet weak var registerMailLabel: UITextField!
    @IBOutlet weak var registerPasswordLabel: UITextField!
    
    private var isEmailUsed:Bool?
    private var isUsernameUsed:Bool?
    
    private var pendingRequestWorkItem: DispatchWorkItem?
    
    var toView:RegisterInformationCellProtocol?
    
    func validate() -> ValidationResponse {
        // Global check for empty text
        if let username = registerUsernameLabel.text, let mail = registerMailLabel.text, let password = registerPasswordLabel.text {
           // Kullanıcı adı kontrolu yapıyorum.
           // Kullanıcı adı için karakter sayısı 2'den buyuk ve 12 den kucuk olması gerekiyor.
            
            if isValidUsername(username: username) {
                if isValidMail(mail: mail) {
                    if isValidPassword(password: password) {
                        if !isEmailUsed! {
                            if !isUsernameUsed! {
                                return ValidationResponse(status: true, message: "Successfull.")
                            }else {
                                return ValidationResponse(status: false, message: "This username is already exist.")
                            }
                        }else {
                            return ValidationResponse(status: false, message: "This mail is already exist.")
                        }
                    }else {
                        return ValidationResponse(status: false, message: "passwordRules".localized())
                    }
                }else {
                    return ValidationResponse(status: false, message: "This email address is not correct format.".localized())
                }
            }else{
                return ValidationResponse(status: false, message: "usernameRules".localized())
            }
        }else {
            return ValidationResponse(status: false, message: "Please fill in all fields.".localized())
        }
    }
    
    func initialize(informationProtocol:RegisterInformationCellProtocol) {
        self.toView = informationProtocol
        self.registerUsernameLabel.addTarget(self, action: #selector(self.usernameTextDidChange(_:)), for: .editingChanged)
        self.registerMailLabel.addTarget(self, action: #selector(self.userMailTextDidChange(_:)), for: .editingChanged)
        
        self.isEmailUsed = true
        self.isUsernameUsed = true
    }
    
    @objc
    func usernameTextDidChange(_ textField: UITextField){
        DispatchQueue.main.async {
            self.pendingRequestWorkItem?.cancel()
            
            if let text = textField.text , !text.isEmpty {
                let requestWorkItem = DispatchWorkItem { [weak self] in
                    let ref = Firestore.firestore().collection(FireCollections.USER_COLLECTION)
                    FireStoreService<User>().getDocumentsByField(ref: ref, getByField: "username", getByValue: text, onCompletion: {
                        users,error in
                        guard  error == nil else {
                            print("Error:\(error?.localizedDescription ?? "not found")")
                            return
                        }
                        if let users = users, users.count > 0 {
                            self?.toView?.usernameRealtimeValidation(response: ValidationResponse(status: false, message: "This username is already exist."))
                            self?.isUsernameUsed = true
                        }else {
                            self?.toView?.usernameRealtimeValidation(response: ValidationResponse(status: true, message: nil))
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
                    let ref = Firestore.firestore().collection(FireCollections.USER_COLLECTION)
                    FireStoreService<User>().getDocumentsByField(ref: ref, getByField: "userMail", getByValue: text, onCompletion: {
                        users,error in
                        guard  error == nil else {
                            print("Error:\(error?.localizedDescription ?? "not found")")
                            return
                        }
                        if let users = users, users.count > 0 {
                            self?.toView?.mailRealtimeValidation(response: ValidationResponse(status: false, message: "This mail is already exist."))
                            self?.isEmailUsed = true
                        }else {
                            self?.toView?.mailRealtimeValidation(response: ValidationResponse(status: true, message: nil))
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

protocol RegisterInformationCellProtocol {
    func informationToView(username:String,userMail:String,userPassword:String)
    func usernameRealtimeValidation(response:ValidationResponse)
    func mailRealtimeValidation(response:ValidationResponse)
}
