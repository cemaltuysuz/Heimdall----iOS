//
//  EditProfileVC.swift
//  Logoo
//
//  Created by cemal tüysüz on 1.03.2022.
//

import UIKit
import SwiftUI
import Mantis

protocol EditProfileVCToAlbumCellProtocol : AnyObject {
    func updateData(posts:[UserPost])
}

class EditProfileVC: UIViewController {

    @IBOutlet weak var userImageChangeLabel: UILabel!
    @IBOutlet weak var editUserProfilePhotoImg: LGImageView!
    @IBOutlet weak var editUserFieldsTableView: UITableView!
    
    weak var editProfileToAlbumCellProtocol:AlbumItemCellProtocol?
    
    var fields:[EditFieldConfigure]?
    var reformableFields:[Reformable]?
    
    var presenter:ViewToPresenterEditProfileProtocol?
    
    var requestRawCode:Int?
    
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
        editUserFieldsTableView.register(EditFieldWithTextFieldCell.self)
        editUserFieldsTableView.register(EditFieldWithDatePickerCell.self)
        editUserFieldsTableView.register(EditFieldWithPickerViewCell.self)
        editUserFieldsTableView.register(EditAlbumCell.self) // edit photo album
        
        
        editUserFieldsTableView.delegate = self
        editUserFieldsTableView.dataSource = self
        
        userImageChangeLabel.isUserInteractionEnabled = true
        
        let onDidTap = UITapGestureRecognizer(target: self, action: #selector(self.userPhotoClick(_:)))
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

// MARK: - Functions from interactor
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
// MARK: - functions from tableview
extension EditProfileVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fields?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let current = fields![indexPath.row]
        
        if current.editType == .EDIT_WITH_TEXTFIELD || current.editType == .NO_EDIT{
            //let firstCell =  as! BaseEditFieldCell
            let cell = tableView.dequeue(indexPath, type: EditFieldWithTextFieldCell.self)
            cell.delegate = self
            cell.configureCell(model: current)
            reformableFields?.append(cell)
            return cell
        }
        else if current.editType == .EDIT_WITH_DATE_PICKER {
            let cell = tableView.dequeue(indexPath, type: EditFieldWithDatePickerCell.self)
            cell.delegate = self
            cell.configureCell(model: current, minDate: nil, maxDate: Date())
            reformableFields?.append(cell)
            return cell
        }
        else if current.editType == .EDIT_WITH_PICKER_VIEW {
            let cell = tableView.dequeue(indexPath, type: EditFieldWithPickerViewCell.self)
            cell.delegate = self
            cell.configureCell(model: current, data: getGenders)
            reformableFields?.append(cell)
            return cell
        }
        else if current.editType == .EDIT_WITH_ALBUM {
            let cell = tableView.dequeue(indexPath, type: EditAlbumCell.self)
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
// MARK: - Update Field
extension EditProfileVC : EditFieldCellProtocol {
    func updateField(fieldKey: String, fieldValue: String, reformable: Reformable) {
        presenter?.updateUserField(key: fieldKey, value: fieldValue, reformable: reformable)
    }
}

// MARK: - Receive photo from user
extension EditProfileVC :UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc
    func userPhotoClick(_ tap:UITapGestureRecognizer){
        requestRawCode = EditProfileImageRequestType.REQUEST_FOR_PP.rawValue
        openGalleryWithVC(self)
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
        
        guard let rawCode = requestRawCode, let reqType = EditProfileImageRequestType(rawValue: rawCode) else {return}
        
        switch reqType {
        case .REQUEST_FOR_ALBUM:
            startMantis(viewController: self, image: image, shapeType: .rect)
            break
        case .REQUEST_FOR_PP:
            startMantis(viewController: self, image: image, shapeType: .square)
            break
        }
    }
}

// MARK: - Crop photo

extension EditProfileVC : CropViewControllerDelegate {
    func cropViewControllerDidCrop(_ cropViewController: CropViewController, cropped: UIImage, transformation: Transformation, cropInfo: CropInfo) {
        guard let rawCode = requestRawCode, let reqType = EditProfileImageRequestType(rawValue: rawCode) else {return}
        
        switch reqType {
        case .REQUEST_FOR_ALBUM:
            break
        case .REQUEST_FOR_PP:
            editUserProfilePhotoImg.image = cropped
            presenter?.updateUserPhoto(image: cropped)
            break
        }
        cropViewController.dismiss(animated: true)
    }
    
    func cropViewControllerDidCancel(_ cropViewController: CropViewController, original: UIImage) {
        cropViewController.dismiss(animated: true)
    }
}

// This ViewController <- EditAlbumCell
extension EditProfileVC : EditAlbumCellProtocol {
    func deletePhotoRequest(postUUID: String) {
        presenter?.deleteUserPhoto(imageUUID: postUUID)
    }
    
    func selectPhotoRequest() {
        requestRawCode = EditProfileImageRequestType.REQUEST_FOR_ALBUM.rawValue
        openGalleryWithVC(self)
    }
}

enum EditProfileImageRequestType : Int {
    case REQUEST_FOR_ALBUM
    case REQUEST_FOR_PP
}
