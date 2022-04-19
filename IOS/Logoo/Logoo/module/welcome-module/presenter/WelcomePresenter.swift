//
//  WelcomePresenter.swift
//  Logoo
//
//  Created by cemal tüysüz on 17.02.2022.
//

import Foundation

class WelcomePresenter: ViewToPresenterWelcomeProtocol, InteractorToPresenterWelcomeProtocol {
    
    var view: PresenterToViewWelcomeProtocol?
    var interactor: PresenterToInteractorWelcomeProtocol?
    
    func routeUser() {
        interactor?.routeUser()
    }
    
    func onStateChange(_ state: WelcomeState) {
        view?.onStateChange(state)
    }
}
