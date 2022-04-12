//
//  EditProfileProtocols.swift
//  Logoo
//
//  Created by cemal tüysüz on 1.03.2022.
//

import Foundation
import UIKit


protocol ViewToPresenterEditProfileProtocol {
    var view:PresenterToViewEditProfileProtocol? {get set}
    var interactor:PresenterToInteractorEditProfileProtocol? {get set}
    
    func getCurrentUserFields()
    func updateUserField(key:String,value:String,reformable:Reformable)
    func updateUserPhoto(image:UIImage)
    func deleteUserPhoto(imageUUID:String)
}

protocol PresenterToInteractorEditProfileProtocol {
    var presenter:InteractorToPresenterEditProfileProtocol? {get set}
    
    func getCurrentUserFields()
    func updateUserField(key:String,value:String,reformable:Reformable)
    
    func updateUserPhoto(image:UIImage)
    func deleteUserPhoto(imageUUID:String)
}

protocol InteractorToPresenterEditProfileProtocol {
    func userFieldsToPresenter(fields:[EditFieldConfigure], userPhotoUrl:String?)
}

protocol PresenterToViewEditProfileProtocol {
    func userFieldsToView(fields:[EditFieldConfigure], userPhotoUrl:String?)
}

protocol PresenterToRouterEditProfileProtocol {
    static func createModule(ref:EditProfileVC)
}
