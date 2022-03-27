//
//  LoginTransactionsProtocols.swift
//  Logoo
//
//  Created by cemal tüysüz on 27.03.2022.
//

import Foundation

protocol ViewToPresenterLoginTransactionsProtocol {
    var view:PresenterToViewLoginTransactionsProtocol? {get set}
    var interactor:PresenterToInteractorLoginTransactionsProtocol? {get set}
    
    func getLoginTransactions()
}

protocol PresenterToInteractorLoginTransactionsProtocol {
    var presenter:InteractorToPresenterLoginTransactionsProtocol? {get set}
    func getLoginTransactions()
}

protocol InteractorToPresenterLoginTransactionsProtocol {
    func transactionsToPresenter(transactions:[UserTransaction])
}

protocol PresenterToViewLoginTransactionsProtocol {
    func transactionsToView(transactions:[UserTransaction])
}

protocol PresenterToRouterLoginTransactionsProtocol {
    static func createModule(ref:LoginTransactionsVC)
}
