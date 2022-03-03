//
//  MailValidator.swift
//  Logoo
//
//  Created by cemal tüysüz on 3.03.2022.
//

import Foundation

class MailValidator : Validatable {
    
    private var mail:String!
    
    init(mail:String){
        self.mail = mail
    }
    
    func validate() -> ValidateResult {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        if emailPred.evaluate(with: mail) {
            return ValidateResult(isSuccess: true, message: "Success".localized())
        }
        return ValidateResult(isSuccess: false, message: "This email address is not correct format.".localized())
    }
}
