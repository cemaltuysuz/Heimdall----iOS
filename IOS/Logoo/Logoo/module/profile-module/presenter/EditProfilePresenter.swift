//
//  EditProfilePresenter.swift
//  Logoo
//
//  Created by cemal tüysüz on 1.03.2022.
//

import Foundation
import UIKit

class EditProfilePresenter : ViewToPresenterEditProfileProtocol, InteractorToPresenterEditProfileProtocol {

    var view: PresenterToViewEditProfileProtocol?
    var interactor: PresenterToInteractorEditProfileProtocol?
    
    func getCurrentUserFields() {
        interactor?.getCurrentUserFields()
    }
    
    func userFieldsToPresenter(fields: [EditFieldConfigure], userPhotoUrl:String?) {
        view?.userFieldsToView(fields: fields, userPhotoUrl: userPhotoUrl)
    }
    
    func updateUserField(key:String,value:String, reformable: Reformable) {
        interactor?.updateUserField(key: key, value: value, reformable: reformable)
    }
    
    func updateUserPhoto(image: UIImage) {
        interactor?.updateUserPhoto(image: image)
    }
}
