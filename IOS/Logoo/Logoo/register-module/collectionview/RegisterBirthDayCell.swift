//
//  RegisterBirthDayCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 3.02.2022.
//

import UIKit

class RegisterBirthDayCell: UICollectionViewCell, RegisterProtocol {
    
    @IBOutlet weak var registerBirthDayDatePicker: UIDatePicker!
    
    func validate() -> ValidationResponse {
        return ValidationResponse(status: true, message: "birth okey")
    }
    
    func initialize() {
        self.registerBirthDayDatePicker.datePickerMode = .date
        if #available(iOS 13.4, *){
            self.registerBirthDayDatePicker.preferredDatePickerStyle = .wheels
        }
    }
    
}
