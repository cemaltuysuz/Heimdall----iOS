//
//  ProfileEditWithTextFieldCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 1.03.2022.
//

import UIKit

class ProfileEditWithTextFieldCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var fieldKeyLabel: UILabel!
    @IBOutlet weak var fieldValueTextField: UITextField!
    var model:EditProfileConfigure!
    
    func configure(model:EditProfileConfigure){
        self.fieldKeyLabel.text = model.key
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
}
