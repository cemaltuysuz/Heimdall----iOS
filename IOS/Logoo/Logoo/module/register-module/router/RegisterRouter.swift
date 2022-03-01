//
//  RegisterRouter.swift
//  Logoo
//
//  Created by cemal tüysüz on 3.02.2022.
//

import Foundation

class RegisterRouter : PresenterToRouterRegisterMail {
    static func createModule(ref: RegisterVC) {
        
        let presenter = RegisterPresenter()
        
        ref.presenter = presenter
        ref.presenter?.view = ref
        ref.presenter?.interactor = RegisterInteractor()
        ref.presenter?.interactor?.presenter = presenter
    }
}
