//
//  File.swift
//  Logoo
//
//  Created by cemal tüysüz on 17.02.2022.
//

import Foundation

class WelcomeRouter : PresenterToRouterWelcomeProtocol {
    
    static func createModule(ref: WelcomeVC) {
        let presenter = WelcomePresenter()
        ref.presenter = presenter
        ref.presenter?.interactor = WelcomeInteractor()
        ref.presenter?.view = ref
        ref.presenter?.interactor?.presenter = presenter
    }
}
