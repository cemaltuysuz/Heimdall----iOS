//
//  LoginTransactionsRouter.swift
//  Logoo
//
//  Created by cemal tüysüz on 27.03.2022.
//

import Foundation
import UIKit

class LoginTransactionRouter : PresenterToRouterLoginTransactionsProtocol {
    
    static func createModule(ref: LoginTransactionsVC) {
        let p = LoginTransactionsPresenter()
        ref.presenter = p
        ref.presenter?.view = ref
        ref.presenter?.interactor = LoginTransactionsInteractor()
        ref.presenter?.interactor?.presenter = p
    }
}
