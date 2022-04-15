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
    
    func updateUserField(key:String,value:String, reformable: Reformable) {
        interactor?.updateUserField(key: key, value: value, reformable: reformable)
    }
    
    func updateUserPhoto(image: UIImage) {
        interactor?.updateUserPhoto(image: image)
    }
    
    func loadPage() {
        interactor?.loadPage()
    }
    
    func deleteUserPost(postUUID : String) {
        interactor?.deleteUserPost(postUUID: postUUID)
    }
    
    func onStateChange(state: EditProfileState) {
        view?.onStateChange(state: state)
    }
    
    func createNewUserPost(image: UIImage) {
        interactor?.createNewUserPost(image: image)
    }
}
