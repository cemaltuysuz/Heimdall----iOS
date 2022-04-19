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
    func sendVerificationLink(mail:String)
    func calculateRepeatTime()
    
}

protocol PresenterToInteractorLoginProtocol {
    var presenter:InteractorToPresenterLoginProtocol? {get set}
    
    func loginUser(mail:String, password:String)
    func sendVerificationLink(mail:String)
    func calculateRepeatTime()
}

protocol InteractorToPresenterLoginProtocol {
    func loginResponse(status:Resource<UserState>)
    func verificationLinkResponse(status:Resource<Any>)
    func timeLimitCountinues(status:Bool,continuationTime:Int64?)
}

protocol PresenterToViewLoginProtocol {
    func loginResponse(status:Resource<UserState>)
    func verificationLinkResponse(status:Resource<Any>)
    func timeLimitCountinues(status:Bool, continuationTime:Int64?)
}

protocol PresenterToRouterLoginProtocol {
    static func createModule(ref:LoginVC)
}
