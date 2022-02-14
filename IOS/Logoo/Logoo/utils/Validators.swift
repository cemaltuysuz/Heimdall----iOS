//
//  Validators.swift
//  Logoo
//
//  Created by cemal tüysüz on 14.02.2022.
//

import Foundation

/**
 ***Username Validator**
 * Input range : 7 - 8
 * No Special Character  (&%^+ etc.)
 * Only letters, numbers or underscores
 */
func isValidUsername(username:String) -> Bool {
    return username.range(of: "\\A\\w{7,18}\\z", options: .regularExpression) != nil
}

// Mail Validate
func isValidMail(mail:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    
    return emailPred.evaluate(with: mail)
}

/**
 *** Password Validator**
 * InputRange -> 8+
 * Special Char. -> min(1)
 */

public func isValidPassword(password:String) -> Bool {
    let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
    return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
}

