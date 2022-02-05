//
//  RegisterGenderCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 5.02.2022.
//

import UIKit

class RegisterGenderCell: UICollectionViewCell, RegisterProtocol, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var registerGenderPickerView: UIPickerView!
    let genders = ["Erkek", "Kadın", "Eşcinsel(Kadın)", "Eşcinsel(Erkek)", "Diğer"]
    
    func validate() -> ValidationResponse {
        return ValidationResponse(status: true, message: "")
    }
    
    func initialize() {
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
        return genders[row]
    }
    
}
