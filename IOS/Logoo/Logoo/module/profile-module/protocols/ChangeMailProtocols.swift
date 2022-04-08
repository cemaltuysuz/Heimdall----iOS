//
//  ChangeMailProtocols.swift
//  Logoo
//
//  Created by cemal tüysüz on 5.04.2022.
//

import Foundation

protocol ViewToPresenterChangeMailProtocol {
    var interactor:PresenterToInteractorChangeMailProtocol? {get set}
    var view:PresenterToViewChangeMailProtocol? {get set}
    
    func reAuthRequest(currentPassword:String)
    func doChangeMail(mail:String)
}

protocol PresenterToInteractorChangeMailProtocol {
    var presenter:InteractorToPresenterChangeMailProtocol? {get set}
    
    func reAuthRequest(currentPassword:String)
    func doChangeMail(mail:String)
}

protocol InteractorToPresenterChangeMailProtocol {
    func onStateChange(state:ChangeMailState)
}

protocol PresenterToViewChangeMailProtocol {
    func onStateChange(state:ChangeMailState)
}

protocol PresenterToRouterChangeMailProtocol {
    static func createModule(ref:ChangeMailVC)
}
