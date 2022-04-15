//
//  LoginTransactionsInteractor.swift
//  Logoo
//
//  Created by cemal tüysüz on 27.03.2022.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class LoginTransactionsInteractor : PresenterToInteractorLoginTransactionsProtocol{
    var presenter: InteractorToPresenterLoginTransactionsProtocol?
    
    func getLoginTransactions() {
        if let uid = Auth.auth().currentUser?.uid {
            let ref = Firestore.firestore().collection(FireStoreCollection.LOG_COLLECTION).document(uid).collection(uid)
            
            FireStoreService.shared.getDocumentsByField(ref: ref, getByField: "event", getByValue: LogEventType.USER_SIGN_IN.rawValue, onCompletion: {(transactions:[UserTransaction?]?,error:Error?) in
                if let error = error {
                    print(error)
                    return
                }
                
                var nonOptionalTransactions = [UserTransaction]()
                if let transactions = transactions {
                    for transaction in transactions {
                        if let transaction = transaction {
                            print(transaction)
                            nonOptionalTransactions.append(transaction)
                        }
                    }
                }
                if !nonOptionalTransactions.isEmpty {
                    self.presenter?.transactionsToPresenter(transactions: nonOptionalTransactions.sorted(by: {$0.timestamp ?? 0 > $1.timestamp ?? 0}))
                }
            })
        }
    }
}
