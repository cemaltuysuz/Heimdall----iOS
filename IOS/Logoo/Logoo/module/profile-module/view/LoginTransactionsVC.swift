//
//  LoginTransactionsVC.swift
//  Logoo
//
//  Created by cemal tüysüz on 27.03.2022.
//

import UIKit

class LoginTransactionsVC: UIViewController {
    
    var presenter : ViewToPresenterLoginTransactionsProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createModule()
        presenter?.getLoginTransactions()
    }
    
    func createModule(){
        LoginTransactionRouter.createModule(ref: self)
    }
}

extension LoginTransactionsVC : PresenterToViewLoginTransactionsProtocol {
    
    func transactionsToView(transactions: [UserTransaction]) {
        
    }
}
