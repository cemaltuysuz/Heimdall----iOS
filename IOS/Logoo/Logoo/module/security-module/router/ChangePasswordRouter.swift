//
//  ChangePasswordRouter.swift
//  Logoo
//
//  Created by cemal tüysüz on 5.04.2022.
//

import Foundation

class ChangePasswordRouter : PresenterToRouterChangePasswordProtocol {
    
    static func createModule(ref: ChangePasswordVC) {
        let p = ChangePasswordPresenter()
        ref.presenter = p
        ref.presenter?.view = ref
        ref.presenter?.interactor = ChangePasswordInteractor()
        ref.presenter?.interactor?.presenter = p
    }
}
