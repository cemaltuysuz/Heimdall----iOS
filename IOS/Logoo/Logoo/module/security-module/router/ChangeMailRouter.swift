//
//  ChangeMailRouter.swift
//  Logoo
//
//  Created by cemal tüysüz on 5.04.2022.
//

import Foundation

class ChangeMailRouter : PresenterToRouterChangeMailProtocol {
    
    static func createModule(ref: ChangeMailVC) {
        let p = ChangeMailPresenter()
        ref.presenter = p
        ref.presenter?.view = ref
        ref.presenter?.interactor = ChangeMailInteractor()
        ref.presenter?.interactor?.presenter = p
    }
}
