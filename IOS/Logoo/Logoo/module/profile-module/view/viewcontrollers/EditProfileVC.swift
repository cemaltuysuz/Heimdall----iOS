//
//  EditProfileVC.swift
//  Logoo
//
//  Created by cemal tüysüz on 1.03.2022.
//

import UIKit
import SwiftUI
import Mantis

class EditProfileVC: UIViewController {

    @IBOutlet weak var userImageChangeLabel: UILabel!
    @IBOutlet weak var editUserProfilePhotoImg: LGImageView!
    @IBOutlet weak var editUserFieldsTableView: UITableView!
    @IBOutlet weak var errorLabel: UILabel!
    
    var fields:[EditFieldConfigure]?
    var reformableFields:[Reformable]?
    
    var presenter:ViewToPresenterEditProfileProtocol?
    
    
    lazy var getGenders:[String] = {
        var genders = [String]()
        
        for gender in GenderType.allCases  {
            genders.append(gender.rawValue)
        }
        return genders
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reformableFields = [Reformable]()
        
        setupVIPER()
        setupUI()
    }
    
    
    func setupVIPER(){
        EditProfileRouter.createModule(ref: self)
        presenter?.getCurrentUserFields()
    }
    
    func setupUI(){
        editUserFieldsTableView.register(UINib(nibName: "EditFieldWithTextFieldCell", bundle: nil), forCellReuseIdentifier: "EditFieldWithTextFieldCell")
        editUserFieldsTableView.register(UINib(nibName: "EditFieldWithDatePickerCell", bundle: nil), forCellReuseIdentifier: "EditFieldWithDatePickerCell")
        editUserFieldsTableView.register(UINib(nibName: "EditFieldWithPickerViewCell", bundle: nil), forCellReuseIdentifier: "EditFieldWithPickerViewCell")
        
        editUserFieldsTableView.delegate = self
        editUserFieldsTableView.dataSource = self
        
        userImageChangeLabel.isUserInteractionEnabled = true
        
        let onDidTap = UITapGestureRecognizer(target: self, action: #selector(self.userPhotoClick))
        userImageChangeLabel.addGestureRecognizer(onDidTap)
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
    func userFieldsToView(fields: [EditFieldConfigure], userPhotoUrl:String?) {
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
        
        if current.editType == .EDIT_WITH_TEXTFIELD || current.editType == .NO_EDIT{
            //let firstCell =  as! BaseEditFieldCell
            let fcell = tableView.dequeueReusableCell(withIdentifier: "EditFieldWithTextFieldCell")
            let cell = fcell as! EditFieldWithTextFieldCell
            cell.delegate = self
            cell.configureCell(model: current)
            reformableFields?.append(cell)
            return cell
        }
        else if current.editType == .EDIT_WITH_DATE_PICKER {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditFieldWithDatePickerCell") as! EditFieldWithDatePickerCell
            cell.delegate = self
            cell.configureCell(model: current, minDate: nil, maxDate: Date())
            reformableFields?.append(cell)
            return cell
        }
        else if current.editType == .EDIT_WITH_PICKER_VIEW {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditFieldWithPickerViewCell") as! EditFieldWithPickerViewCell
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

extension EditProfileVC : EditFieldCellProtocol {
    func updateField(fieldKey: String, fieldValue: String, reformable: Reformable) {
        presenter?.updateUserField(key: fieldKey, value: fieldValue, reformable: reformable)
    }
}

// user change photo
extension EditProfileVC :UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
    @objc
    func userPhotoClick(){
        let imagePicker = UIImagePickerController()
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){

                imagePicker.delegate = self
                imagePicker.sourceType = .savedPhotosAlbum
                imagePicker.allowsEditing = false

                present(imagePicker, animated: true, completion: nil)
            }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil) // if the user choosed an image, close the window.
        
        /**
         I'm performing a casting when the user selects an image. If the image is received successfully,
         */
        guard let image = info[.originalImage] as? UIImage else {
           print("Expected a dictionary containing an image, but was provided the following: \(info)")
            return
        }

        var config = Mantis.Config()
        config.cropShapeType = .square
        config.ratioOptions = [.square]
        let cropViewController = Mantis.cropViewController(image: image,config: config)
        cropViewController.delegate = self
        present(cropViewController, animated: true)
    }
}

extension EditProfileVC : CropViewControllerDelegate {
    func cropViewControllerDidCrop(_ cropViewController: CropViewController, cropped: UIImage, transformation: Transformation, cropInfo: CropInfo) {
        cropViewController.dismiss(animated: true)
        editUserProfilePhotoImg.image = cropped
        presenter?.updateUserPhoto(image: cropped)
    }
    
    func cropViewControllerDidCancel(_ cropViewController: CropViewController, original: UIImage) {
        cropViewController.dismiss(animated: true)
    }
}
