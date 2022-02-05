//
//  RegisterOTPCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 20.01.2022.
//

import UIKit

class RegisterOTPCell: UICollectionViewCell, RegisterProtocol {
    
    func validate() -> ValidationResponse {
        return ValidationResponse(status: true, message: "otp başarılı")
    }
    
    func initialize() {
        
    }
}
