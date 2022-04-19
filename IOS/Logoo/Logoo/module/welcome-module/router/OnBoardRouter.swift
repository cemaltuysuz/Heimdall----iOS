//
//  OnBoardRouter.swift
//  Logoo
//
//  Created by cemal tüysüz on 20.01.2022.
//

import Foundation

class OnBoardRouter : PresenterToRouterOnBoardProtocol {
    static func createModule(ref: OnBoardVC) {
        let presenter = OnBoardPresenter()
        
        ref.presenter = presenter
        ref.presenter?.interactor = OnBoardInteractor()
        ref.presenter?.view = ref
        ref.presenter?.interactor?.presenter = presenter
    }
}
