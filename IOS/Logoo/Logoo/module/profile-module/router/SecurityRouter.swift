//
//  SecurityRouter.swift
//  Logoo
//
//  Created by cemal tüysüz on 15.03.2022.
//

import Foundation

class SecurityRouter : PresenterToRouterSecurityProtocol {
    
    static func createModule(ref: SecurityVC) {
        let p = SecurityPresenter()
        ref.presenter = p
        ref.presenter?.view = ref
        ref.presenter?.interactor = SecurityInteractor()
        ref.presenter?.interactor?.presenter = p
    }
}
