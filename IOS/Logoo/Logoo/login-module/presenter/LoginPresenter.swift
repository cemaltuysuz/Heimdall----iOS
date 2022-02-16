//
//  LoginPresenter.swift
//  Logoo
//
//  Created by cemal tüysüz on 9.02.2022.
//

import Foundation

class LoginPresenter : InteractorToPresenterLoginProtocol, ViewToPresenterLoginProtocol {
        
    var view: PresenterToViewLoginProtocol?
    var interactor: PresenterToInteractorLoginProtocol?
    
    func timeLimitCountinues(status: Bool, continuationTime: Int64?) {
        view?.timeLimitCountinues(status: status, continuationTime: continuationTime)
    }
    
    func calculateRepeatTime() {
        interactor?.calculateRepeatTime()
    }
    
    func loginUser(mail: String, password: String) {
        interactor?.loginUser(mail: mail, password: password)
    }
    
    func loginResponse(status: Resource<UserState>) {
        view?.loginResponse(status: status)
    }
    
    func verificationLinkResponse(status: Resource<Any>) {
        view?.verificationLinkResponse(status: status)
    }
    
    func sendVerificationLink(mail: String) {
        interactor?.sendVerificationLink(mail: mail)
    }
}
