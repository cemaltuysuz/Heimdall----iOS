//
//  UsernameValidator.swift
//  Logoo
//
//  Created by cemal tüysüz on 3.03.2022.
//

import Foundation

class UsernameValidator : Validatable {
    
    private var username:String!
    
    
    init(username:String){
        self.username = username
    }
    
    func validate() -> ValidateResult {
        let result = username.range(of: "\\A\\w{7,18}\\z", options: .regularExpression) != nil
        
        if result {
            return ValidateResult(isSuccess: true, message: "success".localized())
        }
        
        return ValidateResult(isSuccess: false, message: "usernameRules".localized())
    }

}
