//
//  RegisterInformationCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 20.01.2022.
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
                        return ValidationResponse(status: true, message: "info okey")
                    }else {
                        return ValidationResponse(status: false, message: "Şifre en az 6 karakterli olmalıdır.")
                    }
                }else {
                    return ValidationResponse(status: false, message: "Geçersiz e-mail adresi.")
                }
            }else{
                return ValidationResponse(status: false, message: "Kullanıcı adı en az 2 ve en fazla 12 karakterden oluşmalıdır.")
            }
        }else {
            return ValidationResponse(status: false, message: "Eksik bilgi.")
        }
    }
    
    func initialize(informationProtocol:RegisterInformationCellProtocol) {
        self.toView = informationProtocol
    }
}

protocol RegisterInformationCellProtocol {
    func informationToView(username:String,userMail:String,userPassword:String)
}
