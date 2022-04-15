//
//  RegisterCellType.swift
//  Logoo
//
//  Created by cemal tüysüz on 11.04.2022.
//
import Foundation
import UIKit

enum RegisterCellType: Int {
    case PHOTO_CHOOSE_CELL
    case INFORMATION_CELL
    case BIRTH_OF_DATE_CELL
    case GENDER_CELL
    case CONFIRM_CELL
}

extension RegisterCellType {
    
    func getCurrentIdentifier() -> String{
        switch self {
        case .PHOTO_CHOOSE_CELL:
            return RegisterPhotoChooseCell.reuseIdentifier
        case .INFORMATION_CELL:
            return RegisterInformationCell.reuseIdentifier
        case .BIRTH_OF_DATE_CELL:
            return RegisterBirthDayCell.reuseIdentifier
        case .GENDER_CELL:
            return RegisterGenderCell.reuseIdentifier
        case .CONFIRM_CELL:
            return RegisterConfirmCell.reuseIdentifier
        }
    }
}

