//
//  LoginProtocols.swift
//  Logoo
//
//  Created by cemal tüysüz on 9.02.2022.
//

import Foundation

protocol ViewToPresenterLoginProtocol {
    var view:PresenterToViewLoginProtocol? {get set}
    var interactor:PresenterToInteractorLoginProtocol? {get set}
    
    func loginUser(mail:String, password:String)
    
}

protocol PresenterToInteractorLoginProtocol {
    var presenter:InteractorToPresenterLoginProtocol? {get set}
    
    func loginUser(mail:String, password:String)
}

protocol InteractorToPresenterLoginProtocol {
    func loginResponse(status:Resource<UserState>)
}

protocol PresenterToViewLoginProtocol {
    func loginResponse(status:Resource<UserState>)
}

protocol PresenterToRouterLoginProtocol {
    static func createModule(ref:LoginVC)
}
