//
//  EditProfileFieldWithTextFieldCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 9.03.2022.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class EditFieldWithTextFieldCell: UITableViewCell {

    @IBOutlet weak var fieldValueTextField: CustomUITextField!
    @IBOutlet weak var fieldDisplayNameLabel: UILabel!
    @IBOutlet weak var fieldErrorLabel: UILabel!
    
    public weak var delegate:EditFieldCellProtocol?
    
    private var pendingRequestWorkItem: DispatchWorkItem?
    private var isAlreadyUsedAnotherUser:Bool? = false
    
    private var model : EditFieldConfigure!{
        didSet{
            fieldDisplayNameLabel.text = model.displayName
            fieldValueTextField.text = model.value
        }
    }
    
    override func awakeFromNib() {
        print("run cell with \(frame.height) height size")
    }
    
    func configureCell(model:EditFieldConfigure){
        self.model = model
        if let name = model.fieldLeftIconName {
            fieldValueTextField.leftImage = UIImage(systemName: name)
            fieldValueTextField.leftPadding = 10
        }
        if model.editType == .NO_EDIT {
            fieldValueTextField.isUserInteractionEnabled = false
        }
        if model.hasCheckForAlreadyUsed {
            self.fieldValueTextField.addTarget(self, action: #selector(self.checkFieldForAlreadyUsed(_:)), for: .editingChanged)
        }
    }
}


// MARK: - Reformable Protocol

extension EditFieldWithTextFieldCell : Reformable {
    func reform() {
        if let newValue = fieldValueTextField.text, model.value ?? "" != newValue, let status = isAlreadyUsedAnotherUser, status != true {
            if let result =  model.validator?.changeValueAndReValidate(value: newValue) {
                if result.isSuccess {
                    model.value = newValue
                    fieldErrorLabel.isHidden = true
                    delegate?.updateField(fieldKey: model.key, fieldValue: newValue, reformable: self)
                }else {
                    fieldErrorLabel.text = result.message!
                    fieldErrorLabel.textColor = .red
                    fieldErrorLabel.isHidden = false
                }
            }else {
                model.value = newValue
                fieldErrorLabel.isHidden = true
                delegate?.updateField(fieldKey: model.key, fieldValue: newValue, reformable: self)
            }
        }else {
            fieldErrorLabel.isHidden = true
        }
    }
    
    func reformResponse(resp: SimpleResponse) {
        // TODO RESP
    }
}

// MARK: - Check

extension EditFieldWithTextFieldCell {
    
    @objc func checkFieldForAlreadyUsed(_ textField: UITextField){
        DispatchQueue.main.async {
            self.pendingRequestWorkItem?.cancel()
            
            if let text = textField.text , !text.isEmpty {
                let requestWorkItem = DispatchWorkItem { [weak self] in
                    let ref = Firestore.firestore().collection(FireStoreCollection.USER_COLLECTION)
                    FireStoreService.shared.getDocumentsByField(ref: ref, getByField: self?.model.key ?? "", getByValue: text, onCompletion: {
                        (users:[User?]?, error:Error?) in
                        guard  error == nil else {
                            print("Error:\(error?.localizedDescription ?? "not found")")
                            return
                        }
                        if let users = users, users.count > 0 {
                            self?.fieldErrorLabel.text = "The information entered is already in use by another account.".localized
                            self?.fieldErrorLabel.isHidden = false
                            self?.isAlreadyUsedAnotherUser = true
                        }else {
                            // hide error
                            self?.fieldErrorLabel.isHidden = true
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

