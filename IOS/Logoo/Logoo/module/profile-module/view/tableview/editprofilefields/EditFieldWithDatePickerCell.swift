//
//  EditFieldWithDatePickerCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 9.03.2022.
//

import UIKit

class EditFieldWithDatePickerCell: UITableViewCell {

    @IBOutlet weak var fieldValueTextField: CustomUITextField!
    @IBOutlet weak var fieldDisplayNameLabel: UILabel!
    
    weak var delegate:EditFieldCellProtocol?
    var minDate:Date?
    var maxDate:Date?
    private var model : EditFieldConfigure!{
        didSet{
            fieldDisplayNameLabel.text = model.displayName
            fieldValueTextField.text = model.value
        }
    }
    
    func configureCell(model:EditFieldConfigure, minDate:Date?, maxDate:Date){
        if let name = model.fieldLeftIconName {
            fieldValueTextField.leftImage = UIImage(systemName: name)
            fieldValueTextField.leftPadding = 10
        }
        self.model = model
        self.minDate = minDate
        self.maxDate = maxDate
        
        createUIDatePickerView()
    }
}


// MARK: - Reformable Protocol

extension EditFieldWithDatePickerCell : Reformable {
    func reform() {
        if let newValue = fieldValueTextField.text, model.value != newValue {
                model.value = newValue
                delegate?.updateField(fieldKey: model.key, fieldValue: newValue, reformable: self)
        }
    }
    
    func reformResponse(resp: SimpleResponse) {
        
    }
}

// MARK: - UIDatePickerView Actions

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
        fieldValueTextField.endEditing(true)
    }
    
    @objc
    func onChangedDate(datePicker:UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = GeneralConstant.DATE_OF_BIRTH_PATTERN
        let data = dateFormatter.string(from: datePicker.date)
        fieldValueTextField.text = data
    }
}
