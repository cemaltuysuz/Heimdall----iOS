//
//  ProfileRouter.swift
//  Logoo
//
//  Created by cemal tüysüz on 7.04.2022.
//

import Foundation

class ProfileRouter : PresenterToRouterProfileProtocol {
    
    static func createModule(ref: ProfileVC) {
        let p = ProfilePresenter()
        ref.presenter = p
        ref.presenter?.interactor = ProfileInteractor()
        ref.presenter?.view = ref
        ref.presenter?.interactor?.presenter = p
    }
}
