//
//  EditFieldWithPickerViewCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 9.03.2022.
//

import UIKit

class EditFieldWithPickerViewCell: UITableViewCell {

    @IBOutlet weak var fieldDisplayNameLabel: UILabel!
    @IBOutlet weak var fieldValueTextField: UITextField!

    weak var delegate:EditFieldCellProtocol?
    var data:[String]?
    private var model : EditFieldConfigure!{
        didSet{
            fieldDisplayNameLabel.text = model.displayName
            fieldValueTextField.text = model.value
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)}
    
    func configureCell(model:EditFieldConfigure, data:[String]) {
        self.model = model
        print("picker count : \(data.count)")
        self.data = data
        createUIPickerView()
    }
}

// MARK: - Reformable Protocol

extension EditFieldWithPickerViewCell : Reformable {
    func reform() {
        if let newValue = fieldValueTextField.text, model.value != newValue {
                model.value = newValue
                delegate?.updateField(fieldKey: model.key, fieldValue: newValue, reformable: self)
        }
    }
    
    func reformResponse(resp: SimpleResponse) {
        // TODO
    }
}

// MARK: - UIPicker | Delegate && DataSource
extension EditFieldWithPickerViewCell : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        print("sayım aşaması : \(data?.count ?? 0)")
        return data?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data![row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        onChangedData(index: row)
    }
}

// MARK: - UIPicker | Actions
extension EditFieldWithPickerViewCell  {

    @objc func createUIPickerView(){
        let pickerView = UIPickerView()
        let toolBar = UIToolbar().ToolbarWithPicker(mySelect: #selector(self.dismissPicker))
        self.fieldValueTextField.inputAccessoryView = toolBar
        self.fieldValueTextField.inputView = pickerView
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    @objc
    func dismissPicker() {
        print("pickerview is closed")
        self.fieldValueTextField.endEditing(true)
    }
    
    
    func onChangedData(index:Int){
        self.fieldValueTextField.text = data?[index] ?? ""
    }
}


