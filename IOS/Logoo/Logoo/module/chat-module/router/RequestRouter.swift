//
//  RequestRouter.swift
//  Logoo
//
//  Created by cemal tüysüz on 27.05.2022.
//

import Foundation

class RequestRouter: PresenterToRouterRequestProtocol {
    
    static func createModule(ref: RequestVC) {
        
        let p = RequestPresenter()
        ref.presenter = p
        ref.presenter?.view = ref
        ref.presenter?.interactor = RequestInteractor()
        ref.presenter?.interactor?.presenter = p
        
    }
}
