//
//  ProfileEditWithTextFieldCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 1.03.2022.
//

import UIKit

class ProfileEditWithTextFieldCell: UITableViewCell, UITextFieldDelegate, Reformable {

    
    @IBOutlet weak var responseLabel: UILabel!
    @IBOutlet weak var fieldKeyLabel: UILabel!
    @IBOutlet weak var fieldValueTextField: UITextField!
    var model:EditProfileConfigure!
    var delegate:EditProfileWithEditTextCellProtocol?
    
    func configure(model:EditProfileConfigure){
        self.model = model
        self.fieldKeyLabel.text = model.displayName
        self.fieldValueTextField.text = model.value
        if !model.isEditable {
            self.fieldValueTextField.delegate = self
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
    
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

protocol EditProfileWithEditTextCellProtocol {
    func updateUserField(model:EditProfileConfigure, reformable:Reformable)
}




