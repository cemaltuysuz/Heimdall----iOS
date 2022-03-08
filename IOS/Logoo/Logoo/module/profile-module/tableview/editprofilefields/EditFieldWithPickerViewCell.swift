//
//  EditFieldWithPickerViewCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 8.03.2022.
//

import UIKit

class EditFieldWithPickerViewCell: BaseEditFieldCell {

    var data:[String]?
    
    override var model: EditProfileConfigure! {
        didSet{
            key = model.fieldType.rawValue
            value = model.value
            
            fieldValueTextField.text = model.value
            fieldDisplayNameLabel.text = model.displayName
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(model:EditProfileConfigure, data:[String]) {
        self.model = model
        self.data = data
        
    }
}


extension EditFieldWithPickerViewCell : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data![row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        onChangedData(index: row)
    }
    
}

extension EditFieldWithPickerViewCell  {

    @objc func createUIPickerView(){
        let pickerView = UIPickerView()
        let toolBar = UIToolbar().ToolbarWithPicker(mySelect: #selector(self.dismissPicker))
        self.fieldValueTextField.inputAccessoryView = toolBar
        self.fieldValueTextField.inputView = pickerView
    }
    
    @objc
    func dismissPicker() {
        self.fieldValueTextField.endEditing(true)
    }
    
    
    func onChangedData(index:Int){
        self.fieldValueTextField.text = data?[index] ?? ""
    }
}
