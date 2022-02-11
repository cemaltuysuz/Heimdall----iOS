//
//  LoginRouterInteractor.swift
//  Logoo
//
//  Created by cemal tüysüz on 11.02.2022.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class LoginRouterInteractor : PresenterToInteractorLoginRouterProtocol{
    var presenter: InteractorToPresenterLoginRouterProtocol?
    
    // Kullanıcıyı hangi sayfaya yönlendireceğim ile ilgili bir algoritma.
    func route() {
        if let userID = Auth.auth().currentUser?.uid {
            let dbRef = Database.database().reference()
            print(userID)
            dbRef.child("users").child(userID).getData{ (error,snapshot) in
                
                guard error == nil else {
                    self.presenter?.loginToErrorVC(message: error!.localizedDescription)
                    return;
                  }
                
                if let detail =  snapshot.value as? NSDictionary {
                    let userBio = detail["userBio"] as? String ?? ""
                    
                    if userBio.isEmpty {
                        self.presenter?.loginToInterestSelectionVC(userId: userID)
                    }else {
                        self.presenter?.loginToHomeVC()
                    }
                }
            }
        }
    }
    
    
}
