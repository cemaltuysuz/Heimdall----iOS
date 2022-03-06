//
//  PasswordValidator.swift
//  Logoo
//
//  Created by cemal tüysüz on 3.03.2022.
//

import Foundation

class PasswordValidator:Validatable {
    
    private var password:String!
    
    init(password:String? = nil){
        self.password = password
    }
    
    func validate() -> ValidateResult {
        let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
        let result =  NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
        
        if result {
            return ValidateResult(isSuccess: true, message: "success".localized())
        }
        return ValidateResult(isSuccess: false, message: "passwordRules".localized())
    }
    
    func changeValueAndReValidate(value: String) -> ValidateResult {
        self.password = value
        return validate()
    }
}
