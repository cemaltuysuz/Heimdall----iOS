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
    var fields:[EditProfileConfigure]?
    var reformableFields:[Reformable]?
    
    var presenter:ViewToPresenterEditProfileProtocol?
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileEditWithTextFieldCell") as! ProfileEditWithTextFieldCell
        let current = fields![indexPath.row]
        cell.configure(model: current)
        cell.delegate = self
        self.reformableFields?.append(cell)
        return cell
    }
}

extension EditProfileVC : EditProfileWithEditTextCellProtocol {
    func updateUserField(model: EditProfileConfigure, reformable: Reformable) {
        self.presenter?.updateUserField(model: model, reformable: reformable)
    }
}
