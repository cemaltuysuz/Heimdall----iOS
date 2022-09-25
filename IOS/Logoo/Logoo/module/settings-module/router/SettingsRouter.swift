//
//  ProfileSettingsRouter.swift
//  Logoo
//
//  Created by cemal tüysüz on 27.02.2022.
//

import Foundation

class SettingsRouter : PresenterToRouterSettingsProtocol {
    
    static func createModule(ref: SettingsVC) {
        let p = SettingsPresenter()
        ref.presenter = p
        ref.presenter?.interactor = SettingsInteractor()
        ref.presenter?.view = ref
        ref.presenter?.interactor?.presenter = p
    }
}
