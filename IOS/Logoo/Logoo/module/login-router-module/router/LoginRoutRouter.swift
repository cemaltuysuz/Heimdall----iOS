//
//  LoginRoutRouter.swift
//  Logoo
//
//  Created by cemal tüysüz on 11.02.2022.
//

import Foundation

class LoginRoutRouter : PresenterToRouterLoginRouterProtocol{
    
    static func createModule(ref: LoginRouterVC) {
        let presenter = LoginRouterPresenter()
        
        ref.presenter = presenter
        ref.presenter?.interactor = LoginRouterInteractor()
        ref.presenter?.view = ref
        ref.presenter?.interactor?.presenter = presenter
    }
}
