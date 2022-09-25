//
//  RegisterGenderCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 24.02.2022.
//

import UIKit

protocol RegisterGenderCellProtocol : AnyObject {
    func genderSelected(gender:GenderType)
}

class RegisterGenderCell: UICollectionViewCell {
    
    @IBOutlet weak var registerGenderPickerView: UIPickerView!
    weak var delegate:RegisterGenderCellProtocol?
    let genders = GenderType.allCases
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        initialize()
    }

    func initialize() {
        titleLabel.text = "Choose your gender".localized
        registerGenderPickerView.delegate = self
        registerGenderPickerView.dataSource = self
    }
}

extension RegisterGenderCell : Registerable {
    func validate() -> ValidationResponse {
        delegate?.genderSelected(
            gender: genders[registerGenderPickerView.selectedRow(inComponent: 0)]
        )
        return ValidationResponse(status: true, message: "")
    }
}

extension RegisterGenderCell :UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row].rawValue.localized
    }
}

extension RegisterGenderCell : RegisterBindable {
    func bind(_ viewController: RegisterVC) {
        delegate = viewController
    }
}


