//
//  BaseValidator.swift
//  Logoo
//
//  Created by cemal tüysüz on 3.03.2022.
//

import Foundation

class BaseValidator {
    static func validate (validators:[Validatable]) -> ValidateResult {
        for validator in validators {
            let result = validator.validate()
            if !result.isSuccess {
                return result
            }
        }
        return ValidateResult(isSuccess: true, message: "Success".localized)
    }
}
