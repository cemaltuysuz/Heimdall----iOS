//
//  EditProfilePresenter.swift
//  Logoo
//
//  Created by cemal tüysüz on 1.03.2022.
//

import Foundation

class EditProfilePresenter : ViewToPresenterEditProfileProtocol, InteractorToPresenterEditProfileProtocol {
    
    var view: PresenterToViewEditProfileProtocol?
    var interactor: PresenterToInteractorEditProfileProtocol?
    
    func getCurrentUserFields() {
        interactor?.getCurrentUserFields()
    }
    
    func userFieldsToPresenter(fields: [EditProfileConfigure], userPhotoUrl:String?) {
        view?.userFieldsToView(fields: fields, userPhotoUrl: userPhotoUrl)
    }
    
}
