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
    
    func loadPage()
    
    func updateUserField(key:String,value:String,reformable:Reformable)
    func updateUserPhoto(image:UIImage)
    func createNewUserPost(image:UIImage)
    func deleteUserPost(imageUUID:String)
}

protocol PresenterToInteractorEditProfileProtocol {
    var presenter:InteractorToPresenterEditProfileProtocol? {get set}
    
    func loadPage()
    
    func updateUserField(key:String,value:String,reformable:Reformable)
    
    func updateUserPhoto(image:UIImage)
    func createNewUserPost(image:UIImage)
    func deleteUserPost(imageUUID:String)
}

protocol InteractorToPresenterEditProfileProtocol {
    func onStateChange(state:EditProfileState)

}

protocol PresenterToViewEditProfileProtocol {
    func onStateChange(state:EditProfileState)
}

protocol PresenterToRouterEditProfileProtocol {
    static func createModule(ref:EditProfileVC)
}
