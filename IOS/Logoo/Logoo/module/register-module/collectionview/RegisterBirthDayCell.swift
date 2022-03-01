//
//  RegisterBirthDayCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 24.02.2022.
//

import UIKit

class RegisterBirthDayCell: UICollectionViewCell, RegisterProtocol {

    var toView:RegisterBirthDayCellProtocol?
    
    @IBOutlet weak var registerBirthDayDatePicker: UIDatePicker!
    
    func validate() -> ValidationResponse {
        let dateFormatter = DateFormatter()
        // Set Date Format
        dateFormatter.dateFormat = "dd.MM.YYYY"
        // Convert Date to String
        let strDate = dateFormatter.string(from: self.registerBirthDayDatePicker.date)
        
        toView?.birthDaySelected(date: strDate)
        return ValidationResponse(status: true, message: "birth okey")
    }
    
    func initialize(birthDayCellProtocol:RegisterBirthDayCellProtocol) {
        self.toView = birthDayCellProtocol
        self.registerBirthDayDatePicker.datePickerMode = .date
        if #available(iOS 13.4, *){
            self.registerBirthDayDatePicker.preferredDatePickerStyle = .wheels
        }
    }
    
}

protocol RegisterBirthDayCellProtocol {
    func birthDaySelected(date:String)
}

