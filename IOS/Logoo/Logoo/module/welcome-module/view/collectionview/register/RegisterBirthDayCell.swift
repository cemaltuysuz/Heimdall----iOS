//
//  RegisterBirthDayCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 24.02.2022.
//

import UIKit

protocol RegisterBirthDayCellProtocol : AnyObject {
    func birthDaySelected(date:String)
}

class RegisterBirthDayCell: UICollectionViewCell {

    weak var delegate:RegisterBirthDayCellProtocol?
    
    @IBOutlet weak var registerBirthDayDatePicker: UIDatePicker!
    
    
    override func awakeFromNib() {
        initialize()
    }
    
    func initialize() {
        self.registerBirthDayDatePicker.datePickerMode = .date
        if #available(iOS 13.4, *){
            registerBirthDayDatePicker.preferredDatePickerStyle = .wheels
        }
    }
}

extension RegisterBirthDayCell : Registerable {
    func validate() -> ValidationResponse {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY"
        let strDate = dateFormatter.string(from: registerBirthDayDatePicker.date)
        
        delegate?.birthDaySelected(date: strDate)
        return ValidationResponse(status: true, message: "birth okey")
    }
}

extension RegisterBirthDayCell : RegisterBindable {
    func bind(_ viewController: RegisterVC) {
        delegate = viewController
    }
}
