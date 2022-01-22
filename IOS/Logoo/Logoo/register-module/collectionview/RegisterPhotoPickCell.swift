//
//  RegisterPhotoPickCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 20.01.2022.
//

import UIKit

class RegisterPhotoPickCell: UICollectionViewCell,ValidationProtocol {
    func validate() -> ValidationResponse {
        return ValidationResponse(status: true, message: "foto doğrulama okey")
    }
}
