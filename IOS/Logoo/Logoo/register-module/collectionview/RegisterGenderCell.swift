//
//  RegisterGenderCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 5.02.2022.
//

import UIKit

class RegisterGenderCell: UICollectionViewCell, RegisterProtocol, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var registerGenderPickerView: UIPickerView!
    var toView:RegisterGenderCellProtocol?
    let genders = [GenderType.Male, GenderType.Female, GenderType.HomoFemale, GenderType.HomoMale, GenderType.Other]
    
    func validate() -> ValidationResponse {
        toView?.genderSelected(
            gender: genders[self.registerGenderPickerView.selectedRow(inComponent: 0)]
        )
        return ValidationResponse(status: true, message: "")
    }
    
    func initialize(genderPickerCellProtocol:RegisterGenderCellProtocol) {
        self.toView = genderPickerCellProtocol
        registerGenderPickerView.delegate = self
        registerGenderPickerView.dataSource = self
    }
        
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row].rawValue
    }
    
}

protocol RegisterGenderCellProtocol {
    func genderSelected(gender:GenderType)
}
