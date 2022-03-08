//
//  EditProfileProtocols.swift
//  Logoo
//
//  Created by cemal tüysüz on 1.03.2022.
//

import Foundation


protocol ViewToPresenterEditProfileProtocol {
    var view:PresenterToViewEditProfileProtocol? {get set}
    var interactor:PresenterToInteractorEditProfileProtocol? {get set}
    
    func getCurrentUserFields()
    func updateUserField(key:String,value:String,reformable:Reformable)
}

protocol PresenterToInteractorEditProfileProtocol {
    var presenter:InteractorToPresenterEditProfileProtocol? {get set}
    func getCurrentUserFields()
    func updateUserField(key:String,value:String,reformable:Reformable)
}

protocol InteractorToPresenterEditProfileProtocol {
    func userFieldsToPresenter(fields:[EditProfileConfigure], userPhotoUrl:String?)
}

protocol PresenterToViewEditProfileProtocol {
    func userFieldsToView(fields:[EditProfileConfigure], userPhotoUrl:String?)
}

protocol PresenterToRouterEditProfileProtocol {
    static func createModule(ref:EditProfileVC)
}
