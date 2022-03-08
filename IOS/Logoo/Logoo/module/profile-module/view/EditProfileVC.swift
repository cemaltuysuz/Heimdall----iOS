//
//  EditProfileVC.swift
//  Logoo
//
//  Created by cemal tüysüz on 1.03.2022.
//

import UIKit

class EditProfileVC: UIViewController {

    @IBOutlet weak var editUserProfilePhotoImg: UIImageView!
    @IBOutlet weak var editUserFieldsTableView: UITableView!
    @IBOutlet weak var errorLabel: UILabel!
    
    var fields:[EditProfileConfigure]?
    var reformableFields:[Reformable]?
    
    var presenter:ViewToPresenterEditProfileProtocol?
    
    
    lazy var getGenders:[String] = {
        var genders = [String]()
        
        for gender in CONSTANT_GENDERS {
            genders.append(gender.rawValue)
        }
        return genders
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reformableFields = [Reformable]()
        
        EditProfileRouter.createModule(ref: self)
        presenter?.getCurrentUserFields()
        
        self.editUserFieldsTableView.delegate = self
        self.editUserFieldsTableView.dataSource = self
    }
    
    @IBAction func reformAllFieldsBtn(_ sender: Any) {
        if let fields = reformableFields, fields.count > 0 {
            for field in fields {
                field.reform()
            }
        }
    }
}

extension EditProfileVC : PresenterToViewEditProfileProtocol {
    func userFieldsToView(fields: [EditProfileConfigure], userPhotoUrl:String?) {
        DispatchQueue.main.async {
            self.fields = fields
            self.editUserFieldsTableView.reloadData()
            
            if let userPhotoUrl = userPhotoUrl {
                self.editUserProfilePhotoImg.setImage(urlString: userPhotoUrl)
            }
        }
    }
}

extension EditProfileVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fields?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let current = fields![indexPath.row]
        
        if current.fieldType == .USERNAME || current.fieldType == .USER_MANIFESTO {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ID") as! EditFieldWithTextFieldCell
            cell.delegate = self
            cell.configureCell(model: current)
            reformableFields?.append(cell)
            return cell
        }
        else if current.fieldType == .USER_BIRTHDAY {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ID") as! EditFieldWithDatePickerCell
            cell.delegate = self
            cell.configureCell(model: current, minDate: Date(), maxDate: nil)
            reformableFields?.append(cell)
            return cell
        }
        else if current.fieldType == .USER_GENDER {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ID") as! EditFieldWithPickerViewCell
            cell.delegate = self
            cell.configureCell(model: current, data: getGenders)
            reformableFields?.append(cell)
            return cell
        }
        else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension EditProfileVC : BaseEditFieldCellProtocol {
    func updateField(fieldKey: String?, fieldValue: String?, reformable: Reformable) {
        // self.presenter?.updateUserField(model: model, reformable: reformable) (do change parameters)
    }
}
