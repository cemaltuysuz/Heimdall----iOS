//
//  EditFieldWithTextFieldCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 8.03.2022.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class EditFieldWithTextFieldCell: BaseEditFieldCell<EditProfileConfigure> {
    
    private var pendingRequestWorkItem: DispatchWorkItem?
    
    override var model: EditProfileConfigure!{
        didSet{
            key = model.fieldType.rawValue
            value = model.value
            validator = model.validator
            
            fieldValueTextField.text = value
            fieldDisplayNameLabel.text = model.displayName
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell (model:EditProfileConfigure) {
        self.model = model // execute didset
        
        if model.editType == .NO_EDIT {
            fieldValueTextField.isUserInteractionEnabled = false
        }
        if model.hasCheckForAlreadyUsed {
            self.fieldValueTextField.addTarget(self, action: #selector(self.checkFieldForAlreadyUsed(_:)), for: .editingChanged)
        }
    }
}


// MARK: - Check For Already Used From Another User (if it has)

extension EditFieldWithTextFieldCell {
    
    @objc func checkFieldForAlreadyUsed(_ textField: UITextField){
        DispatchQueue.main.async {
            self.pendingRequestWorkItem?.cancel()
            
            if let text = textField.text , !text.isEmpty {
                let requestWorkItem = DispatchWorkItem { [weak self] in
                    let ref = Firestore.firestore().collection(FireCollections.USER_COLLECTION)
                    FireStoreService.shared.getDocumentsByField(ref: ref, getByField: self?.key ?? "", getByValue: text, onCompletion: {
                        (users:[User?]?, error:Error?) in
                        guard  error == nil else {
                            print("Error:\(error?.localizedDescription ?? "not found")")
                            return
                        }
                        if let users = users, users.count > 0 {
                            self?.errorLabel.text = "The information entered is already in use by another account.".localized()
                            self?.errorLabel.isHidden = false
                            self?.isAlreadyUsedAnotherUser = true
                        }else {
                            // hide error
                            self?.errorLabel.isHidden = true
                            self?.isAlreadyUsedAnotherUser = false
                        }
                    })
                }
                // I created a work with 250 millisecond delay.
                self.pendingRequestWorkItem = requestWorkItem
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250),
                                                      execute: requestWorkItem)
            }
        }
    }
}

