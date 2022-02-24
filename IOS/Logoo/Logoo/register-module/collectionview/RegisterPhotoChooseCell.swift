//
//  RegisterPhotoChooseCell.swift
//  Logoo
//
//  Created by cemal tüysüz on 24.02.2022.
//

import UIKit

class RegisterPhotoChooseCell: UICollectionViewCell, RegisterProtocol {
    @IBOutlet weak var registerProfileImage: UIImageView!
    var photoProtocol:RegisterPhotoCellProtocol?
    
    /**
     - I have set up a selector structure to detect when the user touches the UIImageView.
     - I placed this structure inside an initialize function. After creating this cell in the ViewController, I run this function.
     */
    func initialize(){
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(photoClicked))
        registerProfileImage.isUserInteractionEnabled = true
        registerProfileImage.addGestureRecognizer(singleTap)
    }
    
    /**
     This function is run when verification is requested by the View.
     */
    func validate() -> ValidationResponse {
        if let imageView = registerProfileImage {
            if imageView.image != nil {
                return ValidationResponse(status: true, message: "Success.")
            }
        }
        return ValidationResponse(status: false, message: "No picture selected.".localized())
    }
    
    // Update UI when user selects a photo.
    func onPhotoUpload(image:UIImage){
        self.registerProfileImage.image = image
    }
    // When the ImageView gets a click, trigger the View to open the photo selection screen.
    @objc
    func photoClicked(){
        photoProtocol?.photoOnClick(registerCell: self)
    }
}

// The protocol structure I created for the View to be aware of the clicks.
protocol RegisterPhotoCellProtocol {
    func photoOnClick(registerCell:RegisterPhotoChooseCell)
}
