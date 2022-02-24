//
//  RegisterInformationCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 24.02.2022.
//

import UIKit

class RegisterInformationCell: UICollectionViewCell, RegisterProtocol {

    @IBOutlet weak var registerUsernameLabel: UITextField!
    @IBOutlet weak var registerMailLabel: UITextField!
    @IBOutlet weak var registerPasswordLabel: UITextField!
    
    var toView:RegisterInformationCellProtocol?
    
    func validate() -> ValidationResponse {
        // Global check for empty text
        if let username = registerUsernameLabel.text, let mail = registerMailLabel.text, let password = registerPasswordLabel.text {
           // Kullanıcı adı kontrolu yapıyorum.
           // Kullanıcı adı için karakter sayısı 2'den buyuk ve 12 den kucuk olması gerekiyor.
            
            if isValidUsername(username: username) {
                
                if isValidMail(mail: mail) {
                    
                    if isValidPassword(password: password) {
                        toView?.informationToView(username: username, userMail: mail, userPassword: password)
                        return ValidationResponse(status: true, message: "Successfull.")
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
    }
}

protocol RegisterInformationCellProtocol {
    func informationToView(username:String,userMail:String,userPassword:String)
}
