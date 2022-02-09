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
    
    func loginUser(mail: String, password: String) {
        interactor?.loginUser(mail: mail, password: password)
    }
    
    func loginResponse(status: Resource<UserState>) {
        view?.loginResponse(status: status)
    }
}
