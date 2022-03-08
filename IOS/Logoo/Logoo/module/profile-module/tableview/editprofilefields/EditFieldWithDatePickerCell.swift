//
//  EditFieldWithDatePickerCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 8.03.2022.
//

import UIKit

class EditFieldWithDatePickerCell: BaseEditFieldCell {
    
    override var model: EditProfileConfigure!{
        didSet{
            key = model.fieldType.rawValue
            value = model.value
            
            fieldValueTextField.text = value
            fieldDisplayNameLabel.text = model.displayName
        }
    }
    
    var minDate:Date!
    var maxDate:Date?
    
    func configureCell(model:EditProfileConfigure, minDate:Date, maxDate:Date? = nil){
        self.model = model
        self.minDate = minDate
        self.maxDate = maxDate
        
        fieldValueTextField.isUserInteractionEnabled = false
        createUIDatePickerView()
    }
    
}

extension EditFieldWithDatePickerCell {
    
    @objc func createUIDatePickerView(){
        let datePicker = UIDatePicker()
        datePicker.minimumDate = self.minDate
        datePicker.maximumDate = self.maxDate
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *){
            datePicker.preferredDatePickerStyle = .wheels
        }
        let toolBar = UIToolbar().ToolbarWithPicker(mySelect: #selector(self.dismissPicker))
        self.fieldValueTextField.inputAccessoryView = toolBar
        datePicker.addTarget(self, action: #selector(self.onChangedDate(datePicker:)), for: .valueChanged)
        self.fieldValueTextField.inputView = datePicker
    }
    
    @objc
    func dismissPicker() {
        self.fieldValueTextField.endEditing(true)
    }
    
    @objc
    func onChangedDate(datePicker:UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY"
        let data = dateFormatter.string(from: datePicker.date)
        self.fieldValueTextField.text = data
    }
}
