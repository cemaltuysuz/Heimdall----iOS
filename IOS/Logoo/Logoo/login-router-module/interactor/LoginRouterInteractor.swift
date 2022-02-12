//
//  LoginRouterInteractor.swift
//  Logoo
//
//  Created by cemal tüysüz on 11.02.2022.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class LoginRouterInteractor : PresenterToInteractorLoginRouterProtocol{
    var presenter: InteractorToPresenterLoginRouterProtocol?
    
    // Kullanıcıyı hangi sayfaya yönlendireceğim ile ilgili bir algoritma.
    func route() {
        if let userID = Auth.auth().currentUser?.uid {
            let dbRef = Firestore.firestore()
            dbRef.collection("users").document(userID).getDocument{(document,error) in
                if let document = document, document.exists {
                    let userBio = document.get("userBio") as? String ?? ""
                    
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

/***
 guard error == nil else {
     self.presenter?.loginToErrorVC(message: error!.localizedDescription)
     return;
   }
 
 if let detail =  snapshot.value as? NSDictionary {
     let userBio = detail["userBio"] as? String ?? ""
     
     
 }
 */
