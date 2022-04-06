//
//  ChangePasswordProtocols.swift
//  Logoo
//
//  Created by cemal tüysüz on 5.04.2022.
//

import Foundation


protocol ViewToPresenterChangePasswordProtocol {
    var interactor:PresenterToInteractorChangePasswordProtocol? {get set}
    var view:PresenterToViewChangePasswordProtocol? {get set}
    
    func resetPasswordRequest(currentPassword:String,newPassword:String)
}

protocol PresenterToInteractorChangePasswordProtocol {
    var presenter:InteractorToPresenterChangePasswordProtocol? {get set}
    
    func resetPasswordRequest(currentPassword:String,newPassword:String)
}

protocol InteractorToPresenterChangePasswordProtocol {
    func onStateChange(state:ChangePasswordState)
}

protocol PresenterToViewChangePasswordProtocol {
    func onStateChange(state:ChangePasswordState)
}

protocol PresenterToRouterChangePasswordProtocol {
    static func createModule(ref:ChangePasswordVC)
}
