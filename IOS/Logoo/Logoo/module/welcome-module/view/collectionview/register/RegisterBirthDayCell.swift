//
//  RegisterBirthDayCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 24.02.2022.
//

import UIKit

protocol RegisterBirthDayCellProtocol : AnyObject {
    func birthDaySelected(birthDay:String)
}

class RegisterBirthDayCell: UICollectionViewCell {

    weak var delegate:RegisterBirthDayCellProtocol?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var registerBirthDayDatePicker: UIDatePicker!
    
    
    override func awakeFromNib() {
        initialize()
    }
    
    func initialize() {
        titleLabel.text = "Enter your date of birth".localized()
        registerBirthDayDatePicker.datePickerMode = .date
        if #available(iOS 13.4, *){
            registerBirthDayDatePicker.preferredDatePickerStyle = .wheels
        }
    }
}

extension RegisterBirthDayCell : Registerable {
    func validate() -> ValidationResponse {
        let date = registerBirthDayDatePicker.date
        
        delegate?.birthDaySelected(birthDay: date.toStringWithPattern(pattern: GeneralConstant.DATE_OF_BIRTH_PATTERN))
        return ValidationResponse(status: true, message: nil)
    }
}

extension RegisterBirthDayCell : RegisterBindable {
    func bind(_ viewController: RegisterVC) {
        delegate = viewController
    }
}
