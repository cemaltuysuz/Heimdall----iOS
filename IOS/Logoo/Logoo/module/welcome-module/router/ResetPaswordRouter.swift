//
//  ResetPaswordRouter.swift
//  Logoo
//
//  Created by cemal tüysüz on 16.02.2022.
//

import Foundation

class ResetPasswordRouter : PresenterToRouterResetPasswordProtocol {
    static func createModule(ref: ResetPasswordVC) {
        let presenter = ResetPasswordPresenter()
        
        ref.presenter = presenter
        ref.presenter?.interactor = ResetPasswordInteractor()
        ref.presenter?.view = ref
        ref.presenter?.interactor?.presenter = presenter
    }
}
