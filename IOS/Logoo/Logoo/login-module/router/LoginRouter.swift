//
//  LoginRouter.swift
//  Logoo
//
//  Created by cemal tüysüz on 10.02.2022.
//

import Foundation

class LoginRouter : PresenterToRouterLoginProtocol {
    
    static func createModule(ref: LoginVC) {
        let presenter = LoginPresenter()
        
        ref.presenter = presenter
        ref.presenter?.view = ref
        ref.presenter?.interactor = LoginInteractor()
        ref.presenter?.interactor?.presenter = presenter
        
        
    }
}
