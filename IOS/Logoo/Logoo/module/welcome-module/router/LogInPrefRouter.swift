//
//  LogInPrefRouter.swift
//  Logoo
//
//  Created by cemal tüysüz on 17.02.2022.
//

import Foundation

class LogInPrefRouter : PresenterToRouterLoginPref {
    
    static func createModule(ref: LoginPrefVC) {
        let p = LoginPrefPresenter()
        ref.presenter = p
        ref.presenter?.view = ref
        ref.presenter?.interactor = LoginPrefInteractor()
        ref.presenter?.interactor?.presenter = p
    }
}
