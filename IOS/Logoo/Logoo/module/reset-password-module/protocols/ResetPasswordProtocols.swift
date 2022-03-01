//
//  ResetPasswordProtocols.swift
//  Logoo
//
//  Created by cemal tüysüz on 16.02.2022.
//

import Foundation

protocol ViewToPresenterResetPasswordProtocol {
    var view:PresenterToViewResetPasswordProtocol? {get set}
    var interactor:PresenterToInteractorResetPasswordProtocol? {get set}
    
    func sendResetLink(mail:String)
}

protocol PresenterToInteractorResetPasswordProtocol {
    var presenter:InteractorToPresenterResetPasswordProtocol? {get set}
    
    func sendResetLink(mail:String)
}

protocol InteractorToPresenterResetPasswordProtocol {
    func sendLinkResponse(resp:Status)
}

protocol PresenterToViewResetPasswordProtocol {
    func sendLinkResponse(resp:Status)
}

protocol PresenterToRouterResetPasswordProtocol {
    static func createModule(ref:ResetPasswordVC)
}
