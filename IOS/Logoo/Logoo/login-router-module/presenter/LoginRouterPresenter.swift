//
//  LoginRouterPresenter.swift
//  Logoo
//
//  Created by cemal tüysüz on 11.02.2022.
//

import Foundation

class LoginRouterPresenter : InteractorToPresenterLoginRouterProtocol, ViewToPresenterLoginRouterProtocol {
    
    var view: PresenterToViewLoginRouterProtocol?
    var interactor: PresenterToInteractorLoginRouterProtocol?
    
    func loginToHomeVC() {
        view?.loginToHomeVC()
    }

    func loginToInterestSelectionVC(userId: String) {
        view?.loginToInterestSelectionVC(userId: userId)

    }
    
    func loginToErrorVC(message: String) {
        view?.loginToErrorVC(message: message)
    }
    
    func route() {
        interactor?.route()
    }
}
