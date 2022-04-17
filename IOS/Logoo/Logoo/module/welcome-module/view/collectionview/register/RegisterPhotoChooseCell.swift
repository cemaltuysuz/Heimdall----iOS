//
//  RegisterPhotoChooseCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 24.02.2022.
//

import UIKit


protocol RegisterPhotoChooseCellProtocol : AnyObject {
    func photoOnClick(registerCell:RegisterPhotoChooseCell)
}


class RegisterPhotoChooseCell: UICollectionViewCell {
    @IBOutlet weak var registerProfileImage: UIImageView!
    weak var delegate:RegisterPhotoChooseCellProtocol?
    
    override func awakeFromNib() {
        initialize()
    }
    
    func initialize(){
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(photoClicked))
        registerProfileImage.isUserInteractionEnabled = true
        registerProfileImage.addGestureRecognizer(singleTap)
    }
    
    
    // Update UI when user selects a photo.
    func onPhotoUpload(image:UIImage){
        registerProfileImage.image = image
    }
    
    // When the ImageView gets a click, trigger the View to open the photo selection screen.
    @objc
    func photoClicked(){
        delegate?.photoOnClick(registerCell: self)
    }
}

extension RegisterPhotoChooseCell : Registerable {
    func validate() -> ValidationResponse {
        if let imageView = registerProfileImage {
            if imageView.image != nil {
                return ValidationResponse(status: true, message: "Success.")
            }
        }
        return ValidationResponse(status: false, message: "No picture selected.".localized())
    }
}

extension RegisterPhotoChooseCell : RegisterBindable {
    func bind(_ viewController: RegisterVC) {
        delegate = viewController
    }
}
