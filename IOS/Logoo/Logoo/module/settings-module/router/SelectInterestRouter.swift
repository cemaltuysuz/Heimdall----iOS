//
//  SelectInterestRouter.swift
//  Logoo
//
//  Created by cemal tüysüz on 11.02.2022.
//

import Foundation

class SelectInterestRouter : PresenterToRouterInterestSelectProtocol {
    static func createModule(ref: SelectInterestVC) {
        let p = SelectInterestPresenter()
        
        ref.presenter = p
        ref.presenter?.interactor = SelectInterestInteractor()
        ref.presenter?.view = ref
        ref.presenter?.interactor?.presenter = p
    }
}
