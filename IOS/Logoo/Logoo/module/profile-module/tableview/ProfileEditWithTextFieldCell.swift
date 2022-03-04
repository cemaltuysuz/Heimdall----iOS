//
//  ProfileEditWithTextFieldCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 1.03.2022.
//

import UIKit
import Foundation

class ProfileEditWithTextFieldCell: UITableViewCell, UITextFieldDelegate {

    
    @IBOutlet weak var responseLabel: UILabel!
    @IBOutlet weak var fieldKeyLabel: UILabel!
    @IBOutlet weak var fieldValueTextField: UITextField!
    
    var timePicker:UIDatePicker?
    var model:EditProfileConfigure!
    var delegate:EditProfileWithEditTextCellProtocol?
    
    func configure(model:EditProfileConfigure){
        self.model = model
        self.fieldKeyLabel.text = model.displayName
        self.fieldValueTextField.text = model.value
        if !model.isEditable {
            if model.hasPickerView {
                self.routeForPicker()
            }else {
                self.fieldValueTextField.isUserInteractionEnabled = false
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func routeForPicker(){
        switch self.model.type {
        case .USER_BIRTHDAY:
            self.createUIDatePickerView()
            break
        case .USER_GENDER:
            // create pickerview
            break
        default:
            break
        }
    }
    
    
}



// MARK: - Reformable Methods (for data trasfer actions)

extension ProfileEditWithTextFieldCell : Reformable {
    func reform() {
        if let newValue = fieldValueTextField.text, model.value != newValue {
            if let result =  self.model.validator?.changeValueAndReValidate(value: newValue) {
                if result.isSuccess {
                    model.value = newValue
                    self.responseLabel.isHidden = true
                    self.delegate?.updateUserField(model: model, reformable: self)
                }else {
                    self.responseLabel.text = result.message!
                    self.responseLabel.textColor = .red
                    self.responseLabel.isHidden = false
                }
            }else {
                model.value = newValue
                self.responseLabel.isHidden = true
                self.delegate?.updateUserField(model: model, reformable: self)
            }
        }else {
            self.responseLabel.isHidden = true
        }
    }
    
    func reformResponse(resp: SimpleResponse) {
        // check response (if true show saved message / else show error message)
        if resp.status! {
            self.responseLabel.text = "Success".localized()
            self.responseLabel.textColor = .green
        }else{
            self.responseLabel.text = resp.message!
            self.responseLabel.textColor = .red
        }
        self.responseLabel.isHidden = false
    }
}

// MARK: - Date Of Picker Actions


extension ProfileEditWithTextFieldCell {
    
    @objc
    func onChangeBirthOfdate(datePicker:UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY"
        let data = dateFormatter.string(from: datePicker.date)
        self.fieldValueTextField.text = data
    }
    @objc
    func dismissPicker() {
        self.fieldValueTextField.endEditing(true)
    }
    
    func createUIDatePickerView(){
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *){
            datePicker.preferredDatePickerStyle = .wheels
        }
        let toolBar = UIToolbar().ToolbarPiker(mySelect: #selector(self.dismissPicker))
        self.fieldValueTextField.inputAccessoryView = toolBar
        self.fieldValueTextField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(self.onChangeBirthOfdate(datePicker:)), for: .valueChanged)
    }
}

// MARK: - This protocol provide communication between this class and VC class.
protocol EditProfileWithEditTextCellProtocol {
    func updateUserField(model:EditProfileConfigure, reformable:Reformable)
}




