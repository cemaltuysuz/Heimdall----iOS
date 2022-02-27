//
//  ProfileSettingsRouter.swift
//  Logoo
//
//  Created by cemal tüysüz on 27.02.2022.
//

import Foundation

class ProfileSettingsRouter : PresenterToRouterProfileSettingsProtocol {
    
    static func createModule(ref: ProfileSettingsVC) {
        let p = ProfileSettingsPresenter()
        ref.presenter = p
        ref.presenter?.interactor = ProfileSettingsInteractor()
        ref.presenter?.view = ref
        ref.presenter?.interactor?.presenter = p
    }
}
