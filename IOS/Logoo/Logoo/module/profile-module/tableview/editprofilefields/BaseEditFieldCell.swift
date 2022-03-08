//
//  BaseEditFieldCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 8.03.2022.
//

import UIKit

class BaseEditFieldCell<T>: UITableViewCell {

    @IBOutlet weak var fieldDisplayNameLabel: UILabel!
    @IBOutlet weak var fieldValueTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    weak var delegate:BaseEditFieldCellProtocol?
    
    var model:T!
    var key:String!
    var value:String!
    var validator:Validatable?
    var isAlreadyUsedAnotherUser:Bool?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// MARK: - Base Protocol

protocol BaseEditFieldCellProtocol : AnyObject {
    func updateField(fieldKey:String?, fieldValue:String?, reformable:Reformable)
}

// MARK: - Reformable Protocol

extension BaseEditFieldCell : Reformable {
    func reform() {
        if let newValue = fieldValueTextField.text, value != newValue, let status = isAlreadyUsedAnotherUser, status != true {
            if let result =  self.validator?.changeValueAndReValidate(value: newValue) {
                if result.isSuccess {
                    self.value = newValue
                    errorLabel.isHidden = true
                    delegate?.updateField(fieldKey: self.key, fieldValue: newValue, reformable: self)
                }else {
                    errorLabel.text = result.message!
                    errorLabel.textColor = .red
                    errorLabel.isHidden = false
                }
            }else {
                self.value = newValue
                errorLabel.isHidden = true
                delegate?.updateField(fieldKey: self.key, fieldValue: newValue, reformable: self)
            }
        }else {
            errorLabel.isHidden = true
        }
    }
    
    func reformResponse(resp: SimpleResponse) {
        
    }
}
