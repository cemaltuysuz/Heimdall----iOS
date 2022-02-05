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
    
    func validate() -> ValidationResponse {
        // Global check for empty text
        if let username = registerUsernameLabel.text, let mail = registerMailLabel.text, let password = registerPasswordLabel.text {
           // Kullanıcı adı kontrolu yapıyorum.
           // Kullanıcı adı için karakter sayısı 2'den buyuk ve 12 den kucuk olması gerekiyor.
            
            if username.count > 2 && username.count < 12 {
                
                let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
                let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
                
                // Mail için doğrulama yapılıyor.
                if emailPred.evaluate(with: mail) {
                    
                    if password.count > 6 {
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
    
    func initialize() {
        
    }
}
