//
//  LoginTransactionsPresenter.swift
//  Logoo
//
//  Created by cemal tüysüz on 27.03.2022.
//

import Foundation

class LoginTransactionsPresenter : ViewToPresenterLoginTransactionsProtocol, InteractorToPresenterLoginTransactionsProtocol{
    var view: PresenterToViewLoginTransactionsProtocol?
    
    var interactor: PresenterToInteractorLoginTransactionsProtocol?
    
    func getLoginTransactions() {
        interactor?.getLoginTransactions()
    }
    
    func transactionsToPresenter(transactions: [UserTransaction]) {
        view?.transactionsToView(transactions: transactions)
    }
}
