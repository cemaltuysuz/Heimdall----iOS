//
//  RegisterInformationCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 20.01.2022.
//

import UIKit

class RegisterInformationCell: UICollectionViewCell, RegisterProtocol {
    
    func validate() -> ValidationResponse {
        return ValidationResponse(status: true, message: "info okey")
    }
    
    func initialize() {
        
    }
}
